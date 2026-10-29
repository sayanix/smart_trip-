-- ==============================================================
-- SmartTrip Application - MySQL Database Schema & Seed Data
-- Designed for WampServer MySQL / phpMyAdmin (Port 3306)
-- Database Name: smart_trip_db
-- Generated for BSc SE University Project
-- ==============================================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------------
-- 1. DATABASE INITIALIZATION
-- --------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `smart_trip_db` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `smart_trip_db`;

-- --------------------------------------------------------------
-- 2. DROP EXISTING TABLES (Reverse Dependency Order)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `saved_trips`;
DROP TABLE IF EXISTS `booking_items`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `trips`;
DROP TABLE IF EXISTS `inventory_items`;
DROP TABLE IF EXISTS `vendors`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `config_itinerary_items`;
DROP TABLE IF EXISTS `config_workflows`;
DROP TABLE IF EXISTS `config_banks`;
DROP TABLE IF EXISTS `config_preferences`;
DROP TABLE IF EXISTS `config_destinations`;
DROP TABLE IF EXISTS `config_services`;
DROP TABLE IF EXISTS `config_cities`;
DROP TABLE IF EXISTS `config_provinces`;

-- --------------------------------------------------------------
-- 3. TABLE DEFINITIONS
-- --------------------------------------------------------------

-- Config: Provinces
CREATE TABLE `config_provinces` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL UNIQUE,
  `code` VARCHAR(20) NOT NULL UNIQUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Config: Cities
CREATE TABLE `config_cities` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `province` VARCHAR(100) NOT NULL,
  `region` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_city_province` (`province`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Config: Services
CREATE TABLE `config_services` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Config: Destinations
CREATE TABLE `config_destinations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL UNIQUE,
  `tag` VARCHAR(50) NOT NULL,
  `emoji` VARCHAR(20) DEFAULT NULL,
  `defaultDays` INT DEFAULT 3,
  `defaultPrice` DECIMAL(10,2) DEFAULT 0.00,
  `region` VARCHAR(100) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `image` VARCHAR(255) DEFAULT NULL,
  `attractions` JSON DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Config: Preferences
CREATE TABLE `config_preferences` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `category` VARCHAR(50) NOT NULL,
  `value` VARCHAR(100) NOT NULL,
  `label` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_pref_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Config: Banks
CREATE TABLE `config_banks` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `code` VARCHAR(50) NOT NULL UNIQUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Config: Workflows
CREATE TABLE `config_workflows` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `step` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `status` VARCHAR(50) DEFAULT 'pending',
  `step_order` INT DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Config: Itinerary Items (Activities & Base Items)
