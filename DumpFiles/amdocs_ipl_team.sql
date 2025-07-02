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
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `team_id` varchar(10) NOT NULL,
  `team_name` varchar(100) NOT NULL,
  `team_owner` varchar(100) NOT NULL,
  `ground_id` varchar(10) DEFAULT NULL,
  `team_budget` int DEFAULT NULL,
  `create_date` date DEFAULT NULL,
  `team_password` varchar(200) NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE KEY `team_name` (`team_name`),
  KEY `ground_id` (`ground_id`),
  CONSTRAINT `team_ibfk_1` FOREIGN KEY (`ground_id`) REFERENCES `ground` (`ground_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES ('T001','Mumbai Indians','Reliance Industries','G001',95000000,'2008-04-01','aa6546bc78be36b92bb685a4edb4caaee6892bdd5ecdfdf5184f70b879d2876b'),('T002','Kolkata Knight Riders','Red Chillies Entertainment','G002',91000000,'2008-04-01','bba11e65f4ace8a0c817d0d6293f90453c940097a2da6f6635daec2428241a19'),('T003','Royal Challengers Bangalore','United Spirits','G003',92000000,'2008-04-01','1a628bf5362905a18f1dd11dbf51a032d40bfb37af2a238a282a986263b27f88'),('T004','Gujarat Titans','CVC Capital Partners','G004',93000000,'2022-01-01','6788f4e93e7c613d0a8797e0bc37aef3b70385d64203ea63b4e68c1d0b454d5f');
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-02 14:07:29
