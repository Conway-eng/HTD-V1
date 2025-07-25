-- Set up SQL environment
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- Drop tables if they exist to avoid conflicts
DROP TABLE IF EXISTS `activity_log`;
DROP TABLE IF EXISTS `bots`;
DROP TABLE IF EXISTS `bot_change_requests`;
DROP TABLE IF EXISTS `bot_change_request_env_vars`;
DROP TABLE IF EXISTS `bot_comments`;
DROP TABLE IF EXISTS `bot_env_vars`;
DROP TABLE IF EXISTS `bot_reports`;
DROP TABLE IF EXISTS `bot_requests`;
DROP TABLE IF EXISTS `bot_request_env_vars`;
DROP TABLE IF EXISTS `bot_social_links`;
DROP TABLE IF EXISTS `coin_transactions`;
DROP TABLE IF EXISTS `ContactMessages`;
DROP TABLE IF EXISTS `deployed_apps`;
DROP TABLE IF EXISTS `deployment_env_vars`;
DROP TABLE IF EXISTS `deployment_history`;
DROP TABLE IF EXISTS `email_senders`;
DROP TABLE IF EXISTS `favorite_bots`;
DROP TABLE IF EXISTS `heroku_accounts`;
DROP TABLE IF EXISTS `heroku_api_keys`;
DROP TABLE IF EXISTS `invites`;
DROP TABLE IF EXISTS `ip_account_tracking`;
DROP TABLE IF EXISTS `maintenance_progress`;
DROP TABLE IF EXISTS `maintenance_statistics`;
DROP TABLE IF EXISTS `moderators`;
DROP TABLE IF EXISTS `moderator_countries`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `notification_recipients`;
DROP TABLE IF EXISTS `notification_targets`;
DROP TABLE IF EXISTS `payment_methods`;
DROP TABLE IF EXISTS `payment_method_details`;
DROP TABLE IF EXISTS `payment_requests`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `purchased_heroku_accounts`;
DROP TABLE IF EXISTS `purchases`;
DROP TABLE IF EXISTS `referrals`;
DROP TABLE IF EXISTS `sessions`;
DROP TABLE IF EXISTS `support_tickets`;
DROP TABLE IF EXISTS `ticket_chat_messages`;
DROP TABLE IF EXISTS `ticket_replies`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `user_appeals`;
DROP TABLE IF EXISTS `user_country`;
DROP TABLE IF EXISTS `user_devices`;
DROP TABLE IF EXISTS `youtube_subscriptions`;

-- Table Definitions