CREATE TABLE `config_itinerary_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `type` VARCHAR(50) DEFAULT 'activity',
  `price` DECIMAL(10,2) DEFAULT 0.00,
  `destination` VARCHAR(100) DEFAULT NULL,
  `location` VARCHAR(100) DEFAULT NULL,
  `duration` VARCHAR(50) DEFAULT NULL,
  `amenities` JSON DEFAULT NULL,
  `capacity` INT DEFAULT 50,
  `availableCount` INT DEFAULT 45,
  `available` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users Table
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `role` ENUM('user', 'vendor', 'admin') DEFAULT 'user',
  `phone` VARCHAR(50) DEFAULT '',
  `dateOfBirth` VARCHAR(30) DEFAULT '',
  `location` VARCHAR(150) DEFAULT '',
  `preferredLanguage` VARCHAR(50) DEFAULT 'English',
  `bio` TEXT DEFAULT NULL,
  `photo` VARCHAR(255) DEFAULT '',
  `travelInterests` JSON DEFAULT NULL,
  `travelPreferences` JSON DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_user_email` (`email`),
  INDEX `idx_user_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Vendors Table
CREATE TABLE `vendors` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `businessName` VARCHAR(150) NOT NULL,
  `businessType` VARCHAR(100) NOT NULL,
  `registrationNumber` VARCHAR(100) DEFAULT NULL,
  `taxId` VARCHAR(100) DEFAULT NULL,
  `yearEstablished` INT DEFAULT NULL,
  `businessEmail` VARCHAR(150) NOT NULL,
  `businessPhone` VARCHAR(50) NOT NULL,
  `website` VARCHAR(255) DEFAULT NULL,
  `facebook` VARCHAR(255) DEFAULT NULL,
  `instagram` VARCHAR(255) DEFAULT NULL,
  `addressLine1` VARCHAR(255) NOT NULL,
  `addressLine2` VARCHAR(255) DEFAULT NULL,
  `city` VARCHAR(100) NOT NULL,
  `province` VARCHAR(100) NOT NULL,
  `postalCode` VARCHAR(30) DEFAULT NULL,
  `country` VARCHAR(50) DEFAULT 'Sri Lanka',
  `contactName` VARCHAR(100) NOT NULL,
  `contactDesignation` VARCHAR(100) DEFAULT NULL,
  `contactPhone` VARCHAR(50) NOT NULL,
  `contactEmail` VARCHAR(150) NOT NULL,
  `services` JSON DEFAULT NULL,
  `otherServices` TEXT DEFAULT NULL,
  `bankName` VARCHAR(100) DEFAULT NULL,
  `bankBranch` VARCHAR(100) DEFAULT NULL,
  `accountName` VARCHAR(100) DEFAULT NULL,
  `accountNumber` VARCHAR(100) DEFAULT NULL,
  `accountType` VARCHAR(50) DEFAULT NULL,
  `swiftCode` VARCHAR(50) DEFAULT NULL,
  `status` ENUM('pending_review', 'approved', 'rejected', 'suspended') DEFAULT 'pending_review',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inventory Items Table (Vendor Offerings)
CREATE TABLE `inventory_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `vendor_id` INT NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `type` ENUM('accommodation', 'transport', 'activity', 'meal', 'package', 'other') DEFAULT 'other',
  `description` TEXT DEFAULT NULL,
  `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `currency` VARCHAR(10) DEFAULT 'LKR',
  `capacity` INT DEFAULT 1,
  `availableCount` INT DEFAULT 1,
  `images` JSON DEFAULT NULL,
  `amenities` JSON DEFAULT NULL,
  `isActive` TINYINT(1) DEFAULT 1,
  `location` VARCHAR(100) DEFAULT '',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`vendor_id`) REFERENCES `vendors`(`id`) ON DELETE CASCADE,
  INDEX `idx_inventory_type` (`type`),
  INDEX `idx_inventory_location` (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Trips Table
CREATE TABLE `trips` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `tripId` VARCHAR(50) UNIQUE NOT NULL,
  `destination` VARCHAR(100) NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `status` ENUM('pending', 'confirmed', 'rejected', 'completed', 'cancelled') DEFAULT 'pending',
  `date_from` VARCHAR(50) DEFAULT NULL,
  `date_to` VARCHAR(50) DEFAULT NULL,
  `totalCost` DECIMAL(12,2) DEFAULT 0.00,
  `paymentStatus` ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
  `adults` INT DEFAULT 1,
  `children` INT DEFAULT 0,
  `travelerDetails` JSON DEFAULT NULL,
  `bookingDate` VARCHAR(50) DEFAULT NULL,
  `image` VARCHAR(255) DEFAULT '#667eea',
  `duration` VARCHAR(50) DEFAULT NULL,
  `vendor` VARCHAR(150) DEFAULT NULL,
  `specialRequests` TEXT DEFAULT NULL,
  `reviewStatus` ENUM('pending', 'completed', 'none') DEFAULT 'none',
  `timeline` JSON DEFAULT NULL,
  `itinerary` JSON DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bookings Table
CREATE TABLE `bookings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `destination` VARCHAR(100) DEFAULT '',
  `location` VARCHAR(100) DEFAULT '',
  `duration` VARCHAR(50) DEFAULT '',
  `itinerarySummary` JSON DEFAULT NULL,
  `totalCost` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `startDate` VARCHAR(50) DEFAULT NULL,
  `endDate` VARCHAR(50) DEFAULT NULL,
  `adults` INT DEFAULT 1,
  `children` INT DEFAULT 0,
  `infants` INT DEFAULT 0,
  `status` ENUM('pending', 'confirmed', 'rejected', 'cancelled', 'expired') DEFAULT 'pending',
  `expiryDate` DATETIME DEFAULT NULL,
  `specialRequests` TEXT DEFAULT NULL,
  `paymentStatus` ENUM('unpaid', 'paid', 'refunded') DEFAULT 'unpaid',
  `vendorNotes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Booking Items Table (Relationship between booking and inventory items)
CREATE TABLE `booking_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `booking_id` INT NOT NULL,
  `inventory_id` INT DEFAULT NULL,
  `priceAtBooking` DECIMAL(10,2) DEFAULT 0.00,
  FOREIGN KEY (`booking_id`) REFERENCES `bookings`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`inventory_id`) REFERENCES `inventory_items`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Saved Trips (Bookmarks)
CREATE TABLE `saved_trips` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `trip_id` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`trip_id`) REFERENCES `trips`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reviews Table
CREATE TABLE `reviews` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `trip_id` INT DEFAULT NULL,
  `user_id` INT NOT NULL,
  `vendor_id` INT DEFAULT NULL,
  `rating` DECIMAL(2,1) NOT NULL,
  `comment` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`trip_id`) REFERENCES `trips`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`vendor_id`) REFERENCES `vendors`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Notifications Table
CREATE TABLE `notifications` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `title` VARCHAR(150) DEFAULT NULL,
  `message` TEXT NOT NULL,
  `type` VARCHAR(50) DEFAULT 'info',
  `isRead` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 4. SEED DATA INSERTION
