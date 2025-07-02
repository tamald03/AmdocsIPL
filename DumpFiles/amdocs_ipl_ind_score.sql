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
-- Table structure for table `ind_score`
--

DROP TABLE IF EXISTS `ind_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ind_score` (
  `player_id` varchar(10) NOT NULL,
  `team_id` varchar(10) NOT NULL,
  `match_id` varchar(10) NOT NULL,
  `runs` int DEFAULT NULL,
  `wickets` int DEFAULT NULL,
  `catches` int DEFAULT NULL,
  `sixes` int DEFAULT NULL,
  `fours` int DEFAULT NULL,
  PRIMARY KEY (`player_id`,`match_id`),
  KEY `team_id` (`team_id`),
  KEY `match_id` (`match_id`),
  CONSTRAINT `ind_score_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`),
  CONSTRAINT `ind_score_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `ind_score_ibfk_3` FOREIGN KEY (`match_id`) REFERENCES `match_schedule` (`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ind_score`
--

LOCK TABLES `ind_score` WRITE;
/*!40000 ALTER TABLE `ind_score` DISABLE KEYS */;
INSERT INTO `ind_score` VALUES ('P001','T001','M010',9,3,1,0,0),('P002','T001','M010',10,2,0,0,1),('P003','T001','M010',33,2,1,1,0),('P004','T001','M010',25,0,0,1,1),('P005','T001','M010',56,0,2,1,4),('P006','T001','M010',8,3,0,0,0),('P007','T001','M010',55,2,2,2,0),('P014','T003','M010',77,0,1,2,5),('P015','T003','M010',73,1,0,3,6),('P016','T003','M010',40,0,0,1,1),('P017','T003','M010',7,2,2,0,0),('P018','T003','M010',41,1,1,2,3),('P019','T003','M010',7,1,2,0,0),('P026','T003','M010',56,2,2,2,3),('P028','T001','M010',14,0,0,0,1),('P030','T003','M010',80,3,0,3,3),('P032','T001','M010',61,1,2,1,2),('P034','T003','M010',8,2,2,0,0),('P036','T001','M010',60,1,2,0,3),('P038','T003','M010',44,1,2,0,1),('P040','T001','M010',11,0,2,0,1),('P042','T003','M010',58,0,2,0,4);
/*!40000 ALTER TABLE `ind_score` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-02 14:07:30
