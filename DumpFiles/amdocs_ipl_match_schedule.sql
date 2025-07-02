-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: amdocs_ipl
-- ------------------------------------------------------
-- Server version	8.0.42

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

--
-- Table structure for table `match_schedule`
--

DROP TABLE IF EXISTS `match_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_schedule` (
  `match_id` varchar(10) NOT NULL,
  `team1_id` varchar(10) DEFAULT NULL,
  `team2_id` varchar(10) DEFAULT NULL,
  `ground_id` varchar(10) DEFAULT NULL,
  `umpire1_id` varchar(10) DEFAULT NULL,
  `umpire2_id` varchar(10) DEFAULT NULL,
  `match_date` date DEFAULT NULL,
  `toss` varchar(10) DEFAULT NULL,
  `match_winner` varchar(10) DEFAULT NULL,
  `match_status` enum('Completed','Upcoming','Cancelled','On-going') NOT NULL,
  `match_result` enum('Win','Loss','Draw','Cancel','X') NOT NULL,
  PRIMARY KEY (`match_id`),
  KEY `team1_id` (`team1_id`),
  KEY `team2_id` (`team2_id`),
  KEY `ground_id` (`ground_id`),
  KEY `umpire1_id` (`umpire1_id`),
  KEY `umpire2_id` (`umpire2_id`),
  CONSTRAINT `match_schedule_ibfk_1` FOREIGN KEY (`team1_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `match_schedule_ibfk_2` FOREIGN KEY (`team2_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `match_schedule_ibfk_3` FOREIGN KEY (`ground_id`) REFERENCES `ground` (`ground_id`),
  CONSTRAINT `match_schedule_ibfk_4` FOREIGN KEY (`umpire1_id`) REFERENCES `umpire` (`umpire_id`),
  CONSTRAINT `match_schedule_ibfk_5` FOREIGN KEY (`umpire2_id`) REFERENCES `umpire` (`umpire_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_schedule`
--

LOCK TABLES `match_schedule` WRITE;
/*!40000 ALTER TABLE `match_schedule` DISABLE KEYS */;
INSERT INTO `match_schedule` VALUES ('M001','T001','T002','G001','U001','U002','2025-04-01','T001','T001','Completed','Win'),('M002','T003','T004','G003','U003','U004','2025-04-02','T003','T004','Completed','Win'),('M003','T002','T004','G002','U005','U006','2025-04-03','T004',NULL,'Cancelled','Cancel'),('M004','T004','T001','G004','U007','U008','2025-04-04','T004','T001','Completed','Win'),('M005','T001','T003','G001','U009','U010','2025-04-05','T003','T001','Completed','Win'),('M006','T002','T003','G002','U001','U003','2025-04-06','T002','T003','Completed','Win'),('M007','T003','T001','G003','U004','U005','2025-04-07','T001','T001','Completed','Win'),('M008','T004','T002','G004','U006','U007','2025-04-08','T004',NULL,'Cancelled','Cancel'),('M009','T003','T002','G003','U008','U009','2025-04-09','T003','T003','Completed','Win'),('M010','T004','T001','G004','U010','U001','2025-04-10','T004',NULL,'Upcoming','X'),('M011','T001','T004','G001','U002','U003','2025-04-11','T001',NULL,'Upcoming','X'),('M012','T002','T003','G002','U004','U005','2025-04-12','T002',NULL,'Upcoming','X'),('M013','T001','T002','G001','U006','U007','2025-04-13','T002',NULL,'Upcoming','X');
/*!40000 ALTER TABLE `match_schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_invalid_match_config` BEFORE INSERT ON `match_schedule` FOR EACH ROW BEGIN
    -- Ensure different teams
    IF NEW.team1_id = NEW.team2_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A match cannot be scheduled between the same team.';
    END IF;

    -- Ensure different umpires
    IF NEW.umpire1_id = NEW.umpire2_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A match must have two different umpires.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-02 14:07:30