-- --------------------------------------------------------------

-- Insert Provinces
INSERT INTO `config_provinces` (`name`, `code`) VALUES
('Western', 'WR'),
('Central', 'CP'),
('Southern', 'SR'),
('Northern', 'NR'),
('Eastern', 'ER'),
('North Western', 'NWR'),
('North Central', 'NCR'),
('Uva', 'UV'),
('Sabaragamuwa', 'SB');

-- Insert Cities
INSERT INTO `config_cities` (`name`, `province`, `region`) VALUES
('Colombo', 'Western', 'City'),
('Kandy', 'Central', 'Hill Country'),
('Galle', 'Southern', 'Coastal'),
('Jaffna', 'Northern', 'Beach'),
('Negombo', 'Western', 'Coastal'),
('Anuradhapura', 'North Central', 'Heritage'),
('Trincomalee', 'Eastern', 'Beach'),
('Batticaloa', 'Eastern', 'Beach'),
('Nuwara Eliya', 'Central', 'Hill Country'),
('Ella', 'Uva', 'Hill Country'),
('Sigiriya', 'Central', 'Heritage'),
('Yala', 'Southern', 'Wildlife'),
('Mirissa', 'Southern', 'Beach'),
('Dambulla', 'Central', 'Heritage'),
('Hikkaduwa', 'Southern', 'Beach'),
('Bentota', 'Southern', 'Beach');

-- Insert Services
INSERT INTO `config_services` (`name`, `category`) VALUES
('Accommodation (Hotels/Guest Houses)', 'accommodation'),
('Accommodation with Breakfast', 'accommodation'),
('Accommodation with Full Board', 'accommodation'),
('Vehicle Rental', 'transport'),
('Tour Guide Services', 'activity'),
('Activity/Experience Packages', 'activity'),
('Restaurant Services', 'meal'),
('Transport Services', 'transport'),
('Travel Packages', 'package');

-- Insert Destinations
INSERT INTO `config_destinations` (`name`, `tag`, `emoji`, `defaultDays`, `defaultPrice`, `region`, `description`, `image`, `attractions`) VALUES
('Kandy', 'Cultural', '🛕', 3, 45000.00, 'Kandy', 'Ancient temples & scenic hills', '/images/destinations/kandy.jpg', '["Temple of the Tooth", "Kandy Lake", "Royal Palace", "Botanical Gardens"]'),
('Galle', 'Coastal', '🏰', 4, 55000.00, 'Galle', 'Dutch fort & pristine beaches', '/images/destinations/galle.jpg', '["Galle Fort", "Unawatuna Beach", "Japanese Peace Pagoda", "Lighthouse Point"]'),
('Ella', 'Hill Country', '🌿', 3, 40000.00, 'Ella', 'Tea country & breathtaking views', '/images/destinations/ella.jpg', '["Ella Rock", "Nine Arch Bridge", "Tea Plantations", "Ravana Falls"]'),
('Sigiriya', 'Heritage', '🏯', 2, 50000.00, 'Sigiriya', 'Ancient rock fortress wonder', '/images/destinations/sigiriya.jpg', '["Lion Rock", "Ancient Paintings", "Mirror Wall", "Royal Gardens"]'),
('Yala', 'Wildlife', '🐘', 2, 60000.00, 'Yala', 'Premier safari experience', '/images/destinations/yala.png', '["Safari Tours", "Leopard Spotting", "Crocodile Ponds", "Bird Watching"]'),
('Nuwara Eliya', 'Nature', '🍃', 3, 48000.00, 'Nuwara Eliya', 'Cool climate & tea estates', '/images/destinations/nuwaraeliya.jpg', '["Gregory Lake", "Horton Plains", "Tea Factory Visit", "Post Office Hill"]'),
('Mirissa', 'Beach', '🐋', 3, 42000.00, 'Mirissa', 'Whale watching & golden sands', '', '["Whale Watching Tours", "Mirissa Beach", "Parrot Rock", "Sunset Boat Rides"]'),
('Trincomalee', 'Beach', '🌊', 4, 52000.00, 'Trincomalee', 'Crystal waters & diving spots', '', '["Pigeon Island", "Fort Frederick", "Arugambe Beach", "Scuba Diving"]'),
('Anuradhapura', 'Heritage', '🕌', 2, 38000.00, 'Anuradhapura', 'Sacred city & ancient ruins', '', '["Sacred Bodhi Tree", "Jetavana Stupa", "Abhayagiri Stupa", "Ancient Monasteries"]'),
('Colombo', 'City', '🌆', 2, 35000.00, 'Colombo', 'Vibrant capital & street food', '', '["Old Parliament", "Galle Face Hotel", "National Museum", "Beach Boulevard"]'),
('Dambulla', 'Heritage', '🏛️', 2, 36000.00, 'Dambulla', 'Cave temples & rock paintings', '', '["Golden Temple", "Dambulla Cave Temples", "Rock Carvings", "Spice Gardens"]'),
('Hikkaduwa', 'Beach', '🤿', 3, 44000.00, 'Hikkaduwa', 'Coral reefs & surf breaks', '', '["Coral Sanctuary", "Turtle Hatchery", "Hikkaduwa Beach", "Surfing Spots"]');

