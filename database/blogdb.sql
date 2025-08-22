-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 22, 2025 at 04:30 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blogdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `created_at`, `updated_at`) VALUES
(7, 1, 'The Future of Web Development: Trends to Watch in 2024', 'Web development is evolving at an unprecedented pace, and 2024 promises to bring exciting new trends that will reshape how we build and interact with websites. In this comprehensive guide, we\'ll explore the most significant trends that every developer and business owner should be aware of.', '2025-08-22 14:28:57', '2025-08-22 14:28:57'),
(8, 3, 'UI/UX Design Principles That Convert Visitors to Customers', 'Great design is more than just aesthetics—it\'s about creating experiences that guide users toward taking action. In this article, we\'ll explore the fundamental UI/UX principles that can significantly improve your conversion rates.\r\n\r\n1. Clear Value Proposition\r\nYour visitors should understand what you offer within seconds of landing on your page. A clear, compelling value proposition placed prominently on your homepage is crucial for keeping visitors engaged.\r\n\r\n2. Intuitive Navigation\r\nUsers should never feel lost on your website. Implement clear, logical navigation structures with descriptive labels. Breadcrumbs, search functionality, and a well-organized menu system all contribute to better user experience.\r\n\r\n3. Responsive Design\r\nWith mobile traffic accounting for over 50% of web browsing, responsive design isn\'t optional—it\'s essential. Your website must provide an excellent experience across all devices and screen sizes.', '2025-08-22 14:29:40', '2025-08-22 14:29:40'),
(9, 1, 'Building Responsive Websites: A Complete Guide', 'With users accessing websites from a wide range of devices—smartphones, tablets, laptops, and desktops—responsive web design is no longer optional; it\'s a necessity. A responsive website ensures your content looks great and functions well on every screen size. This complete guide will walk you through the fundamentals, tools, and best practices for building fully responsive websites.', '2025-08-22 14:30:21', '2025-08-22 14:30:21');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `created_at`) VALUES
(1, 'admin', 'admin@example.com', 'admin123', '2025-08-22 12:44:27'),
(3, 'BrianMwenda', 'Ndumbabrian425@gmail.com', '', '2025-08-22 14:09:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
