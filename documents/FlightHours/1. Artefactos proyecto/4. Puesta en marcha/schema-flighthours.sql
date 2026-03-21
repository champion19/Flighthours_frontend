-- MySQL dump 10.13  Distrib 8.0.45, for Linux (aarch64)
--
-- Host: localhost    Database: flightDb
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aircraft_model`
--

DROP TABLE IF EXISTS `aircraft_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aircraft_model` (
  `id` varchar(36) NOT NULL,
  `model_name` varchar(8) DEFAULT NULL,
  `aircraft_type_name` varchar(50) DEFAULT NULL,
  `engine_type_id` varchar(36) DEFAULT NULL,
  `family` varchar(20) DEFAULT NULL,
  `manufacturer_id` varchar(36) DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_aircraft_model_engine_type` (`engine_type_id`),
  KEY `fk_aircraft_model_manufacturer` (`manufacturer_id`),
  CONSTRAINT `fk_aircraft_model_engine_type` FOREIGN KEY (`engine_type_id`) REFERENCES `engine` (`id`),
  CONSTRAINT `fk_aircraft_model_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `airline`
--

DROP TABLE IF EXISTS `airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline` (
  `id` varchar(36) NOT NULL,
  `airline_name` varchar(30) NOT NULL,
  `airline_code` varchar(3) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `airline_route`
--

DROP TABLE IF EXISTS `airline_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline_route` (
  `id` varchar(36) NOT NULL,
  `route_id` varchar(36) NOT NULL,
  `airline_id` varchar(36) NOT NULL,
  `status` varchar(8) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_airline_route_route` (`route_id`),
  KEY `fk_airline_route_airline` (`airline_id`),
  CONSTRAINT `fk_airline_route_airline` FOREIGN KEY (`airline_id`) REFERENCES `airline` (`id`),
  CONSTRAINT `fk_airline_route_route` FOREIGN KEY (`route_id`) REFERENCES `route` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `airport`
--