-- Insert Preferences
INSERT INTO `config_preferences` (`category`, `value`, `label`) VALUES
('travelStyle', 'adventure', 'Adventure'),
('travelStyle', 'family', 'Family'),
('travelStyle', 'luxury', 'Luxury'),
('travelStyle', 'budget', 'Budget'),
('travelStyle', 'relaxation', 'Relaxation'),
('accommodationType', 'hotel', 'Hotel'),
('accommodationType', 'villa', 'Villa'),
('accommodationType', 'resort', 'Resort'),
('accommodationType', 'boutique', 'Boutique Hotel'),
('accommodationType', 'guesthouse', 'Guest House'),
('accommodationType', 'airbnb', 'AirBnB'),
('mealPlan', 'breakfast', 'Breakfast'),
('mealPlan', 'half-board', 'Half Board'),
('mealPlan', 'full-board', 'Full Board'),
('mealPlan', 'all-inclusive', 'All Inclusive'),
('activityInterest', 'hiking', 'Hiking'),
('activityInterest', 'wildlife', 'Wildlife'),
('activityInterest', 'photography', 'Photography'),
('activityInterest', 'snorkeling', 'Snorkeling'),
('activityInterest', 'spa', 'Spa'),
('activityInterest', 'sunset-cruise', 'Sunset Cruises'),
('travelInterest', 'nature', 'Nature'),
('travelInterest', 'adventure', 'Adventure'),
('travelInterest', 'cultural', 'Cultural'),
('travelInterest', 'beach', 'Beach'),
('travelInterest', 'food', 'Food'),
('travelInterest', 'relaxation', 'Relaxation'),
('language', 'english', 'English'),
('language', 'sinhala', 'Sinhala'),
('language', 'tamil', 'Tamil'),
('dietaryRestriction', 'vegetarian', 'Vegetarian'),
('dietaryRestriction', 'vegan', 'Vegan'),
('dietaryRestriction', 'halal', 'Halal'),
('dietaryRestriction', 'kosher', 'Kosher'),
('dietaryRestriction', 'gluten-free', 'Gluten Free'),
('accessibility', 'wheelchair', 'Wheelchair Accessible'),
('accessibility', 'mobility', 'Mobility Assistance'),
('accessibility', 'hearing', 'Hearing Accessibility'),
('accessibility', 'visual', 'Visual Accessibility');

-- Insert Banks
INSERT INTO `config_banks` (`name`, `code`) VALUES
('Bank of Ceylon', 'BOC'),
('Commercial Bank', 'COMB'),
("People's Bank", 'PB'),
('Sampath Bank', 'SMTH'),
('Hatton National Bank', 'HNB'),
('NDB Bank', 'NDB'),
('DFCC Bank', 'DFCC'),
('Nations Trust Bank', 'NTB'),
('BOC Digital', 'BOCD'),
('Seylan Bank', 'SEYLAN');

-- Insert Workflows
INSERT INTO `config_workflows` (`step`, `name`, `description`, `status`, `step_order`) VALUES
(1, 'Booking Submitted', 'User submits booking request', 'completed', 1),
(2, 'Vendor Approval', 'Vendor reviews and approves booking', 'pending', 2),
(3, 'Confirmed', 'Trip is confirmed by vendor', 'pending', 3),
(4, 'Trip Completed', 'Trip is completed and payment cleared', 'pending', 4);

