package main

import (
	"database/sql"
	"fmt"
	"html/template"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB
var tmpl *template.Template

func main() {
	var err error
	// connect without password
	db, err = sql.Open("mysql", "root@tcp(127.0.0.1:3306)/blogdb")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	tmpl = template.Must(template.ParseGlob("templates/*.html"))

	http.HandleFunc("/templates/static/style.css", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/css")
		http.ServeFile(w, r, "static/style.css")
	})

	http.HandleFunc("/", indexHandler)
	http.HandleFunc("/users", usersHandler)
	http.HandleFunc("/posts", postsHandler)     // show all posts grouped by user
	http.HandleFunc("/newpost", newPostHandler) // create new post

	fmt.Println("Server started at :8080")
	http.ListenAndServe(":8080", nil)
}

type User struct {
	ID       int
	Username string
	Email    string
	Posts    []Post
}

type Post struct {
	ID      int
	Title   string
	Content string
	UserID  int
	User    string
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	tmpl.ExecuteTemplate(w, "index.html", nil)
}

// --- USERS ---
func usersHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		username := r.FormValue("username")
		email := r.FormValue("email")

		if username == "" || email == "" {
			http.Error(w, "username and email are required", http.StatusBadRequest)
			return
		}

		_, err := db.Exec("INSERT INTO users (username, email) VALUES (?, ?)", username, email)
		if err != nil {
			http.Error(w, "Failed to insert user: "+err.Error(), http.StatusInternalServerError)
			return
		}

		http.Redirect(w, r, "/users", http.StatusSeeOther)
		return
	}

	rows, err := db.Query("SELECT id, username, email FROM users")
	if err != nil {
		http.Error(w, "Failed to query users: "+err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var users []User
	for rows.Next() {
		var u User
		if err := rows.Scan(&u.ID, &u.Username, &u.Email); err != nil {
			http.Error(w, "Scan error: "+err.Error(), http.StatusInternalServerError)
			return
		}
		users = append(users, u)
	}
	if err := rows.Err(); err != nil {
		http.Error(w, "Row iteration error: "+err.Error(), http.StatusInternalServerError)
		return
	}

	tmpl.ExecuteTemplate(w, "users.html", users)
}

// --- POSTS ---
func postsHandler(w http.ResponseWriter, r *http.Request) {
	// Get all users
	userRows, err := db.Query("SELECT id, username, email FROM users")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer userRows.Close()

	var users []User
	for userRows.Next() {
		var u User
		userRows.Scan(&u.ID, &u.Username, &u.Email)

		// Get posts for this user
		postRows, err := db.Query("SELECT id, title, content FROM posts WHERE user_id = ?", u.ID)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		for postRows.Next() {
			var p Post
			postRows.Scan(&p.ID, &p.Title, &p.Content)
			u.Posts = append(u.Posts, p)
		}
		postRows.Close()

		users = append(users, u)
	}

	tmpl.ExecuteTemplate(w, "posts.html", users)
}

// --- NEW POST ---
func newPostHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		// Load all users for dropdown
		rows, err := db.Query("SELECT id, username FROM users")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var users []User
		for rows.Next() {
			var u User
			if err := rows.Scan(&u.ID, &u.Username); err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			users = append(users, u)
		}

		tmpl.ExecuteTemplate(w, "newpost.html", users)
		return
	}

	if r.Method == "POST" {
		title := r.FormValue("title")
		content := r.FormValue("content")
		userID := r.FormValue("user_id")

		_, err := db.Exec("INSERT INTO posts (user_id, title, content) VALUES (?, ?, ?)", userID, title, content)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		http.Redirect(w, r, "/posts", http.StatusSeeOther)
	}
}