DROP TABLE IF EXISTS `airport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airport` (
  `id` varchar(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  `iata_code` varchar(3) DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `airport_type` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_logbook`
--

DROP TABLE IF EXISTS `daily_logbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_logbook` (
  `id` varchar(36) NOT NULL,
  `log_date` date NOT NULL,
  `employee_id` varchar(36) NOT NULL,
  `book_page` bigint DEFAULT NULL,
  `status` varchar(12) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_logbook_employee` (`employee_id`),
  CONSTRAINT `fk_logbook_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_logbook_detail`
--

DROP TABLE IF EXISTS `daily_logbook_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_logbook_detail` (
  `id` varchar(36) NOT NULL,
  `daily_logbook_id` varchar(36) NOT NULL,
  `flight_real_date` date NOT NULL,
  `flight_number` varchar(36) NOT NULL,
  `airline_route_id` varchar(36) NOT NULL,
  `actual_tail_number_id` varchar(36) NOT NULL,
  `passengers` int DEFAULT NULL,
  `out_time` time DEFAULT NULL,
  `takeoff_time` time DEFAULT NULL,
  `landing_time` time DEFAULT NULL,
  `in_time` time DEFAULT NULL,
  `pilot_role` enum('PF','PM','PFTO','PFL') DEFAULT NULL,
  `companion_name` varchar(100) DEFAULT NULL,
  `crew_role` enum('captain','first officer') DEFAULT NULL,
  `air_time` time DEFAULT NULL,
  `block_time` time DEFAULT NULL,
  `approach_type` enum('APV','VISUAL') DEFAULT NULL,
  `flight_type` varchar(20) DEFAULT NULL,
  `employee_logbook_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_detail_logbook` (`daily_logbook_id`),
  KEY `fk_detail_airline_route` (`airline_route_id`),
  KEY `fk_detail_tail_number` (`actual_tail_number_id`),
  KEY `fk_detail_main_employee` (`employee_logbook_id`),
  CONSTRAINT `fk_detail_airline_route` FOREIGN KEY (`airline_route_id`) REFERENCES `airline_route` (`id`),
  CONSTRAINT `fk_detail_logbook` FOREIGN KEY (`daily_logbook_id`) REFERENCES `daily_logbook` (`id`),
  CONSTRAINT `fk_detail_main_employee` FOREIGN KEY (`employee_logbook_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `fk_detail_tail_number` FOREIGN KEY (`actual_tail_number_id`) REFERENCES `tail_number` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `id` varchar(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  `airline` varchar(36) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `identification_number` varchar(10) NOT NULL,
  `bp` varchar(16) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  `role` varchar(10) NOT NULL,
  `keycloak_user_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_email` (`email`),
  UNIQUE KEY `uq_ident_airline_bp` (`identification_number`,`airline`,`bp`),
  KEY `fk_airline` (`airline`),
  CONSTRAINT `fk_airline` FOREIGN KEY (`airline`) REFERENCES `airline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee_flight_summary`
--

DROP TABLE IF EXISTS `employee_flight_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_flight_summary` (
  `id` varchar(36) NOT NULL,
  `employee_id` varchar(36) NOT NULL,
  `period_type` varchar(20) NOT NULL,
  `period_year` int NOT NULL,
  `period_number` int NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `total_air_time` int DEFAULT '0',
  `total_block_time` int DEFAULT '0',
  `total_flights` int DEFAULT '0',
  `total_landings` int DEFAULT '0',
  `cat_approaches` int DEFAULT '0',
  `last_cat_approach_date` date DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_employee_period` (`employee_id`,`period_type`,`period_year`,`period_number`),
  CONSTRAINT `fk_summary_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `engine`
--

DROP TABLE IF EXISTS `engine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `engine` (
  `id` varchar(36) NOT NULL,
  `name` varchar(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `manufacturer`
--

DROP TABLE IF EXISTS `manufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manufacturer` (
  `id` varchar(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route` (
  `id` varchar(36) NOT NULL,
  `origin_airport_id` varchar(36) NOT NULL,
  `destination_airport_id` varchar(36) NOT NULL,
  `airport_type` varchar(13) NOT NULL,
  `estimated_flight_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_route_origin_destination` (`origin_airport_id`,`destination_airport_id`),
  KEY `fk_route_destination_airport` (`destination_airport_id`),
  CONSTRAINT `fk_route_destination_airport` FOREIGN KEY (`destination_airport_id`) REFERENCES `airport` (`id`),
  CONSTRAINT `fk_route_origin_airport` FOREIGN KEY (`origin_airport_id`) REFERENCES `airport` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_messages`
--

DROP TABLE IF EXISTS `system_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_messages` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'UUID primary key',
  `message_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique message code (e.g.: MOD_U_DUP_ERR_00001)',
  `type` enum('ERROR','EXITO','WARNING','INFO','DEBUG') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Message type',
  `category` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Category: end_user, system, validation',
  `module` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Module it belongs to: general, users, validation, authorization',
  `message_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Short message title (in Spanish)',
  `message_content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Message content with placeholders NULL, NULL, etc. (in Spanish)',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Indicates if the message is active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `message_code` (`message_code`),
  KEY `idx_code` (`message_code`),
  KEY `idx_type` (`type`),
  KEY `idx_module` (`module`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Table for dynamic system messages';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tail_number`
--

DROP TABLE IF EXISTS `tail_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tail_number` (
  `id` varchar(36) NOT NULL,
  `tail_number` varchar(7) NOT NULL,
  `aircraft_model_id` varchar(36) NOT NULL,
  `airline_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tail_number` (`tail_number`),
  KEY `fk_registration_model` (`aircraft_model_id`),
  KEY `fk_registration_airline` (`airline_id`),
  CONSTRAINT `fk_registration_airline` FOREIGN KEY (`airline_id`) REFERENCES `airline` (`id`),
  CONSTRAINT `fk_registration_model` FOREIGN KEY (`aircraft_model_id`) REFERENCES `aircraft_model` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-05 21:21:03