-- Insert Config Itinerary Items (Activities)
INSERT INTO `config_itinerary_items` (`name`, `category`, `type`, `price`, `destination`, `location`, `duration`, `amenities`, `capacity`, `availableCount`, `available`) VALUES
('Temple of the Tooth Visit', 'Cultural', 'activity', 3500.00, 'Kandy', 'Kandy', '2-3 hours', '["Guided Tour", "Audio Guide", "Photography Allowed"]', 50, 45, 1),
('Kandy Lake Walk & Photography', 'Nature', 'activity', 2500.00, 'Kandy', 'Kandy', '1-2 hours', '["Scenic Views", "Walking Guide"]', 30, 28, 1),
('Spice Garden Tour', 'Nature', 'activity', 4000.00, 'Kandy', 'Kandy', '2 hours', '["Herbal Tea Tasting", "Plant Identification", "Gift Shop"]', 40, 35, 1),
('Galle Fort Exploration', 'Heritage', 'activity', 2000.00, 'Galle', 'Galle', '3 hours', '["Historical Guide", "Map Included"]', 60, 52, 1),
('Galle Beach Sunset Tour', 'Beach', 'activity', 3000.00, 'Galle', 'Galle', '2 hours', '["Refreshments", "Sunset Viewing Point"]', 45, 40, 1),
('Diving & Water Sports', 'Adventure', 'activity', 8500.00, 'Galle', 'Galle', '4 hours', '["Certified Instructor", "Scuba Gear", "Safety Briefing"]', 20, 14, 1),
('Nine Arch Bridge Trek', 'Adventure', 'activity', 1500.00, 'Ella', 'Ella', '2 hours', '["Trail Guide", "Train Spotting Time"]', 50, 48, 1),
('Tea Plantation Tour', 'Nature', 'activity', 3500.00, 'Ella', 'Ella', '3 hours', '["Tea Plucking Experience", "Tea Tasting", "Factory Tour"]', 35, 30, 1),
('Sunrise Hike to Little Adam''s Peak', 'Adventure', 'activity', 2500.00, 'Ella', 'Ella', '2.5 hours', '["Sunrise Guide", "Snack Pack"]', 40, 36, 1),
('Sigiriya Rock Fortress Climb', 'Heritage', 'activity', 3500.00, 'Sigiriya', 'Sigiriya', '3 hours', '["Archaeological Guide", "Water Bottle"]', 100, 85, 1),
('Lion Rock Sunset Experience', 'Nature', 'activity', 4500.00, 'Sigiriya', 'Sigiriya', '2.5 hours', '["Private Viewing Point", "Evening Tea"]', 30, 25, 1),
('Ancient Heritage Walking Tour', 'Cultural', 'activity', 3000.00, 'Sigiriya', 'Sigiriya', '2 hours', '["Local Historian", "Ancient Moats View"]', 40, 38, 1),
('Yala National Park Safari', 'Wildlife', 'activity', 12000.00, 'Yala', 'Yala', '4-5 hours', '["4x4 Safari Jeep", "Tracker Guide", "Binoculars", "Park Entry"]', 24, 18, 1),
('Bird Watching Expedition', 'Nature', 'activity', 8000.00, 'Yala', 'Yala', '3 hours', '["Ornithologist Guide", "Species Checklist"]', 15, 12, 1),
('Colombo City Heritage Tour', 'City', 'activity', 3000.00, 'Colombo', 'Colombo', '3 hours', '["Air-conditioned Van", "Colonial History Guide"]', 30, 26, 1),
('Street Food Culinary Tour', 'Food', 'activity', 2500.00, 'Colombo', 'Colombo', '2.5 hours', '["Food Tastings (5 Stops)", "Local Host"]', 25, 20, 1),
('Whale Watching Tour', 'Beach', 'activity', 6500.00, 'Mirissa', 'Mirissa', '4 hours', '["Licensed Boat", "Life Jackets", "Breakfast on Board"]', 50, 42, 1),
('Beach Sunrise Yoga & Meditation', 'Relaxation', 'activity', 2000.00, 'Mirissa', 'Mirissa', '1.5 hours', '["Certified Instructor", "Yoga Mat Provided"]', 20, 18, 1);

