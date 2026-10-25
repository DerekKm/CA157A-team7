-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: samepage
-- ------------------------------------------------------
-- Server version	26.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--



--
-- Table structure for table `announcement`
--
CREATE DATABASE IF NOT EXISTS samepage;
USE samepage;
DROP TABLE IF EXISTS `announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement` (
  `announcement_id` int NOT NULL,
  `group_id` int DEFAULT NULL,
  `author_id` int DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `content` varchar(200) DEFAULT NULL,
  `is_pinned` tinyint DEFAULT NULL,
  `created_at` timestamp(2) NULL DEFAULT NULL,
  PRIMARY KEY (`announcement_id`),
  KEY `author's_id_idx` (`author_id`),
  KEY `group_id_idx` (`group_id`),
  CONSTRAINT `author's_id` FOREIGN KEY (`author_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `group_idxx` FOREIGN KEY (`group_id`) REFERENCES `mediagroup` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement`
--

LOCK TABLES `announcement` WRITE;
/*!40000 ALTER TABLE `announcement` DISABLE KEYS */;
INSERT INTO `announcement` VALUES (1,1,1,'New Sci-Fi Releases','Check out upcoming shows',1,'2025-11-01 07:00:00.00'),(2,2,3,'Anime Marathon','Weekend watch party',0,'2025-11-02 07:00:00.00'),(3,3,6,'Fantasy Book Poll','Vote for next read',1,'2025-11-03 08:00:00.00'),(4,4,2,'Drama Night','Live discussion event',0,'2025-11-04 08:00:00.00'),(5,5,5,'New Documentary Added','Earth Pulse now available',1,'2025-11-05 08:00:00.00'),(6,6,4,'HeroVerse Update','New superhero series incoming',0,'2025-11-06 08:00:00.00'),(7,7,8,'Horror Week','Nightfall binge event',1,'2025-11-07 08:00:00.00'),(8,8,10,'Retro Film Night','Golden Age screening',0,'2025-11-08 08:00:00.00'),(9,9,6,'Romance Poll','Choose next show',0,'2025-11-09 08:00:00.00'),(10,10,9,'GameAdapt Update','New game-adapted media added',1,'2025-11-10 08:00:00.00');
/*!40000 ALTER TABLE `announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `befriends`
--

DROP TABLE IF EXISTS `befriends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `befriends` (
  `user_id` int NOT NULL,
  `friend_id` int NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  `requested_at` timestamp(2) NULL DEFAULT NULL,
  `responded_at` timestamp(2) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`friend_id`),
  KEY `friend_id_idx` (`friend_id`),
  CONSTRAINT `friend_id` FOREIGN KEY (`friend_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `user id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `befriends`
--

LOCK TABLES `befriends` WRITE;
/*!40000 ALTER TABLE `befriends` DISABLE KEYS */;
INSERT INTO `befriends` VALUES (1,3,'accepted','2025-10-01 07:00:00.00','2025-10-02 07:00:00.00'),(2,4,'accepted','2025-10-03 07:00:00.00','2025-10-04 07:00:00.00'),(3,6,'pending','2025-10-05 07:00:00.00',NULL),(4,5,'accepted','2025-10-06 07:00:00.00','2025-10-07 07:00:00.00'),(5,7,'declined','2025-10-08 07:00:00.00','2025-10-09 07:00:00.00'),(6,8,'accepted','2025-10-10 07:00:00.00','2025-10-11 07:00:00.00'),(7,9,'pending','2025-10-12 07:00:00.00',NULL),(8,10,'accepted','2025-10-13 07:00:00.00','2025-10-14 07:00:00.00'),(9,1,'accepted','2025-10-15 07:00:00.00','2025-10-16 07:00:00.00'),(10,2,'pending','2025-10-17 07:00:00.00',NULL);
/*!40000 ALTER TABLE `befriends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussionthread`
--

DROP TABLE IF EXISTS `discussionthread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussionthread` (
  `thread_id` int NOT NULL,
  `group_id` int NOT NULL,
  `media_id` int DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `creator_id` int DEFAULT NULL,
  `topic` varchar(45) DEFAULT NULL,
  `is_spoiler` tinyint DEFAULT NULL,
  `spoiler_season` int DEFAULT NULL,
  `spoiler_unit` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`thread_id`,`group_id`),
  KEY `group_id_idx` (`group_id`),
  KEY `media_id_idx` (`media_id`),
  CONSTRAINT `group_id` FOREIGN KEY (`group_id`) REFERENCES `mediagroup` (`group_id`),
  CONSTRAINT `media_id` FOREIGN KEY (`media_id`) REFERENCES `media` (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussionthread`
--

LOCK TABLES `discussionthread` WRITE;
/*!40000 ALTER TABLE `discussionthread` DISABLE KEYS */;
INSERT INTO `discussionthread` VALUES (1,1,1,'Season 3 Finale Talk',1,'Sci-fi theories',1,3,'10'),(2,2,2,'Blade Spirits S2 Discussion',3,'Anime analysis',0,NULL,NULL),(3,3,3,'Kingdom of Ash Lore',6,'Fantasy lore',0,NULL,NULL),(4,4,4,'City Tears Episode 5',2,'Drama breakdown',1,1,'5'),(5,5,5,'Earth Pulse Review',5,'Documentary talk',0,NULL,NULL),(6,6,6,'Iron Sentinel S1',4,'Superhero theories',0,NULL,NULL),(7,7,7,'Nightfall Season 2',8,'Horror discussion',1,2,'3'),(8,8,8,'Golden Age Retrospective',10,'Classic film analysis',0,NULL,NULL),(9,9,9,'LoveLines S2',6,'Romance talk',0,NULL,NULL),(10,10,10,'QuestBound Game vs Show',9,'Adaptation comparison',0,NULL,NULL);
/*!40000 ALTER TABLE `discussionthread` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `genre_id` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Science Fiction'),(2,'Fantasy'),(3,'Drama'),(4,'Documentary'),(5,'Superhero'),(6,'Horror'),(7,'Romance'),(8,'Classic'),(9,'Anime'),(10,'Game-Adapted');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupmembership`
--

DROP TABLE IF EXISTS `groupmembership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groupmembership` (
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  `role_id` int NOT NULL,
  `joined_at` timestamp(2) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`group_id`,`role_id`),
  KEY `groupID_idx` (`group_id`),
  CONSTRAINT `groupID` FOREIGN KEY (`group_id`) REFERENCES `mediagroup` (`group_id`),
  CONSTRAINT `user's id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupmembership`
--

LOCK TABLES `groupmembership` WRITE;
/*!40000 ALTER TABLE `groupmembership` DISABLE KEYS */;
INSERT INTO `groupmembership` VALUES (1,1,1,'2025-09-01 07:00:00.00'),(2,4,4,'2025-09-12 07:00:00.00'),(3,2,2,'2025-09-05 07:00:00.00'),(4,6,6,'2025-09-18 07:00:00.00'),(5,5,5,'2025-09-15 07:00:00.00'),(6,3,3,'2025-09-10 07:00:00.00'),(6,9,9,'2025-09-25 07:00:00.00'),(8,7,7,'2025-09-20 07:00:00.00'),(9,10,10,'2025-09-28 07:00:00.00'),(10,8,8,'2025-09-22 07:00:00.00');
/*!40000 ALTER TABLE `groupmembership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grouprole`
--

DROP TABLE IF EXISTS `grouprole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grouprole` (
  `role_id` int NOT NULL,
  `group_id` int NOT NULL,
  `role_name` varchar(45) DEFAULT NULL,
  `can_add_media` tinyint DEFAULT NULL,
  `can_create_threads` tinyint DEFAULT NULL,
  `can_moderate` tinyint DEFAULT NULL,
  `can_manage_members` tinyint DEFAULT NULL,
  `can_post_announcements` tinyint DEFAULT NULL,
  PRIMARY KEY (`role_id`,`group_id`),
  KEY `group_id_idx` (`group_id`),
  CONSTRAINT `mediagroup_id` FOREIGN KEY (`group_id`) REFERENCES `mediagroup` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grouprole`
--

LOCK TABLES `grouprole` WRITE;
/*!40000 ALTER TABLE `grouprole` DISABLE KEYS */;
INSERT INTO `grouprole` VALUES (1,1,'Owner',1,1,1,1,1),(2,2,'Moderator',1,1,1,0,1),(3,3,'Member',0,1,0,0,0),(4,4,'Owner',1,1,1,1,1),(5,5,'Member',0,1,0,0,0),(6,6,'Moderator',1,1,1,0,1),(7,7,'Member',0,1,0,0,0),(8,8,'Owner',1,1,1,1,1),(9,9,'Member',0,1,0,0,0),(10,10,'Moderator',1,1,1,0,1);
/*!40000 ALTER TABLE `grouprole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `media_id` int NOT NULL,
  `title` varchar(45) DEFAULT NULL,
  `media_type` varchar(45) DEFAULT NULL,
  `creator` varchar(45) DEFAULT NULL,
  `series` varchar(45) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `release_year` varchar(20) DEFAULT NULL,
  `cover_image_url` varchar(100) DEFAULT NULL,
  `total_seasons` int DEFAULT NULL,
  PRIMARY KEY (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,'Star Odyssey','series','Nova Studios','Star Odyssey','Epic sci-fi adventure','2022','/covers/m1.png',3),(2,'Blade Spirits','anime','KyotoWorks','Blade Spirits','Samurai fantasy anime','2021','/covers/m2.png',2),(3,'Kingdom of Ash','series','HBO','Kingdom of Ash','Dark fantasy drama','2020','/covers/m3.png',4),(4,'City Tears','series','PrimeTV','City Tears','Urban drama','2023','/covers/m4.png',1),(5,'Earth Pulse','documentary','NatGeo',NULL,'Planet exploration documentary','2019','/covers/m5.png',1),(6,'Iron Sentinel','series','Marvel','Iron Sentinel','Superhero action','2024','/covers/m6.png',2),(7,'Nightfall','series','HorrorWorks','Nightfall','Supernatural horror','2022','/covers/m7.png',3),(8,'Golden Age','film','RetroFilms',NULL,'Classic drama film','1975','/covers/m8.png',0),(9,'LoveLines','series','HeartTV','LoveLines','Romantic slice-of-life','2021','/covers/m9.png',2),(10,'QuestBound','series','GameWorks','QuestBound','Game-adapted fantasy','2023','/covers/m10.png',1);
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mediagroup`
--

DROP TABLE IF EXISTS `mediagroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mediagroup` (
  `group_id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `created_at` timestamp(2) NULL DEFAULT NULL,
  PRIMARY KEY (`group_id`),
  KEY `owner_id_idx` (`owner_id`),
  CONSTRAINT `owner_id` FOREIGN KEY (`owner_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mediagroup`
--

LOCK TABLES `mediagroup` WRITE;
/*!40000 ALTER TABLE `mediagroup` DISABLE KEYS */;
INSERT INTO `mediagroup` VALUES (1,1,'Group for sci-fi shows','Sci-Fi Central','2025-07-01 07:00:00.00'),(2,3,'Anime discussion hub','Anime World','2025-07-10 07:00:00.00'),(3,7,'Fantasy books & shows','Fantasy Realm','2025-07-15 07:00:00.00'),(4,2,'Drama lovers unite','Drama Club','2025-07-20 07:00:00.00'),(5,5,'Documentaries & learning','DocuHub','2025-07-25 07:00:00.00'),(6,4,'Superhero & comics media','HeroVerse','2025-08-01 07:00:00.00'),(7,8,'Horror movies & shows','Nightmare Society','2025-08-05 07:00:00.00'),(8,10,'Classic cinema fans','Retro Films','2025-08-10 07:00:00.00'),(9,6,'Romance & slice-of-life','HeartBeat Media','2025-08-15 07:00:00.00'),(10,9,'Gaming & game-adapted media','GameAdapt','2025-08-20 07:00:00.00');
/*!40000 ALTER TABLE `mediagroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message` (
  `message_id` int NOT NULL,
  `thread_id` int DEFAULT NULL,
  `author_id` int DEFAULT NULL,
  `hidden_by` int DEFAULT NULL,
  `created_at` timestamp(2) NULL DEFAULT NULL,
  `content` varchar(200) DEFAULT NULL,
  `edited_at` timestamp(2) NULL DEFAULT NULL,
  `spoiler_unit` varchar(45) DEFAULT NULL,
  `is_hidden` tinyint DEFAULT NULL,
  `spoiler_season` int DEFAULT NULL,
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
INSERT INTO `message` VALUES (1,1,1,NULL,'2025-10-01 07:00:00.00','That finale was wild',NULL,'10',0,3),(2,2,3,NULL,'2025-10-02 07:00:00.00','Loved the animation quality',NULL,NULL,0,NULL),(3,3,6,NULL,'2025-10-03 07:00:00.00','The lore is deep',NULL,NULL,0,NULL),(4,4,2,7,'2025-10-04 07:00:00.00','Spoiler heavy!',NULL,'5',1,1),(5,5,5,NULL,'2025-10-05 07:00:00.00','Great documentary',NULL,NULL,0,NULL),(6,6,4,NULL,'2025-10-06 07:00:00.00','Iron Sentinel is awesome',NULL,NULL,0,NULL),(7,7,8,NULL,'2025-10-07 07:00:00.00','Nightfall is terrifying',NULL,'3',0,2),(8,8,10,NULL,'2025-10-08 07:00:00.00','Classic masterpiece',NULL,NULL,0,NULL),(9,9,6,NULL,'2025-10-09 07:00:00.00','LoveLines is wholesome',NULL,NULL,0,NULL),(10,10,9,NULL,'2025-10-10 07:00:00.00','Game adaptation is solid',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shares`
--

DROP TABLE IF EXISTS `shares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shares` (
  `group_id` int NOT NULL,
  `media_id` int NOT NULL,
  `added_at` timestamp(2) NULL DEFAULT NULL,
  PRIMARY KEY (`group_id`,`media_id`),
  KEY `media_id_idx` (`media_id`),
  CONSTRAINT `group_idd` FOREIGN KEY (`group_id`) REFERENCES `mediagroup` (`group_id`),
  CONSTRAINT `media_idd` FOREIGN KEY (`media_id`) REFERENCES `media` (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shares`
--

LOCK TABLES `shares` WRITE;
/*!40000 ALTER TABLE `shares` DISABLE KEYS */;
INSERT INTO `shares` VALUES (1,1,'2025-12-01 08:00:00.00'),(2,2,'2025-12-02 08:00:00.00'),(3,3,'2025-12-03 08:00:00.00'),(4,4,'2025-12-04 08:00:00.00'),(5,5,'2025-12-05 08:00:00.00'),(6,6,'2025-12-06 08:00:00.00'),(7,7,'2025-12-07 08:00:00.00'),(8,8,'2025-12-08 08:00:00.00'),(9,9,'2025-12-09 08:00:00.00'),(10,10,'2025-12-10 08:00:00.00');
/*!40000 ALTER TABLE `shares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracks`
--

DROP TABLE IF EXISTS `tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracks` (
  `media_id` int NOT NULL,
  `owner_id` int NOT NULL,
  `status` varchar(15) DEFAULT NULL,
  `current_season` int DEFAULT NULL,
  `updated_at` varchar(45) DEFAULT NULL,
  `added_at` varchar(45) DEFAULT NULL,
  `current_unit` varchar(45) DEFAULT NULL,
  `category` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`media_id`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracks`
--

LOCK TABLES `tracks` WRITE;
/*!40000 ALTER TABLE `tracks` DISABLE KEYS */;
INSERT INTO `tracks` VALUES (1,1,'watching',3,'2026-01-01','2025-12-15','10','sci-fi'),(2,3,'completed',2,'2026-01-02','2025-12-16',NULL,'anime'),(3,6,'watching',2,'2026-01-03','2025-12-17','5','fantasy'),(4,2,'watching',1,'2026-01-04','2025-12-18','5','drama'),(5,5,'completed',1,'2026-01-05','2025-12-19',NULL,'documentary'),(6,4,'watching',1,'2026-01-06','2025-12-20','3','superhero'),(7,8,'watching',2,'2026-01-07','2025-12-21','3','horror'),(8,10,'completed',0,'2026-01-08','2025-12-22',NULL,'classic'),(9,6,'watching',2,'2026-01-09','2025-12-23','4','romance'),(10,9,'watching',1,'2026-01-10','2025-12-24','2','game-adapted');
/*!40000 ALTER TABLE `tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL,
  `display_name` varchar(45) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password_hash` varchar(100) DEFAULT NULL,
  `bio` varchar(200) DEFAULT NULL,
  `role` varchar(15) DEFAULT NULL,
  `profile_picture_url` varchar(80) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Derek','derek01','derek@example.com','hash_abc1','Tech enthusiast','member','/img/u1.png','2025-01-10 00:00:00'),(2,'Sara K','sara_k','sara@example.com','hash_abc2','Movie lover','member','/img/u2.png','2025-02-14 00:00:00'),(3,'Mike','mike_dev','mike@example.com','hash_abc3','Coder & gamer','admin','/img/u3.png','2025-03-01 00:00:00'),(4,'Luna','luna_star','luna@example.com','hash_abc4','Sci-fi addict','member','/img/u4.png','2025-03-22 00:00:00'),(5,'John','johnny','john@example.com','hash_abc5','Anime fan','member','/img/u5.png','2025-04-05 00:00:00'),(6,'Alex R','alex_r','alex@example.com','hash_abc6','Fantasy reader','member','/img/u6.png','2025-04-20 00:00:00'),(7,'Tina','tina_m','tina@example.com','hash_abc7','Drama watcher','moderator','/img/u7.png','2025-05-01 00:00:00'),(8,'Rob','robbie','rob@example.com','hash_abc8','Documentary fan','member','/img/u8.png','2025-05-18 00:00:00'),(9,'Kevin','kevin_p','kevin@example.com','hash_abc9','Comics & TV','member','/img/u9.png','2025-06-02 00:00:00'),(10,'Nina','nina_v','nina@example.com','hash_abc10','Horror fan','member','/img/u10.png','2025-06-20 00:00:00');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-19 19:26:17
