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
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player` (
  `player_id` varchar(10) NOT NULL,
  `player_name` varchar(100) NOT NULL,
  `player_age` int DEFAULT NULL,
  `player_country` varchar(50) DEFAULT NULL,
  `player_role` enum('Batsman','Bowler','All-rounder','Wicket-keeper') NOT NULL,
  `team_id` varchar(10) DEFAULT NULL,
  `match_id` varchar(10) DEFAULT NULL,
  `iscaptain` tinyint(1) DEFAULT '0',
  `player_password` varchar(100) NOT NULL,
  PRIMARY KEY (`player_id`),
  KEY `team_id` (`team_id`),
  KEY `match_id` (`match_id`),
  CONSTRAINT `player_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE SET NULL,
  CONSTRAINT `player_ibfk_2` FOREIGN KEY (`match_id`) REFERENCES `match_schedule` (`match_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player`
--

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` VALUES ('P001','Rohit Sharma',36,'India','Batsman','T001',NULL,1,'rohit@mi'),('P002','Suryakumar Yadav',34,'India','Batsman','T001',NULL,0,'sky@mi'),('P003','Ishan Kishan',26,'India','Wicket-keeper','T001',NULL,0,'ik@mi'),('P004','Hardik Pandya',31,'India','All-rounder','T001',NULL,0,'hp@mi'),('P005','Tilak Varma',21,'India','Batsman','T001',NULL,0,'tv@mi'),('P006','Jasprit Bumrah',30,'India','Bowler','T001',NULL,0,'jb@mi'),('P007','Arjun Tendulkar',24,'India','Bowler','T001',NULL,0,'arjun@mi'),('P008','Shreyas Iyer',29,'India','Batsman','T002',NULL,1,'iyer@kkr'),('P009','Rinku Singh',27,'India','Batsman','T002',NULL,0,'rinku@kkr'),('P010','Venkatesh Iyer',28,'India','All-rounder','T002',NULL,0,'vi@kkr'),('P011','Andre Russell',34,'West Indies','All-rounder','T002',NULL,0,'ar@kkr'),('P012','Sunil Narine',36,'West Indies','All-rounder','T002',NULL,0,'sn@kkr'),('P013','Varun Chakravarthy',31,'India','Bowler','T002',NULL,0,'vc@kkr'),('P014','Virat Kohli',36,'India','Batsman','T003',NULL,0,'vk@rcb'),('P015','Faf du Plessis',40,'South Africa','Batsman','T003',NULL,1,'faf@rcb'),('P016','Glenn Maxwell',35,'Australia','All-rounder','T003',NULL,0,'gm@rcb'),('P017','Dinesh Karthik',38,'India','Wicket-keeper','T003',NULL,0,'dk@rcb'),('P018','Mohammed Siraj',29,'India','Bowler','T003',NULL,0,'ms@rcb'),('P019','Anuj Rawat',24,'India','Wicket-keeper','T003',NULL,0,'ar@rcb'),('P020','Shubman Gill',25,'India','Batsman','T004',NULL,1,'sg@gt'),('P021','David Miller',35,'South Africa','Batsman','T004',NULL,0,'dm@gt'),('P022','Rashid Khan',26,'Afghanistan','Bowler','T004',NULL,0,'rk@gt'),('P023','Wriddhiman Saha',39,'India','Wicket-keeper','T004',NULL,0,'ws@gt'),('P024','Rahul Tewatia',31,'India','All-rounder','T004',NULL,0,'rt@gt'),('P025','Mohit Sharma',35,'India','Bowler','T004',NULL,0,'mohit@gt'),('P026','Yashasvi Jaiswal',28,'India','All-rounder','T003',NULL,0,'yashasvi@ipl'),('P027','Ruturaj Gaikwad',29,'India','Wicket-keeper','T004',NULL,0,'ruturaj@ipl'),('P028','Sanju Samson',30,'India','Batsman','T001',NULL,0,'sanju@ipl'),('P029','Deepak Hooda',31,'India','Bowler','T002',NULL,0,'deepak@ipl'),('P030','Axar Patel',22,'India','All-rounder','T003',NULL,0,'axar@ipl'),('P031','Kuldeep Yadav',23,'India','Wicket-keeper','T004',NULL,0,'kuldeep@ipl'),('P032','Prithvi Shaw',24,'India','Batsman','T001',NULL,0,'prithvi@ipl'),('P033','Ravindra Jadeja',25,'India','Bowler','T002',NULL,0,'ravindra@ipl'),('P034','KL Rahul',26,'India','All-rounder','T003',NULL,0,'kl@ipl'),('P035','Shikhar Dhawan',27,'India','Wicket-keeper','T004',NULL,0,'shikhar@ipl'),('P036','Mayank Agarwal',28,'India','Batsman','T001',NULL,0,'mayank@ipl'),('P037','Bhuvneshwar Kumar',29,'India','Bowler','T002',NULL,0,'bhuvneshwar@ipl'),('P038','T Natarajan',30,'India','All-rounder','T003',NULL,0,'t@ipl'),('P039','Washington Sundar',31,'India','Wicket-keeper','T004',NULL,0,'washington@ipl'),('P040','Umran Malik',22,'India','Batsman','T001',NULL,0,'umran@ipl'),('P041','Devdutt Padikkal',23,'India','Bowler','T002',NULL,0,'devdutt@ipl'),('P042','Shivam Dube',24,'India','All-rounder','T003',NULL,0,'shivam@ipl'),('P043','R Sai Kishore',25,'India','Wicket-keeper','T004',NULL,0,'r@ipl'),('P044','Chetan Sakariya',26,'India','Batsman','T001',NULL,0,'chetan@ipl'),('P045','Shahrukh Khan',27,'India','Bowler','T002',NULL,0,'shahrukh@ipl'),('P046','Arshdeep Singh',28,'India','All-rounder','T003',NULL,0,'arshdeep@ipl'),('P047','Harshal Patel',29,'India','Wicket-keeper','T004',NULL,0,'harshal@ipl'),('P048','Ravi Bishnoi',30,'India','Batsman','T001',NULL,0,'ravi@ipl'),('P049','Manish Pandey',31,'India','Bowler','T002',NULL,0,'manish@ipl'),('P050','Abhishek Sharma',22,'India','All-rounder','T003',NULL,0,'abhishek@ipl'),('P051','Raj Angad Bawa',23,'India','Wicket-keeper','T004',NULL,0,'raj@ipl'),('P052','Sai Sudharsan',24,'India','Batsman','T001',NULL,0,'sai@ipl'),('P053','Jitesh Sharma',25,'India','Bowler','T002',NULL,0,'jitesh@ipl'),('P054','Riyan Parag',26,'India','All-rounder','T003',NULL,0,'riyan@ipl'),('P055','Yuzvendra Chahal',27,'India','Wicket-keeper','T004',NULL,0,'yuzvendra@ipl'),('P056','Avesh Khan',28,'India','Batsman','T001',NULL,0,'avesh@ipl'),('P057','Ishan Porel',29,'India','Bowler','T002',NULL,0,'ishan@ipl'),('P058','Nitish Rana',30,'India','All-rounder','T003',NULL,0,'nitish@ipl'),('P059','Rahul Tripathi',31,'India','Wicket-keeper','T004',NULL,0,'rahul@ipl'),('P060','Anmolpreet Singh',22,'India','Batsman','T001',NULL,0,'anmolpreet@ipl'),('P061','Sandeep Sharma',23,'India','Bowler','T002',NULL,0,'sandeep@ipl'),('P062','Navdeep Saini',24,'India','All-rounder','T003',NULL,0,'navdeep@ipl'),('P063','Shubham Mavi',25,'India','Wicket-keeper','T004',NULL,0,'shubham@ipl'),('P064','Kamlesh Nagarkoti',26,'India','Batsman','T001',NULL,0,'kamlesh@ipl'),('P065','Lalit Yadav',27,'India','Bowler','T002',NULL,0,'lalit@ipl'),('P066','Anmolpreet Singh',28,'India','All-rounder','T003',NULL,0,'anmolpreet@ipl'),('P067','Simarjeet Singh',29,'India','Wicket-keeper','T004',NULL,0,'simarjeet@ipl'),('P068','Mukesh Choudhary',30,'India','Batsman','T001',NULL,0,'mukesh@ipl'),('P069','Kartik Tyagi',31,'India','Bowler','T002',NULL,0,'kartik@ipl'),('P070','Maheesh Theekshana',22,'India','All-rounder','T003',NULL,0,'maheesh@ipl'),('P071','B Sai Praneeth',23,'India','Wicket-keeper','T004',NULL,0,'b@ipl'),('P072','Rajvardhan Hangargekar',24,'India','Batsman','T001',NULL,0,'rajvardhan@ipl'),('P073','Vicky Ostwal',25,'India','Bowler','T002',NULL,0,'vicky@ipl'),('P074','Hrithik Shokeen',26,'India','All-rounder','T003',NULL,0,'hrithik@ipl'),('P075','Suyash Sharma',27,'India','Wicket-keeper','T004',NULL,0,'suyash@ipl'),('P234','Tamal Das',NULL,'India','Batsman','T002',NULL,0,'73ca3388317c44a66ed4d0b2cf56b2fcee3386ecf5f89245113a746edbc39d04'),('P808','K L',NULL,'india','Batsman','T002',NULL,0,'e49d9152d9e8b3dfaf151a4d73dd8e75c0a0ce58ffa80387898111df23c6b7a4');
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_captain_and_max_players` BEFORE INSERT ON `player` FOR EACH ROW BEGIN
    DECLARE player_count INT;
    DECLARE captain_count INT;

    -- Max 25 players check
    IF NEW.team_id IS NOT NULL THEN
        SELECT COUNT(*) INTO player_count FROM player WHERE team_id = NEW.team_id;
        IF player_count >= 25 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add player: Team already has maximum 25 players.';
        END IF;
    END IF;

    -- Single captain check
    IF NEW.iscaptain = TRUE THEN
        SELECT COUNT(*) INTO captain_count 
        FROM player 
        WHERE team_id = NEW.team_id AND iscaptain = TRUE;
        
        IF captain_count >= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A team can have only one captain.';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_single_captain_update` BEFORE UPDATE ON `player` FOR EACH ROW BEGIN
    DECLARE cap_count INT;

    IF NEW.iscaptain = TRUE AND OLD.iscaptain = FALSE THEN
        SELECT COUNT(*) INTO cap_count 
        FROM player 
        WHERE team_id = NEW.team_id AND iscaptain = TRUE;

        IF cap_count >= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'This team already has a captain.';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_min_18_players` BEFORE DELETE ON `player` FOR EACH ROW BEGIN
    DECLARE player_count INT;

    IF OLD.team_id IS NOT NULL THEN
        SELECT COUNT(*) INTO player_count 
        FROM player WHERE team_id = OLD.team_id;

        IF player_count <= 18 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Cannot delete player: Team must have at least 18 players.';
        END IF;
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