-- Insert Users
-- Passwords hashed with bcrypt:
-- Admin@123 -> $2a$10$vI8aWBnW3fID.ZQ4/zo1G.qH0vJeqe7d/rOa19QxUj2gR1jB8q75i (or sample working hash)
-- User@123  -> $2a$10$y5Xq2P17.Bf1/q9mF1UeO.YJ6Vp69LqZ2t1nL1C8s8k6l0w2e4r6t
-- Vendor@123-> $2a$10$7Z8q2P17.Bf1/q9mF1UeO.YJ6Vp69LqZ2t1nL1C8s8k6l0w2e4r6t
INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `phone`, `dateOfBirth`, `location`, `preferredLanguage`, `bio`, `photo`, `travelInterests`, `travelPreferences`) VALUES
(1, 'Admin User', 'admin@smarttrip.lk', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'admin', '+94 77 000 0001', '', 'Colombo, Sri Lanka', 'English', 'Platform administrator for SmartTrip.', 'https://api.dicebear.com/7.x/initials/svg?seed=Admin', '[]', '{}'),
(2, 'Thisara Perera', 'thisara@example.com', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'user', '+94 71 234 5678', '1995-06-15', 'Kandy, Sri Lanka', 'English', 'Passionate traveller who loves exploring hill country routes.', 'https://api.dicebear.com/7.x/initials/svg?seed=Thisara', '["Nature", "Adventure", "Cultural"]', '{"accommodationType": ["Hotel", "Villa"], "mealPlan": "all-inclusive", "budgetRange": 75, "travelStyle": "adventure", "activityInterests": ["Hiking", "Wildlife", "Photography"]}'),
(3, 'Nimasha Silva', 'nimasha@example.com', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'user', '+94 76 987 6543', '1998-03-22', 'Galle, Sri Lanka', 'English', 'Beach lover and food enthusiast.', 'https://api.dicebear.com/7.x/initials/svg?seed=Nimasha', '["Beach", "Food", "Relaxation"]', '{"accommodationType": ["Resort", "Boutique Hotel"], "mealPlan": "breakfast", "budgetRange": 60, "travelStyle": "luxury", "activityInterests": ["Snorkeling", "Spa", "Sunset Cruises"]}'),
(4, 'Roshan De Silva', 'roshan.vendor@example.com', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'vendor', '+94 72 111 2222', '', 'Colombo, Sri Lanka', 'English', '', 'https://api.dicebear.com/7.x/initials/svg?seed=Roshan', '[]', '{}'),
(5, 'Amaya Tours', 'amaya.vendor@example.com', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'vendor', '+94 77 333 4444', '', 'Negombo, Sri Lanka', 'English', '', 'https://api.dicebear.com/7.x/initials/svg?seed=Amaya', '[]', '{}'),
(6, 'Earl''s Regency Hotels', 'hotels.earls@example.com', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'vendor', '+94 81 223 3344', '', 'Kandy, Sri Lanka', 'English', '', 'https://api.dicebear.com/7.x/initials/svg?seed=Earls', '[]', '{}'),
(7, 'Safari Jeep Rentals', 'safari.rentals@example.com', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'vendor', '+94 23 555 6666', '', 'Yala, Sri Lanka', 'English', '', 'https://api.dicebear.com/7.x/initials/svg?seed=Safari', '[]', '{}'),
(8, 'Local Guide Services', 'guides.local@example.com', '$2a$10$eE0m9pPnDq6m5lRvhC4mheTqXnUuXN7gW7Q8Z8lQ7Z8lQ7Z8lQ7Z8', 'vendor', '+94 36 777 8888', '', 'Ella, Sri Lanka', 'English', '', 'https://api.dicebear.com/7.x/initials/svg?seed=Guides', '[]', '{}');

-- Insert Vendors
INSERT INTO `vendors` (`id`, `user_id`, `businessName`, `businessType`, `registrationNumber`, `taxId`, `yearEstablished`, `businessEmail`, `businessPhone`, `website`, `facebook`, `instagram`, `addressLine1`, `addressLine2`, `city`, `province`, `postalCode`, `country`, `contactName`, `contactDesignation`, `contactPhone`, `contactEmail`, `services`, `otherServices`, `bankName`, `bankBranch`, `accountName`, `accountNumber`, `accountType`, `status`) VALUES
(1, 4, 'Ceylon Journeys Pvt Ltd', 'Tour Operator', 'BP/12345/2018', 'TAX-567890', 2018, 'info@ceylanjourneys.lk', '+94 11 234 5678', 'https://ceylanjourneys.lk', 'fb.com/ceylanjourneys', '@ceylanjourneys', '45, Galle Road', 'Level 2', 'Colombo', 'Western', '00300', 'Sri Lanka', 'Roshan De Silva', 'Managing Director', '+94 72 111 2222', 'roshan@ceylanjourneys.lk', '["Tour Packages", "Hotel Bookings", "Transport", "Guide Services"]', NULL, 'Commercial Bank of Ceylon', 'Colombo Branch', 'Ceylon Journeys Pvt Ltd', '1234567890', 'Current', 'approved'),
(2, 5, 'Amaya Coastal Tours', 'Travel Agency', 'BP/78901/2020', NULL, 2020, 'hello@amayacoastal.lk', '+94 31 456 7890', 'https://amayacoastal.lk', NULL, '@amayacoastal', '12, Beach Road', NULL, 'Negombo', 'Western', '11500', 'Sri Lanka', 'Amaya Gunawardena', 'Director', '+94 77 333 4444', 'amaya@amayacoastal.lk', '["Beach Tours", "Water Sports", "Day Trips", "Airport Transfers"]', NULL, "People's Bank", 'Negombo Branch', 'Amaya Coastal Tours', '9876543210', 'Current', 'approved'),
(3, 6, "Earl's Regency Hotel", 'Hotel/Guest House', 'BP/56789/2015', 'TAX-111111', 2015, 'info@earlskandy.lk', '+94 81 223 3344', 'https://earlskandy.lk', 'fb.com/earlsregency', '@earlsregency', '45 Peradeniya Road', NULL, 'Kandy', 'Central', '20800', 'Sri Lanka', 'Samantha Fernandez', 'Hotel Manager', '+94 81 223 3344', 'manager@earlskandy.lk', '["Hotel Accommodation", "Restaurant & Bar", "Spa Services", "Event Hosting"]', NULL, 'Hatton National Bank', 'Kandy Branch', "Earl's Regency Ltd", '1122334455', 'Current', 'approved'),
(4, 7, 'Safari Jeep Rentals Yala', 'Transport Provider', 'BP/99887/2021', NULL, 2021, 'booking@yalaexpeditions.lk', '+94 23 555 6666', 'https://yalaexpeditions.lk', 'fb.com/yalasafari', NULL, 'Main Street, Tissamaharama', NULL, 'Yala', 'Southern', '82600', 'Sri Lanka', 'Kumara Gamage', 'Head Guide & Owner', '+94 23 555 6666', 'kumara@yalaexpeditions.lk', '["4x4 Safari Jeeps", "Park Entry Passes", "Licensed Guides"]', NULL, 'Bank of Ceylon', 'Tissa Branch', 'Kumara Safari Services', '5566778899', 'Savings', 'approved'),
(5, 8, 'Ella Trails & Guides', 'Tour Guide', 'BP/44332/2019', NULL, 2019, 'contact@ellatrails.lk', '+94 36 777 8888', 'https://ellatrails.lk', NULL, '@ellatrails', 'Passara Road', NULL, 'Ella', 'Uva', '90090', 'Sri Lanka', 'Nalin Bandara', 'Lead Trekker', '+94 36 777 8888', 'nalin@ellatrails.lk', '["Hiking Tours", "Bridge Treks", "Photography Expeditions"]', NULL, 'Sampath Bank', 'Ella Branch', 'Nalin Bandara Guides', '9988776655', 'Savings', 'approved');