CREATE TABLE `activity_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `action` VARCHAR(255) NOT NULL,
  `details` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bots` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `repo_url` VARCHAR(255) NOT NULL,
  `deployment_cost` INT(11) DEFAULT 0,
  `dev_number` VARCHAR(20) DEFAULT NULL,
  `total_deployments` INT(11) DEFAULT 0,
  `website_url` VARCHAR(255) DEFAULT NULL,
  `developer_id` INT(11) DEFAULT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `popularity_tier` ENUM('popular','rising','standard') DEFAULT 'standard',
  `created_at` DATETIME DEFAULT NULL,  -- Use DATETIME for created_at
  `is_suspended` TINYINT(1) DEFAULT 0,
  `dev_email` VARCHAR(255) DEFAULT NULL,
  `user_email` VARCHAR(255) DEFAULT NULL,
  `request_id` INT(11) DEFAULT NULL,
  `status` ENUM('approved','rejected','pending') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_change_requests` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `bot_id` INT(11) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `repo_url` VARCHAR(255) NOT NULL,
  `website_url` VARCHAR(255) DEFAULT NULL,
  `dev_number` VARCHAR(20) NOT NULL,
  `status` ENUM('pending','approved','rejected') DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_change_request_env_vars` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `change_request_id` INT(11) NOT NULL,
  `var_name` VARCHAR(255) NOT NULL,
  `var_description` TEXT DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_comments` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `bot_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `comment` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_env_vars` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `bot_id` INT(11) NOT NULL,
  `var_name` VARCHAR(255) NOT NULL,
  `var_description` VARCHAR(255) DEFAULT NULL,
  `is_required` TINYINT(1) DEFAULT 0,
  `required` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_reports` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `bot_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `report_type` VARCHAR(50) NOT NULL,
  `description` TEXT NOT NULL,
  `status` ENUM('pending','investigating','resolved') DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_requests` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `repo_url` VARCHAR(255) NOT NULL,
  `dev_number` VARCHAR(20) NOT NULL,
  `deployment_cost` DECIMAL(10,2) DEFAULT NULL,
  `website_url` VARCHAR(255) DEFAULT NULL,
  `status` ENUM('pending','approved','rejected') DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `user_email` VARCHAR(255) DEFAULT NULL,
  `dev_email` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_request_env_vars` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `request_id` INT(11) DEFAULT NULL,
  `var_name` VARCHAR(255) NOT NULL,
  `var_description` TEXT DEFAULT NULL,
  `required` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bot_social_links` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `request_id` INT(11) DEFAULT NULL,
  `link_type` VARCHAR(50) DEFAULT NULL,
  `url` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `coin_transactions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `sender_phone` VARCHAR(20) DEFAULT NULL,
  `recipient_phone` VARCHAR(20) DEFAULT NULL,
  `amount` INT(11) NOT NULL,
  `transaction_type` ENUM('deployment','referral_reward','deposit','dev_share') NOT NULL,
  `transaction_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `receiver_phone` VARCHAR(20) DEFAULT NULL,
  `app_id` INT(11) DEFAULT NULL,
  `description` VARCHAR(255) DEFAULT NULL,
  `approval_date` TIMESTAMP NULL DEFAULT NULL,
  `remarks` TEXT DEFAULT NULL,
  `status` ENUM('pending','approved','rejected') DEFAULT 'pending',
  `payment_screenshot` VARCHAR(255) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,           -- Use DATETIME here
  `approved_by` INT(11) DEFAULT NULL,
  `payment_method_id` INT(11) DEFAULT NULL,
  `country_code` VARCHAR(10) DEFAULT NULL,
  `moderator_id` INT(11) DEFAULT NULL,
  `sender_username` VARCHAR(255) DEFAULT NULL,
  `recipient_username` VARCHAR(255) DEFAULT NULL,
  `sender_email` VARCHAR(255) DEFAULT NULL,
  `recipient_email` VARCHAR(255) DEFAULT NULL,
  `receiver_email` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `ContactMessages` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `subject` VARCHAR(100) NOT NULL,
  `message` TEXT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('new','read','replied') DEFAULT 'new',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `deployed_apps` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `bot_id` INT(11) NOT NULL,
  `app_name` VARCHAR(255) NOT NULL,
  `heroku_app_name` VARCHAR(255) DEFAULT NULL,
  `status` ENUM('deploying','configuring','building','active','failed') DEFAULT 'deploying',
  `error_message` TEXT DEFAULT NULL,
  `deployed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_coin_deduction` TIMESTAMP NULL DEFAULT NULL,
  `cost` DECIMAL(10,2) DEFAULT NULL,
  `heroku_api_key` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deployed_apps_user_id` (`user_id`),
  KEY `idx_deployed_apps_last_coin_deduction` (`last_coin_deduction`),
  KEY `idx_deployed_apps_deployed_at` (`deployed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `deployment_env_vars` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `deployment_id` INT(11) NOT NULL,
  `var_name` VARCHAR(255) DEFAULT NULL,
  `var_value` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `deployment_history` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `deployment_id` INT(11) DEFAULT NULL,
  `app_name` VARCHAR(255) DEFAULT NULL,
  `status` VARCHAR(50) DEFAULT NULL,
  `last_checked` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_redeployed` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `redeployment_count` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `email_senders` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `host` VARCHAR(255) NOT NULL DEFAULT 'mail.talkdrove.cc.nf',
  `port` INT(11) NOT NULL DEFAULT 587,
  `is_active` TINYINT(1) DEFAULT 1,
  `daily_limit` INT(11) DEFAULT 150,
  `current_daily_count` INT(11) DEFAULT 0,
  `last_reset_date` DATE DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `total_emails_sent` INT(11) DEFAULT 0,
  `last_used_timestamp` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `favorite_bots` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `bot_id` INT(11) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `heroku_accounts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `api_key` VARCHAR(255) NOT NULL,
  `recovery_codes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_sold` TINYINT(1) DEFAULT 0,
  `is_valid` TINYINT(1) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `heroku_api_keys` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `api_key` VARCHAR(255) NOT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `last_checked` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `failed_attempts` INT(11) DEFAULT 0,
  `last_used` DATETIME DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,
  `last_failed` DATETIME DEFAULT NULL,
  `successful_deployments` INT(11) DEFAULT 0,
  `last_error` TEXT DEFAULT NULL,
  `current_app_count` INT(11) DEFAULT 0,
  `apps_count` INT(11) DEFAULT 0,
  `error_message` TEXT DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `invites` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `inviter_id` INT(11) NOT NULL,
  `invite_code` VARCHAR(255) NOT NULL,
  `used` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `used_by` VARCHAR(255) DEFAULT NULL,
  `used_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ip_account_tracking` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `ip_address` VARCHAR(45) NOT NULL,
  `account_count` INT(11) DEFAULT 1,
  `created_at` DATETIME DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_signup` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `maintenance_progress` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `start_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` TIMESTAMP NULL DEFAULT NULL,
  `apps_processed` INT(11) DEFAULT 0,
  `apps_deleted` INT(11) DEFAULT 0,
  `coins_deducted` DECIMAL(10,2) DEFAULT 0.00,
  `status` ENUM('running','completed','failed') DEFAULT 'running',
  `last_processed_app_id` INT(11) DEFAULT NULL,
  `error_message` TEXT DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `maintenance_statistics` (
  `date` DATE NOT NULL,
  `total_apps_processed` INT(11) DEFAULT 0,
  `total_apps_deleted` INT(11) DEFAULT 0,
  `total_coins_deducted` DECIMAL(10,2) DEFAULT 0.00,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `moderators` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `status` ENUM('active','inactive') DEFAULT 'active',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `moderator_countries` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `moderator_id` INT(11) NOT NULL,
  `country_code` VARCHAR(2) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `notifications` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) DEFAULT NULL,
  `message` TEXT NOT NULL,
  `type` VARCHAR(50) DEFAULT 'general',
  `read` TINYINT(1) DEFAULT 0,
  `seen` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `link` VARCHAR(255) DEFAULT NULL,
  `target_type` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `notification_recipients` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `notification_id` INT(11) DEFAULT NULL,
  `user_id` INT(11) DEFAULT NULL,
  `is_read` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `notification_targets` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `notification_id` INT(11) DEFAULT NULL,
  `target_type` ENUM('all','specific') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `payment_methods` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `status` ENUM('active','inactive') DEFAULT 'active',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `country_code` VARCHAR(3) NOT NULL DEFAULT 'ALL',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `payment_method_details` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `payment_method_id` INT(11) DEFAULT NULL,
  `account_name` VARCHAR(100) DEFAULT NULL,
  `account_number` VARCHAR(100) DEFAULT NULL,
  `additional_info` TEXT DEFAULT NULL,
  `status` ENUM('active','inactive') DEFAULT 'active',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `instructions` TEXT DEFAULT NULL,
  `country_code` VARCHAR(50) DEFAULT 'ALL',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `payment_requests` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `product_id` INT(11) NOT NULL,
  `checkout_id` VARCHAR(191) NOT NULL,
  `order_id` VARCHAR(191) DEFAULT NULL,
  `customer_id` VARCHAR(255) DEFAULT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `status` ENUM('pending','completed','failed','completed_redirect') NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `checkout_id` (`checkout_id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `products` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `product_id` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `coins` INT(11) NOT NULL,
  `description` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `purchased_heroku_accounts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `account_id` INT(11) NOT NULL,
  `purchased_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `purchases` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `product_id` VARCHAR(255) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `purchase_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `checkout_id` VARCHAR(255) NOT NULL,
  `coins_purchased` INT(11) NOT NULL,
  `order_id` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `purchases_ibfk_1` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `referrals` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `referrer_id` INT(11) NOT NULL,
  `referred_id` INT(11) NOT NULL,
  `coins_awarded` INT(11) DEFAULT 20,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `invite_code_used` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sessions` (
  `session_id` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` INT(11) UNSIGNED NOT NULL,
  `data` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `last_activity` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `support_tickets` (
  `ticket_id` VARCHAR(36) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `status` ENUM('open','in_progress','resolved','closed') DEFAULT 'open',
  `priority` ENUM('low','medium','high','urgent') DEFAULT 'medium',
  `category` VARCHAR(100) DEFAULT 'general',
  `customer_name` VARCHAR(255) NOT NULL,
  `customer_email` VARCHAR(255) NOT NULL,
  `assigned_to` VARCHAR(255) DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` INT(11) DEFAULT NULL,
  PRIMARY KEY (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ticket_chat_messages` (
  `message_id` VARCHAR(36) NOT NULL,
  `ticket_id` VARCHAR(36) DEFAULT NULL,
  `sender_id` VARCHAR(36) DEFAULT NULL,
  `sender_name` VARCHAR(100) DEFAULT NULL,
  `message_text` TEXT DEFAULT NULL,
  `is_read` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ticket_replies` (
  `reply_id` VARCHAR(36) NOT NULL,
  `ticket_id` VARCHAR(36) DEFAULT NULL,
  `user_id` VARCHAR(36) DEFAULT NULL,
  `username` VARCHAR(255) DEFAULT NULL,
  `reply_text` TEXT DEFAULT NULL,
  `is_internal` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reply_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `phone_number` VARCHAR(20) DEFAULT NULL,
  `password` VARCHAR(255) NOT NULL,
  `is_verified` TINYINT(1) DEFAULT 0,
  `coins` INT(11) DEFAULT 0,
  `is_admin` TINYINT(1) DEFAULT 0,
  `last_login_ip` VARCHAR(45) DEFAULT NULL,
  `referrer_id` INT(11) DEFAULT NULL,
  `timezone` VARCHAR(50) DEFAULT 'UTC',
  `country_code` VARCHAR(2) DEFAULT NULL,
  `name` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `permanent_invite_code` VARCHAR(255) DEFAULT NULL,
  `total_referrals` INT(11) DEFAULT 0,
  `invite_code_used` VARCHAR(255) DEFAULT NULL,
  `referral_code` VARCHAR(8) DEFAULT NULL,
  `referred_by` INT(11) DEFAULT NULL,
  `is_banned` TINYINT(1) DEFAULT 0,
  `last_login` DATETIME DEFAULT NULL,
  `status` VARCHAR(20) DEFAULT NULL,
  `last_deposit_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) DEFAULT NULL,
  `first_name` VARCHAR(50) DEFAULT NULL,
  `last_name` VARCHAR(50) DEFAULT NULL,
  `bio` TEXT DEFAULT NULL,
  `gender` ENUM('male','female','other') DEFAULT NULL,
  `profile_picture` VARCHAR(255) DEFAULT NULL,
  `whatsapp_link` VARCHAR(255) DEFAULT NULL,
  `youtube_link` VARCHAR(255) DEFAULT NULL,
  `website_link` VARCHAR(255) DEFAULT NULL,
  `github_link` VARCHAR(255) DEFAULT NULL,
  `linkedin_link` VARCHAR(255) DEFAULT NULL,
  `x_link` VARCHAR(255) DEFAULT NULL,
  `instagram_link` VARCHAR(255) DEFAULT NULL,
  `twitter_link` VARCHAR(255) DEFAULT NULL,
  `version` INT(11) DEFAULT 0,
  `last_claim_date` DATE DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_users_last_claim_date` (`last_claim_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_appeals` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `reason` TEXT NOT NULL,
  `additional_info` TEXT DEFAULT NULL,
  `status` ENUM('pending','approved','rejected') DEFAULT 'pending',
  `admin_response` TEXT DEFAULT NULL,
  `reviewed_by` INT(11) DEFAULT NULL,
  `reviewed_at` DATETIME DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_country` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_devices` (
  `id` VARCHAR(36) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `ip_address` VARCHAR(45) NOT NULL,
  `device_info` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`device_info`)),
  `location` VARCHAR(255) DEFAULT NULL,
  `last_used` DATETIME NOT NULL,
  `is_verified` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_devices` (`user_id`,`device_info`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `youtube_subscriptions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_email` VARCHAR(255) NOT NULL,
  `channel_id` VARCHAR(255) NOT NULL,
  `verified_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_email` (`user_email`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
