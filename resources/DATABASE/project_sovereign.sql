-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.32-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.15.0.7171
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para project_sovereign
CREATE DATABASE IF NOT EXISTS `project_sovereign` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `project_sovereign`;

-- Copiando estrutura para tabela project_sovereign.smartphone_bank_invoices
CREATE TABLE IF NOT EXISTS `smartphone_bank_invoices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `payee_id` int(11) NOT NULL,
  `payer_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  `paid` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_bank_invoices: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_blocks
CREATE TABLE IF NOT EXISTS `smartphone_blocks` (
  `user_id` int(11) NOT NULL,
  `phone` varchar(32) NOT NULL,
  PRIMARY KEY (`user_id`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_blocks: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_calls
CREATE TABLE IF NOT EXISTS `smartphone_calls` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `initiator` varchar(255) NOT NULL,
  `target` varchar(255) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL,
  `video` tinyint(4) NOT NULL DEFAULT 0,
  `anonymous` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `initiator_index` (`initiator`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_calls: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_casino
CREATE TABLE IF NOT EXISTS `smartphone_casino` (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `double` bigint(20) NOT NULL DEFAULT 0,
  `crash` bigint(20) NOT NULL DEFAULT 0,
  `mine` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_casino: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_contacts
CREATE TABLE IF NOT EXISTS `smartphone_contacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_index` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_contacts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_gallery
CREATE TABLE IF NOT EXISTS `smartphone_gallery` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `folder` varchar(255) NOT NULL DEFAULT '/',
  `url` varchar(255) NOT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_gallery: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_ifood_orders
CREATE TABLE IF NOT EXISTS `smartphone_ifood_orders` (
  `id` varchar(10) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `fee` int(11) DEFAULT NULL,
  `rate` tinyint(4) DEFAULT 0,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_ifood_orders: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_instagram
CREATE TABLE IF NOT EXISTS `smartphone_instagram` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `bio` varchar(255) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_instagram: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_instagram_followers
CREATE TABLE IF NOT EXISTS `smartphone_instagram_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`follower_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_instagram_followers: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_instagram_likes
CREATE TABLE IF NOT EXISTS `smartphone_instagram_likes` (
  `post_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`post_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_instagram_likes: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_instagram_notifications
CREATE TABLE IF NOT EXISTS `smartphone_instagram_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `content` varchar(512) NOT NULL,
  `saw` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_instagram_notifications: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_instagram_posts
CREATE TABLE IF NOT EXISTS `smartphone_instagram_posts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` bigint(20) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_instagram_posts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_olx
CREATE TABLE IF NOT EXISTS `smartphone_olx` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `description` varchar(1024) NOT NULL,
  `images` varchar(1024) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_olx: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_paypal_transactions
CREATE TABLE IF NOT EXISTS `smartphone_paypal_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'payment',
  `description` varchar(255) DEFAULT NULL,
  `value` bigint(20) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_paypal_transactions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_tinder
CREATE TABLE IF NOT EXISTS `smartphone_tinder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(1024) NOT NULL,
  `age` tinyint(4) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `show_gender` tinyint(4) NOT NULL,
  `tags` varchar(255) NOT NULL,
  `show_tags` tinyint(4) NOT NULL,
  `target` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `gender_index` (`gender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_tinder: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_tinder_messages
CREATE TABLE IF NOT EXISTS `smartphone_tinder_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `liked` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_tinder_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_tinder_rating
CREATE TABLE IF NOT EXISTS `smartphone_tinder_rating` (
  `profile_id` int(11) NOT NULL,
  `rated_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`profile_id`,`rated_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_tinder_rating: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_tor_messages
CREATE TABLE IF NOT EXISTS `smartphone_tor_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel` varchar(24) NOT NULL DEFAULT 'geral',
  `sender` varchar(255) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_index` (`channel`),
  KEY `sender_index` (`sender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_tor_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_tor_payments
CREATE TABLE IF NOT EXISTS `smartphone_tor_payments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `amount` int(11) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_tor_payments: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_twitter_followers
CREATE TABLE IF NOT EXISTS `smartphone_twitter_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_twitter_followers: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_twitter_likes
CREATE TABLE IF NOT EXISTS `smartphone_twitter_likes` (
  `tweet_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  KEY `tweet_id_index` (`tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_twitter_likes: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_twitter_profiles
CREATE TABLE IF NOT EXISTS `smartphone_twitter_profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_twitter_profiles: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_twitter_tweets
CREATE TABLE IF NOT EXISTS `smartphone_twitter_tweets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `content` varchar(280) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_twitter_tweets: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_uber_trips
CREATE TABLE IF NOT EXISTS `smartphone_uber_trips` (
  `id` varchar(10) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `from` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `user_rate` tinyint(4) DEFAULT 0,
  `driver_rate` tinyint(4) DEFAULT 0,
  `created_at` int(11) DEFAULT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_uber_trips: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_weazel
CREATE TABLE IF NOT EXISTS `smartphone_weazel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `author` varchar(255) NOT NULL,
  `tag` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(4096) NOT NULL,
  `imageURL` varchar(255) DEFAULT NULL,
  `videoURL` varchar(255) DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_weazel: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_whatsapp
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp` (
  `owner` varchar(32) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `read_receipts` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_whatsapp: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_whatsapp_channels
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_channels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_whatsapp_channels: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_whatsapp_groups
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `members` varchar(2048) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_whatsapp_groups: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.smartphone_whatsapp_messages
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) unsigned NOT NULL,
  `sender` varchar(50) NOT NULL,
  `content` varchar(500) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.smartphone_whatsapp_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_accounts
CREATE TABLE IF NOT EXISTS `sov_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) DEFAULT 0,
  `banned` tinyint(1) DEFAULT 0,
  `gems` int(20) DEFAULT 0,
  `premium_tier` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `steam` (`steam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_accounts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_ai_memory
CREATE TABLE IF NOT EXISTS `sov_ai_memory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `npc_id` int(11) NOT NULL,
  `event_description` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_ai_memory: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_ai_profiles
CREATE TABLE IF NOT EXISTS `sov_ai_profiles` (
  `npc_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `personality_json` longtext NOT NULL,
  `nation_id` int(1) NOT NULL,
  PRIMARY KEY (`npc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_ai_profiles: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_appearance
CREATE TABLE IF NOT EXISTS `sov_appearance` (
  `char_id` int(11) NOT NULL,
  `model` varchar(50) DEFAULT 'mp_m_freemode_01',
  `skin_data` longtext DEFAULT NULL,
  `clothes_data` longtext DEFAULT NULL,
  `tattoos_data` longtext DEFAULT NULL,
  PRIMARY KEY (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_appearance: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_audit_logs
CREATE TABLE IF NOT EXISTS `sov_audit_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `details` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_audit_logs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_bans
CREATE TABLE IF NOT EXISTS `sov_bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `admin` varchar(50) NOT NULL,
  `expire_at` int(20) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_bans: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_businesses
CREATE TABLE IF NOT EXISTS `sov_businesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `type` varchar(50) NOT NULL COMMENT 'market, ammo, factory',
  `name` varchar(100) DEFAULT 'Empresa à Venda',
  `price` int(20) NOT NULL,
  `bank_balance` bigint(20) DEFAULT 0,
  `upgrades_json` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_businesses: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_characters
CREATE TABLE IF NOT EXISTS `sov_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT 'Indigente',
  `surname` varchar(50) DEFAULT 'Desconhecido',
  `phone` varchar(20) DEFAULT NULL,
  `serial` varchar(10) DEFAULT NULL,
  `nation_id` int(1) DEFAULT 0 COMMENT '1=Valtoria, 2=Karveth',
  `bank` bigint(20) DEFAULT 5000,
  `crypto_volume` float DEFAULT 0 COMMENT 'Moeda Black',
  `health` int(4) DEFAULT 200,
  `armor` int(4) DEFAULT 0,
  `hunger` int(4) DEFAULT 100,
  `thirst` int(4) DEFAULT 100,
  `stress` int(4) DEFAULT 0,
  `prison_time` int(11) DEFAULT 0,
  `fines` bigint(20) DEFAULT 0,
  `deleted` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_char_acc` (`account_id`),
  CONSTRAINT `fk_char_acc` FOREIGN KEY (`account_id`) REFERENCES `sov_accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_characters: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_chests_config
CREATE TABLE IF NOT EXISTS `sov_chests_config` (
  `id` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `weight` int(11) DEFAULT 100,
  `perm` varchar(50) DEFAULT 'admin',
  `logs` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_chests_config: ~2 rows (aproximadamente)
INSERT INTO `sov_chests_config` (`id`, `name`, `weight`, `perm`, `logs`) VALUES
	('mechanic', 'Mechanic Storage', 200, 'mechanic.storage', 1),
	('police', 'Armory Police', 500, 'police.armory', 1);

-- Copiando estrutura para tabela project_sovereign.sov_dealership_stock
CREATE TABLE IF NOT EXISTS `sov_dealership_stock` (
  `model` varchar(50) NOT NULL COMMENT 'Ex: t20',
  `stock_qty` int(11) DEFAULT 5,
  `price` int(11) DEFAULT 1000000,
  `category` varchar(50) DEFAULT 'super',
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_dealership_stock: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_economy_logs
CREATE TABLE IF NOT EXISTS `sov_economy_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `action_type` varchar(50) NOT NULL COMMENT 'transfer, buy, sell, salary, cheat_detect',
  `amount` int(20) NOT NULL,
  `balance_after` int(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `char_id` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_economy_logs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_faction_members
CREATE TABLE IF NOT EXISTS `sov_faction_members` (
  `char_id` int(11) NOT NULL,
  `faction_id` int(11) NOT NULL,
  `rank_level` int(3) NOT NULL,
  `is_boss` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_faction_members: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_faction_ranks
CREATE TABLE IF NOT EXISTS `sov_faction_ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faction_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Cadete, Coronel, Vapor',
  `salary` int(11) DEFAULT 0,
  `level` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `faction_id` (`faction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_faction_ranks: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_factions
CREATE TABLE IF NOT EXISTS `sov_factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'Police, Ballas, Medics',
  `type` varchar(20) NOT NULL COMMENT 'public, gang, mafia',
  `bank_balance` bigint(20) DEFAULT 0,
  `nation_id` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_factions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_factories
CREATE TABLE IF NOT EXISTS `sov_factories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `nation_id` int(1) NOT NULL,
  `stock_raw` int(11) DEFAULT 0,
  `stock_finished` int(11) DEFAULT 0,
  `balance` bigint(20) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_factories: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_inventory
CREATE TABLE IF NOT EXISTS `sov_inventory` (
  `inventory_id` varchar(100) NOT NULL COMMENT 'char:1, car:ABC-10',
  `items` longtext DEFAULT NULL COMMENT 'JSON: {"bread": 2}',
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`inventory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_inventory: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_logistics_orders
CREATE TABLE IF NOT EXISTS `sov_logistics_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_id` int(11) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `driver_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_logistics_orders: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_nations
CREATE TABLE IF NOT EXISTS `sov_nations` (
  `id` int(1) NOT NULL,
  `name` varchar(50) NOT NULL,
  `treasury` bigint(20) DEFAULT 100000000,
  `tax_rate` int(3) DEFAULT 15,
  `president_id` int(11) DEFAULT NULL,
  `defcon` int(1) DEFAULT 5,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_nations: ~2 rows (aproximadamente)
INSERT INTO `sov_nations` (`id`, `name`, `treasury`, `tax_rate`, `president_id`, `defcon`) VALUES
	(1, 'Valtória', 100000000, 15, NULL, 5),
	(2, 'Karveth', 100000000, 15, NULL, 5);

-- Copiando estrutura para tabela project_sovereign.sov_nuclear_program
CREATE TABLE IF NOT EXISTS `sov_nuclear_program` (
  `nation_id` int(1) NOT NULL,
  `enrichment_percentage` float DEFAULT 0,
  `heavy_water_stock` int(11) DEFAULT 0,
  `codes_decrypted` tinyint(1) DEFAULT 0,
  `launch_ready` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`nation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_nuclear_program: ~2 rows (aproximadamente)
INSERT INTO `sov_nuclear_program` (`nation_id`, `enrichment_percentage`, `heavy_water_stock`, `codes_decrypted`, `launch_ready`) VALUES
	(1, 0, 0, 0, 0),
	(2, 0, 0, 0, 0);

-- Copiando estrutura para tabela project_sovereign.sov_properties
CREATE TABLE IF NOT EXISTS `sov_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `nation_id` int(1) DEFAULT 1,
  `price` int(20) NOT NULL,
  `interior` varchar(50) DEFAULT 'shell_v1',
  `tax_paid_until` timestamp NULL DEFAULT NULL,
  `coords_enter` varchar(255) DEFAULT NULL,
  `has_bunker` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_properties: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_races
CREATE TABLE IF NOT EXISTS `sov_races` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `race_name` varchar(100) NOT NULL,
  `char_id` int(11) NOT NULL,
  `vehicle` varchar(50) NOT NULL,
  `time` int(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_races: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_storage_units
CREATE TABLE IF NOT EXISTS `sov_storage_units` (
  `unit_id` varchar(50) NOT NULL COMMENT 'Ex: house_10_safe, faction_police_armory',
  `parent_type` varchar(20) NOT NULL COMMENT 'house, business, faction',
  `parent_id` int(11) NOT NULL,
  `type` varchar(50) DEFAULT 'standard_chest',
  `level` int(2) DEFAULT 1,
  `max_weight` int(11) DEFAULT 100,
  `pin_code` varchar(10) DEFAULT NULL,
  `security_level` int(2) DEFAULT 1,
  `items` longtext DEFAULT NULL,
  PRIMARY KEY (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_storage_units: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_vehicle_shop
CREATE TABLE IF NOT EXISTS `sov_vehicle_shop` (
  `model` varchar(50) NOT NULL,
  `stock_qty` int(11) DEFAULT 10,
  `price` int(20) NOT NULL,
  `category` varchar(50) DEFAULT 'cars',
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_vehicle_shop: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_vehicles
CREATE TABLE IF NOT EXISTS `sov_vehicles` (
  `plate` varchar(20) NOT NULL,
  `char_id` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `status_json` longtext DEFAULT NULL,
  `tuning_json` longtext DEFAULT NULL,
  `damage_json` longtext DEFAULT NULL,
  `garage` varchar(50) DEFAULT 'Central',
  `impounded` tinyint(1) DEFAULT 0,
  `tax_late` tinyint(1) DEFAULT 0,
  `work` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`plate`),
  KEY `char_id` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_vehicles: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela project_sovereign.sov_wardrobe
CREATE TABLE IF NOT EXISTS `sov_wardrobe` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `clothes_json` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `char_id` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela project_sovereign.sov_wardrobe: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