-- Insert Inventory Items
INSERT INTO `inventory_items` (`id`, `vendor_id`, `name`, `type`, `description`, `price`, `currency`, `capacity`, `availableCount`, `images`, `amenities`, `isActive`, `location`) VALUES
(1, 3, 'Deluxe Mountain View Room', 'accommodation', 'Luxury room with panoramic balcony views of the Knuckles mountain range.', 18500.00, 'LKR', 25, 20, '["/images/destinations/kandy.jpg"]', '["King Bed", "Balcony", "Free Wi-Fi", "Breakfast Included", "AC"]', 1, 'Kandy'),
(2, 3, 'Executive Suite', 'accommodation', 'Spacious suite with private lounge and hot tub.', 32000.00, 'LKR', 10, 8, '["/images/destinations/kandy.jpg"]', '["Jacuzzi", "King Bed", "Mini Bar", "Butler Service"]', 1, 'Kandy'),
(3, 4, 'Full Day Yala Safari Jeep (Private)', 'transport', 'Custom 4x4 open-top Toyota Land Cruiser with expert wildlife tracker.', 24000.00, 'LKR', 8, 6, '["/images/destinations/yala.png"]', '["Binoculars", "Water Cooler", "Wildlife Book", "First Aid"]', 1, 'Yala'),
(4, 4, 'Half Day Morning Safari', 'activity', 'Early morning safari ride through Zone 1 focusing on leopard sightings.', 14000.00, 'LKR', 12, 10, '["/images/destinations/yala.png"]', '["Experienced Tracker", "Park Guide", "Water Bottles"]', 1, 'Yala'),
(5, 5, 'Ella Rock Guided Hike & Secret Caves', 'activity', 'Challenging scenic trek up Ella Rock via lesser-known trails and railway lines.', 4500.00, 'LKR', 30, 26, '["/images/destinations/ella.jpg"]', '["Trail Guide", "Fruit Refreshments", "First Aid Kit"]', 1, 'Ella'),
(6, 5, 'Nine Arch Bridge & Tea Valley Walk', 'activity', 'Gentle scenic trail through tea bushes directly under the famous colonial viaduct.', 2500.00, 'LKR', 40, 38, '["/images/destinations/ella.jpg"]', '["Train Timing Info", "Scenic Photo Assistance"]', 1, 'Ella'),
(7, 2, 'Luxury Catamaran Sunset Cruise', 'activity', 'Sail across Mirissa bay with sunset cocktails and dolphin spotting.', 9500.00, 'LKR', 20, 16, '["/images/destinations/galle.jpg"]', '["Snacks", "Welcome Drink", "Life Jackets", "Music"]', 1, 'Mirissa'),
(8, 2, 'Galle Fort Heritage Cycling Tour', 'activity', 'Cruise along the ramparts and historic cobblestone lanes on vintage bicycles.', 3500.00, 'LKR', 25, 22, '["/images/destinations/galle.jpg"]', '["Vintage Bicycle", "Helmet", "Heritage Historian"]', 1, 'Galle'),
(9, 1, 'All-Island Cultural Triangle Tour (5 Days)', 'package', 'Comprehensive tour covering Anuradhapura, Sigiriya, Dambulla, and Kandy.', 85000.00, 'LKR', 15, 12, '["/images/destinations/sigiriya.jpg"]', '["Private Vehicle", "All Entry Passes", "Guide", "Half Board Hotels"]', 1, 'Sigiriya');

-- Insert Trips
INSERT INTO `trips` (`id`, `user_id`, `tripId`, `destination`, `location`, `status`, `date_from`, `date_to`, `totalCost`, `paymentStatus`, `adults`, `children`, `bookingDate`, `image`, `duration`, `vendor`, `specialRequests`, `reviewStatus`, `timeline`, `itinerary`) VALUES
(1, 2, 'TRIP-2026-001', 'Galle & Mirissa', 'Galle, Sri Lanka', 'confirmed', '2026-03-15', '2026-03-17', 45000.00, 'paid', 2, 0, '2026-03-01', '/images/destinations/galle.jpg', '3 Days / 2 Nights', 'Amaya Coastal Tours', 'Pick up from Galle railway station', 'completed', '[{"step": "Booked", "status": "completed", "date": "2026-03-01"}, {"step": "Payment Cleared", "status": "completed", "date": "2026-03-02"}, {"step": "Trip Completed", "status": "completed", "date": "2026-03-17"}]', '[{"day": 1, "date": "2026-03-15", "sections": [{"time": "Morning", "items": [{"type": "transport", "name": "Pickup from Galle Station"}]}, {"time": "Afternoon", "items": [{"type": "activity", "name": "Galle Fort Walk"}]}]}, {"day": 2, "date": "2026-03-16", "sections": [{"time": "Morning", "items": [{"type": "activity", "name": "Whale Watching Cruise"}]}]}]'),
(2, 2, 'TRIP-2026-002', 'Kandy Hill Explorer', 'Kandy, Sri Lanka', 'pending', '2026-04-10', '2026-04-13', 52500.00, 'pending', 1, 2, '2026-03-05', '/images/destinations/kandy.jpg', '4 Days / 3 Nights', 'Ceylon Journeys Pvt Ltd', 'Kid-friendly meals requested', 'none', '[{"step": "Booked", "status": "completed", "date": "2026-03-05"}, {"step": "Vendor Review", "status": "current", "date": "2026-03-06"}]', '[{"day": 1, "date": "2026-04-10", "sections": [{"time": "Morning", "items": [{"type": "activity", "name": "Temple of Tooth"}]}]}]');

-- Insert Bookings
INSERT INTO `bookings` (`id`, `user_id`, `destination`, `location`, `duration`, `totalCost`, `startDate`, `endDate`, `adults`, `children`, `infants`, `status`, `expiryDate`, `specialRequests`, `paymentStatus`, `vendorNotes`) VALUES
(1, 2, 'Galle & Mirissa 3-Day Tour', 'Galle, Mirissa', '3 Days / 2 Nights', 45000.00, '2026-03-15', '2026-03-17', 2, 0, 0, 'confirmed', '2026-03-02 23:59:59', 'Please arrange pickup from Galle railway station.', 'paid', 'Approved by Amaya Tours. Ready for trip.'),
(2, 2, 'Kandy Hill Country Explorer - 4 Days', 'Kandy, Nuwara Eliya', '4 Days / 3 Nights', 52500.00, '2026-04-10', '2026-04-13', 1, 2, 0, 'pending', '2026-03-12 18:00:00', 'Family trip with kids. Need child-friendly activities.', 'unpaid', 'Under review by Ceylon Journeys.'),
(3, 3, 'Mirissa Sunset Cruise & Luxury Stay', 'Mirissa, Sri Lanka', '2 Days / 1 Night', 38000.00, '2026-05-01', '2026-05-02', 2, 0, 0, 'confirmed', '2026-04-20 12:00:00', 'Anniversary celebration. Champagne on arrival.', 'paid', 'Special setup arranged on catamaran.');

-- Insert Booking Items
INSERT INTO `booking_items` (`booking_id`, `inventory_id`, `priceAtBooking`) VALUES
(1, 7, 9500.00),
(1, 8, 3500.00),
(2, 1, 18500.00),
(3, 7, 9500.00);

-- Insert Saved Trips
INSERT INTO `saved_trips` (`user_id`, `trip_id`) VALUES
(2, 1),
(3, 1);

-- Insert Reviews
INSERT INTO `reviews` (`trip_id`, `user_id`, `vendor_id`, `rating`, `comment`) VALUES
(1, 2, 2, 4.9, 'Unbelievable experience! The catamaran tour was surreal and the accommodation exceeded expectations.'),
(1, 3, 2, 4.8, 'Amaya Coastal Tours made our holiday completely hassle-free. Highly recommended for couples!');

-- Insert Notifications
INSERT INTO `notifications` (`user_id`, `title`, `message`, `type`, `isRead`) VALUES
(2, 'Booking Confirmed!', 'Your booking for Galle & Mirissa 3-Day Tour has been confirmed by the vendor.', 'booking', 1),
(2, 'Payment Received', 'LKR 45,000 has been received successfully for Booking #1.', 'payment', 0),
(3, 'Welcome to SmartTrip', 'Welcome Nimasha! Explore tailor-made Sri Lankan itineraries today.', 'system', 1);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

-- ==============================================================
-- End of SmartTrip MySQL Database Dump
-- ==============================================================
