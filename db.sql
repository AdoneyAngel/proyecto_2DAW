CREATE DATABASE  IF NOT EXISTS `pulse` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `pulse`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: pulse
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.28-MariaDB

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
-- Table structure for table `proyects`
--

DROP TABLE IF EXISTS `proyects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fr_usersProyects_users_idx` (`owner_id`),
  CONSTRAINT `fr_usersProyects_users` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects`
--

LOCK TABLES `proyects` WRITE;
/*!40000 ALTER TABLE `proyects` DISABLE KEYS */;
INSERT INTO `proyects` VALUES (1,18,'modificado','2025-02-27 21:37:56'),(2,6,'prueba','2025-02-27 21:37:59'),(3,18,'prueba2','2025-02-27 22:16:20'),(4,18,'prueba3','2025-02-27 22:17:38'),(5,18,'prueba4','2025-02-28 09:03:10'),(6,18,'proyecto modificado 3','2025-02-28 09:04:11'),(7,17,'prueba5','2025-02-28 17:03:13');
/*!40000 ALTER TABLE `proyects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_members`
--

DROP TABLE IF EXISTS `proyects_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_members` (
  `proyect_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `effective_time` int(11) NOT NULL,
  PRIMARY KEY (`proyect_id`,`user_id`),
  KEY `fr_proyectsMembers_users_idx` (`user_id`),
  KEY `fr_proyectsMembers_proyects_idx` (`proyect_id`),
  CONSTRAINT `fr_proyectsMembers_proyects` FOREIGN KEY (`proyect_id`) REFERENCES `proyects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsMembers_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_members`
--

LOCK TABLES `proyects_members` WRITE;
/*!40000 ALTER TABLE `proyects_members` DISABLE KEYS */;
INSERT INTO `proyects_members` VALUES (1,6,0,15),(1,8,0,150),(1,15,0,5),(1,16,0,5),(2,16,0,1),(2,17,0,1),(3,18,0,1),(7,6,0,5);
/*!40000 ALTER TABLE `proyects_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_members_history`
--

DROP TABLE IF EXISTS `proyects_members_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_members_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `proyect_id` int(11) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fr_proyectsMembersHistory_users_idx` (`user_id`),
  KEY `fr_proyectsMembersHistory_proyects_idx` (`proyect_id`),
  CONSTRAINT `fr_proyectsMembersHistory_proyects` FOREIGN KEY (`proyect_id`) REFERENCES `proyects` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsMembersHistory_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Historial en el cual se guardará los usuarios que entran, salen y hacen cualquier cosa como por ejemplo terminar una tarea';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_members_history`
--

LOCK TABLES `proyects_members_history` WRITE;
/*!40000 ALTER TABLE `proyects_members_history` DISABLE KEYS */;
INSERT INTO `proyects_members_history` VALUES (1,6,'add',7,'2025-03-01 10:16:22');
/*!40000 ALTER TABLE `proyects_members_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks`
--

DROP TABLE IF EXISTS `proyects_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proyect_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `time` int(11) NOT NULL,
  `priority` int(11) DEFAULT 0,
  `tag` varchar(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT 'task',
  `user_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT 1 COMMENT '"todo", "progress", "review", "done"',
  PRIMARY KEY (`id`),
  KEY `fr_proyectsTasks_proyects_idx` (`proyect_id`),
  KEY `fr_proyectsTasks_users_idx` (`user_id`),
  KEY `fr_proyectsTasks_proyectsTasksStatus_idx` (`status`),
  CONSTRAINT `fr_proyectsTasks_proyects` FOREIGN KEY (`proyect_id`) REFERENCES `proyects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasks_proyectsTasksStatus` FOREIGN KEY (`status`) REFERENCES `proyects_tasks_status` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasks_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks`
--

LOCK TABLES `proyects_tasks` WRITE;
/*!40000 ALTER TABLE `proyects_tasks` DISABLE KEYS */;
INSERT INTO `proyects_tasks` VALUES (1,1,'mod descri','2025-02-28 15:28:25',1,5,'modificacion','modificado 1','task',17,1),(2,1,'prueba tarea 2','2025-02-28 16:29:38',5,10,'','tarea 2','task',NULL,NULL),(4,1,'prueba tarea 4','2025-02-28 16:43:17',15,0,'pruebas','prueba4','task',NULL,NULL),(5,1,'prueba tarea 5','2025-02-28 16:45:33',15,0,'pruebas','prueba5','task',NULL,NULL),(6,1,'prueba tarea 5','2025-02-28 16:47:35',15,0,'pruebas','prueba5','task',NULL,NULL),(7,1,'prueba tarea 5','2025-02-28 16:48:01',15,0,'pruebas','prueba5','task',NULL,NULL),(8,1,'prueba tarea 6','2025-02-28 17:07:02',15,0,'pruebas','prueba6','task',NULL,NULL),(9,2,'prueba modificado2','2025-02-28 20:57:26',1,1,'modificado','prueba modificado','task',NULL,1),(10,7,'cambiando al siguiente estado','2025-03-01 10:54:42',1,5,'status','prueba tasks/issue, actualizado task','task',NULL,2),(11,7,'problema 1 desc','2025-03-01 15:39:21',5,3,'problema','primer problema','issue',NULL,1),(12,7,'problema 1 desc','2025-03-01 15:40:51',5,3,'problema','primer problema','issue',17,1),(13,7,'pruebas task/issues, este task','2025-03-01 16:56:58',15,1,'pruebas','pruebas tasks','task',NULL,1),(14,7,'pruebas task/issues, este issue','2025-03-01 17:04:36',150,3,'pruebas','prueba tasks/issue, actualizado issue','issue',17,2),(15,7,'pruebas task/issues, este issue 2','2025-03-01 17:06:19',150,3,'pruebas','pruebas issues 2','issue',17,1);
/*!40000 ALTER TABLE `proyects_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks_comments`
--

DROP TABLE IF EXISTS `proyects_tasks_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fr_proyectsTasksComments_users_idx` (`user_id`),
  KEY `fr_proyectsTasksComments_proyectsTasks_idx` (`task_id`),
  CONSTRAINT `fr_proyectsTasksComments_proyectsTasks` FOREIGN KEY (`task_id`) REFERENCES `proyects_tasks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasksComments_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_comments`
--

LOCK TABLES `proyects_tasks_comments` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_comments` DISABLE KEYS */;
INSERT INTO `proyects_tasks_comments` VALUES (1,10,18,'comentario de prueba','2025-03-01 14:29:39'),(2,10,18,'comentario de prueba 2','2025-03-01 14:29:41'),(3,10,18,'comentario de prueba 3','2025-03-01 14:29:59'),(4,10,17,'prueba inserción comentario tarea 10','2025-03-01 14:56:51'),(5,14,17,'comentario puesto de prueba, para probar que las \'issues\' funcionan','2025-03-01 17:32:22');
/*!40000 ALTER TABLE `proyects_tasks_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks_history`
--

DROP TABLE IF EXISTS `proyects_tasks_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `new_status` int(11) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fr_proyectsTasksHistory_proyectsTasksUsers` (`task_id`),
  KEY `fr_proyectsTasksHistory_proyectsTasks_idx` (`task_id`),
  KEY `fr_proyectsTasksHistory_proyectsTasksStatus_idx` (`new_status`),
  CONSTRAINT `fr_proyectsTasksHistory_proyectsTasks` FOREIGN KEY (`task_id`) REFERENCES `proyects_tasks` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasksHistory_proyectsTasksStatus` FOREIGN KEY (`new_status`) REFERENCES `proyects_tasks_status` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_history`
--

LOCK TABLES `proyects_tasks_history` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_history` DISABLE KEYS */;
INSERT INTO `proyects_tasks_history` VALUES (1,10,1,'2025-03-01 12:56:58'),(2,10,2,'2025-03-01 12:57:16'),(3,11,1,'2025-03-01 15:39:21'),(4,12,1,'2025-03-01 15:40:51'),(5,13,1,'2025-03-01 16:56:58'),(6,14,1,'2025-03-01 17:04:36'),(7,15,1,'2025-03-01 17:06:19'),(8,14,2,'2025-03-01 17:26:22');
/*!40000 ALTER TABLE `proyects_tasks_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks_status`
--

DROP TABLE IF EXISTS `proyects_tasks_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks_status` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_status`
--

LOCK TABLES `proyects_tasks_status` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_status` DISABLE KEYS */;
INSERT INTO `proyects_tasks_status` VALUES (4,'done'),(2,'progress'),(3,'review'),(1,'todo');
/*!40000 ALTER TABLE `proyects_tasks_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks_users`
--

DROP TABLE IF EXISTS `proyects_tasks_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks_users` (
  `user_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL COMMENT 'Estado de la actividad por parte del usuario asignado, ya que pueden haber varios uusarios en la misma actividad y cada uno termina su parte, uno puede terminarlo y el otro puede estar aún por empezar.\\nLos valores permitidos son: "todo", "progress", "done"',
  PRIMARY KEY (`user_id`,`task_id`),
  KEY `fr_proyectsTasksUsers_proyectsTasksUsersStatus_idx` (`status`),
  KEY `fr_proyectsTasksUsers_proyectsTasks_idx` (`task_id`),
  CONSTRAINT `fr_proyectsTasksUsers_proyectsTasks` FOREIGN KEY (`task_id`) REFERENCES `proyects_tasks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasksUsers_proyectsTasksUsersStatus` FOREIGN KEY (`status`) REFERENCES `proyects_tasks_users_status` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasksUsers_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_users`
--

LOCK TABLES `proyects_tasks_users` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_users` DISABLE KEYS */;
INSERT INTO `proyects_tasks_users` VALUES (16,14,1),(18,10,1);
/*!40000 ALTER TABLE `proyects_tasks_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks_users_status`
--

DROP TABLE IF EXISTS `proyects_tasks_users_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks_users_status` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_users_status`
--

LOCK TABLES `proyects_tasks_users_status` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_users_status` DISABLE KEYS */;
INSERT INTO `proyects_tasks_users_status` VALUES (3,'done'),(2,'progress'),(1,'todo');
/*!40000 ALTER TABLE `proyects_tasks_users_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_logs`
--

DROP TABLE IF EXISTS `query_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `query_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `query` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query_logs`
--

LOCK TABLES `query_logs` WRITE;
/*!40000 ALTER TABLE `query_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `query_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `registred` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (6,'prueba1','prueba1@gmail.com','$2y$10$vZLyvP4/rbsZkNmJYUZHbubZiHDcEX52tv85zGm37kWSe2p5LoaTi',NULL,'2025-02-27 16:10:51'),(8,'prueba2','prueba2@gmail.com','1234',NULL,'2025-02-27 16:15:10'),(10,'prueba3','prueba3@gmail.com','$2y$10$vZLyvP4/rbsZkNmJYUZHbubZiHDcEX52tv85zGm37kWSe2p5LoaTi',NULL,'2025-02-27 17:24:09'),(11,'prueba4','prueba4@gmail.com','$2y$10$A54oAaAwUklfqadIkrMBcua1yiN6iIp6NFBVxTvNc13596Lfo0vj6',NULL,'2025-02-27 17:25:01'),(12,'prueba5','prueba5@gmail.com','$2y$10$dWYn8gBlnL/GMYDeoTdrmOSw4RR08w8B/1PjLPX.fznpm7P3qbWEC',NULL,'2025-02-27 17:27:02'),(13,'prueba6','prueba6@gmail.com','$2y$10$SlaXZIHif0sgfKBGzr8Czeuijn3MU9y0.TnGV9B2GQN8RDgB1tQka',NULL,'2025-02-27 17:38:02'),(14,'prueba7','prueba7@gmail.com','$2y$10$bgKeUMvh69njGy0Jxg0TLu4C7YQ06.PHgz/0ktTU99iT9EJtQ9NLi',NULL,'2025-02-27 17:55:01'),(15,'prueba8','prueba8@gmail.com','$2y$10$4IgXXH9m5x10nxx4zlI2EuUevoHV/jxYHBN0rtTE0Oy1TID0XIBZG',NULL,'2025-02-27 17:55:24'),(16,'prueba9','prueba9@gmail.com','$2y$10$/Vwcc62GAPw4jXFnV4RJf.dAdZCgtnY7gWVyPBX0bVz3xibYspNa.',NULL,'2025-02-27 18:12:01'),(17,'prueba10','prueba10@gmail.com','$2y$10$oyczg9w3OSp5vIJ2I7CZO.vCcigXTnNo3zjl2t05xxSZB28VcgOHW',NULL,'2025-02-27 18:15:31'),(18,'pruebaModificado2','pruebaModificado@gmail.com','$2y$10$2pzhMAmoK2BxUzbIwO1mae3vf3p2X7MTbc7S5m.XP2ZxSxfTH3Rbu','/modificado','2025-02-27 19:22:46');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_tokens`
--

DROP TABLE IF EXISTS `users_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fr_usersTokens_users_idx` (`user_id`),
  CONSTRAINT `fr_usersTokens_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_tokens`
--

LOCK TABLES `users_tokens` WRITE;
/*!40000 ALTER TABLE `users_tokens` DISABLE KEYS */;
INSERT INTO `users_tokens` VALUES (1,8,'12341234','2025-02-27 18:07:18'),(2,16,'$2y$10$.m77It4b8WhpB6PxMnj1X.PiGM742sivMfLE7kDvhnppHJ1c1hUR.','0000-00-00 00:00:00'),(3,17,'$2y$10$5.w30epawc2MvXSvCqq/2Oqu8Mc/1Q5NQPr7obkDSQjMlgWE0TG5S','2025-02-28 18:15:31'),(4,17,'$2y$10$h.jbhyyI/QATAsjpllk4L.4NybdzUT7di20ki/64bQZZfRk4Oa5r6','2025-02-28 18:45:47'),(5,17,'$2y$10$rZvngctruU.NfNc2luoz1eXQtcolNeHu0wWiut.tpHYPn.3ZMp6h6','2025-02-28 18:56:10'),(6,17,'$2y$10$PUVDTFgCx55SKpm05o3LnO2tmhGT2AzRtuMCv2LgErgm5523Xe2ZG','2025-02-28 18:56:13'),(7,17,'$2y$10$qtk3QKUQl1/vrEdSjbTVCuA66V./uZ7wgl8p/Bjgh.7fbjq0Nqgk.','2025-02-28 18:56:56'),(8,17,'$2y$10$ymTuQErPbv96ibl7Pt2PZuWPXzux3d.eaZC/waS2CyJj51sf6ZBQS','2025-02-28 18:57:36'),(9,18,'$2y$10$aTbz18w5fUogqVErLREeheIY7ogybjIoYgiQ2hKSyVj39/mBCGjr2','2025-02-28 19:22:46'),(10,18,'$2y$10$Wo3OMfrli6zlznKv8eKkcuL8Eed8cZD6KT.aPhXzmv6cGwBnYd.Ai','2025-02-28 19:27:33'),(11,18,'$2y$10$jnuMkhZrkAdacW4cQNjmBu0byc.UKVJhDVODi52HHgkp38rvriDzK','2025-02-28 19:27:48'),(12,18,'$2y$10$ZW3Q9wjJ3j1pjFjaRaBkn.uk5bUFNQTgyX1JKJ4mexiLyKPlFyUDi','2025-02-28 19:29:01'),(13,18,'$2y$10$aT2tCoYObS38VzYWOPJdSe1NqCxGK5tHnFUBlzue9V0zSfSCCGpf.','2025-02-28 19:30:45'),(14,18,'$2y$10$ow5J9FYpFn8s9NC3rNVbDehJgDOpeLSKhw/RzrcaBkLowzyk21O6y','2025-02-28 19:32:49'),(15,18,'$2y$10$TEukJ89DEHBhKklbL8L4uek7tPJtWrKvt95wIUbkHue2z7tEfKN1O','2025-02-28 19:32:51'),(16,18,'$2y$10$m9bnMpQj7FtrY8W64sGqUuHCO0br//nhWy87FXPrnqHe2WJxKDrue','2025-02-28 19:33:00'),(17,18,'$2y$10$ZVG57gZO1vlOjLUY1GChPula76250tGDPMEaAklfUFtveCpzFoOlO','2025-02-28 19:33:32'),(18,18,'$2y$10$Pq.WL8FWiGMai4EFvABhtegbhJyGLl.U7DLPMrc0YQdqbn4KgiX7S','2025-02-28 19:33:54'),(19,18,'$2y$10$YhlHLaKU8JvbBZr3PNJ/EOsSb.7nyVah0kga4eWZihqHHbPz9ss36','2025-02-28 19:33:58'),(20,18,'$2y$10$5o8p4qllO5pyEZ2wNGBFouM1rx/pcu44Q6/gU3TdB4U/i04e7BYPa','2025-02-28 19:34:06'),(21,18,'$2y$10$SRcRRxIcNVk/c.e.RuOiKOGCSrYMti1/1Q8eolCMTVnLDVqyHRVhG','2025-02-28 20:30:46'),(22,18,'$2y$10$OZmL9uAWlX7rkSRFBUeqIemNlRW1lLk9d/azMV7RowNiTXZAfnCGu','2025-02-27 20:37:00'),(23,18,'$2y$10$DlyJ7NzdYgkCDPNzuj9FPul2wtKSOoWCzVREPswlzvxPB/mWnW6pK','2025-02-28 20:43:20'),(24,18,'$2y$10$.7AEOrulJ.6AJKDaUlb9bOzC4yYP/VHUD6xln9bbc37WwdA5uchlC','2025-02-28 20:52:44'),(25,10,'$2y$10$6WfxTQ.CwRMIIGfoCjWlze64VWGqEgrtyWs4zq93PbOdlecEbtSsO','2025-03-01 09:15:15'),(26,10,'$2y$10$AJvmAzvqFRXRNgzRd6KTWeUDKNYrOwfKr4SJ03tI6DsoOR7QUapLW','2025-03-01 09:15:21'),(27,10,'$2y$10$a9sZ0LfUDMbsOur7h9K1x.3YZHKToZpAGrn/GVqz1TB.TTUkez2iG','2025-03-01 10:42:13'),(28,10,'$2y$10$AGgJAo0YtxQw2QD/aDR2iuTlahYu7njzKNUjaM.ZnfBOGqJypjQ3C','2025-03-01 10:46:35'),(29,18,'$2y$10$.V4ED4z0GOUzJOkZTWijHeN1kXd389qReMi8Z23bBlcjQCvHrOb7y','2025-03-01 10:46:53'),(30,17,'$2y$10$Bwo7TlqLPqZlwGdZ7X6BGeSB/ekxKNFTNS9lTCd03b5YU2mhfaKCq','2025-03-01 11:06:30'),(31,18,'$2y$10$lrUJ2E1IELc8xUat2GlxEecr8uy5iOLpXzpCCcGh3L9G77PY7JIpm','2025-03-01 11:12:44'),(32,17,'$2y$10$UoT88.2kAdR4zlkJaMLB/u2u4Ss4FD6aX7wwTb79ywirx87TR1bLq','2025-03-01 12:01:52'),(33,17,'$2y$10$zQ4XBXlO7SbPA/wRtWhaNemfbkhW.oh9WKfypOCK2HyzrpI7OGCja','2025-03-01 14:39:27'),(34,6,'$2y$10$XEJDjL6pKNzr2T4OjZWI4emXQ57pQKUnptBqYZZYxofYegOoFOygO','2025-03-01 20:19:22'),(35,18,'$2y$10$WZvOLK6g6nnluqOv44dTwu/s6ukqjS6xfHMOmL/.TjAlteQYUt1ti','2025-03-01 21:44:23'),(36,18,'$2y$10$xJr.C7s/Ikl5/C5CQT9Veu9CTnwYI1QzMsBG006KiPvQCNzfj6Ep6','2025-03-01 23:15:39'),(37,17,'$2y$10$wCjd9FLQ/f9Cio67d8fLQOSnUKTjx28JIZp5Lhzgo96609vykLN3a','2025-03-01 23:26:22'),(38,17,'$2y$10$s1JmdPUfBc8GTbDEmLdBSOoHRDRcf27I.2cgB8XLnm93dz6J2cvfm','2025-03-02 00:04:19');
/*!40000 ALTER TABLE `users_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pulse'
--

--
-- Dumping routines for database 'pulse'
--
/*!50003 DROP PROCEDURE IF EXISTS `proyects_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_insert`(IN titleVar VARCHAR(255), IN ownerIdVar INT)
BEGIN

	DECLARE proyectId INT DEFAULT -1;

	INSERT INTO proyects (title, owner_id) VALUES (titleVar, ownerIdVar);

	SET proyectId = last_insert_id();
    
    SELECT * FROM proyects WHERE id = proyectId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_history`(IN proyectId INT, IN userId INT, IN actionVar VARCHAR(255))
BEGIN

	DECLARE historyId INT DEFAULT 0;

	INSERT INTO proyects_members_history (proyect_id, user_id, action) VALUES (proyectId, userId, actionVar);

	SET historyId = last_insert_id();
    
    SELECT * FROM proyects_members_history WHERE id = historyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_history_of_proyect_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_history_of_proyect_id`(IN proyectId INT)
BEGIN

	SELECT users.*, history.* FROM users INNER JOIN proyects_members_history AS history ON 
    users.id = history.user_id 
    AND history.proyect_id = proyectId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_insert`(IN proyectId INT, IN userId INT, IN effective_timeVar INT)
BEGIN

	INSERT INTO proyects_members (proyect_id, user_id, effective_time) VALUES (proyectId, userId, effective_timeVar);
    
    CALL proyects_members_history(proyectId, userId, "add");

	SELECT * FROM proyects_members WHERE user_id=userId AND proyect_id=proyectId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_of_member_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_of_member_id`(IN user_idVar INT)
BEGIN

	SELECT * FROM proyects WHERE id IN (
		SELECT proyect_id FROM proyects_members WHERE user_id = user_idVar
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_comments_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_comments_insert`(IN taskId INT, IN userId INT, IN commentVar VARCHAR(255))
BEGIN

	DECLARE commentId INT DEFAULT 0;

	INSERT INTO proyects_tasks_comments (task_id, user_id, comment) VALUES (taskId, userId, commentVar);

	SET commentId = last_insert_id();
    
    SELECT * FROM proyects_tasks_comments WHERE id = commentId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_delete`(IN taskId INT)
BEGIN

	DELETE FROM proyects_tasks_users WHERE task_id=taskId;
    DELETE FROM proyects_tasks_comments WHERE task_id=taskId;
    DELETE FROM proyects_tasks_history WHERE task_id=taskId;
    DELETE FROM proyects_tasks WHERE id=taskId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_history_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_history_insert`(IN taskId INT, IN new_statusVar INT)
BEGIN

	INSERT INTO proyects_tasks_history (task_id, new_status) VALUES (taskId, new_statusvar);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_history_of_proyect_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_history_of_proyect_id`(IN proyectId INT)
BEGIN

	SELECT proyects_tasks_history.*,
    tasks.title AS task_title,
    tasks.description AS task_description, 
    tasks.date AS task_date,
    tasks.time AS task_time,
    tasks.tag AS task_tag,
    tasks.priority AS task_priority,
    tasks.type AS task_type ,
    tasks.status AS task_status,
    tasks.user_id AS task_user_id,
    tasks.proyect_id AS task_proyect_id
    FROM proyects_tasks_history INNER JOIN proyects_tasks as tasks ON 
    tasks.proyect_id = proyectId
    AND tasks.id = proyects_tasks_history.task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_history_select` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_history_select`()
BEGIN

	SELECT proyects_tasks_history.*,
    tasks.title AS tasks_title,
    tasks.description AS task_description, 
    tasks.date AS task_date,
    tasks.time AS task_time,
    tasks.tag AS task_tag,
    tasks.priority AS task_priority,
    tasks.type AS task_type ,
    tasks.status AS task_status,
    tasks.user_id AS task_user_id,
    tasks.proyect_id AS task_proyect_id
    FROM proyects_tasks_history INNER JOIN proyects_tasks as tasks ON 
    tasks.id = proyects_tasks_history.task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_insert`(IN titleVar VARCHAR(255), IN descriptionVar VARCHAR(255), IN tagVar VARCHAR(255), IN timeVar INT, IN priorityVar INT, IN proyectId INT)
BEGIN

	DECLARE taskId INT DEFAULT 0;

	INSERT INTO proyects_tasks (title, description, tag, time, priority, proyect_id) VALUES (titleVar, descriptionVar, tagVar, TimeVar, priorityVar, proyectId);
    
    SET taskId = last_insert_id();
    
    CALL proyects_tasks_history_insert(taskId, 1);
    
    SELECT * FROM proyects_tasks WHERE id = taskId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_insert_issue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_insert_issue`(IN titleVar VARCHAR(255), IN descriptionVar VARCHAR(255), IN tagVar VARCHAR(255), IN timeVar INT, IN priorityVar INT, IN proyectId INT, IN userId INT)
BEGIN

	DECLARE taskId INT DEFAULT 0;

	INSERT INTO proyects_tasks (title, description, tag, time, priority, proyect_id, type, user_id) VALUES (titleVar, descriptionVar, tagVar, TimeVar, priorityVar, proyectId, "issue", userId);
    
    SET taskId = last_insert_id();
    
    CALL proyects_tasks_history_insert(taskId, 1);
    
    SELECT * FROM proyects_tasks WHERE id = taskId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_of_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_of_user_id`(IN userId INT)
BEGIN

	SELECT proyects_tasks.id,
    proyects_tasks.title,
    proyects_tasks.description,
    proyects_tasks.date,
    proyects_tasks.time,
	proyects_tasks.priority,
	proyects_tasks.tag,
    proyects_tasks.type,
    proyects_tasks.proyect_id, 
    proyects_tasks.status,
    proyects_tasks_users.status as user_status 
    FROM proyects_tasks INNER JOIN proyects_tasks_users ON proyects_tasks_users.user_id=userId AND proyects_tasks.id=proyects_tasks_users.task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_update`(IN taskId INT, IN titleVar VARCHAR(255), IN descriptionVar VARCHAR(255), IN tagVar VARCHAR(255), IN timeVar INT, IN priorityVar INT, IN statusVar INT)
BEGIN

	DECLARE prevStatus INT;
    
    SELECT status INTO prevStatus FROM proyects_tasks WHERE id = taskId;

	UPDATE proyects_tasks SET title=titleVar, description=descriptionVar, tag=tagVar, time=timeVar, priority=priorityVar, status=statusVar WHERE id=taskId;
    
    IF (prevStatus != statusVar) THEN
		CALL proyects_tasks_history_insert(taskId, statusVar);
	END IF;
    
    SELECT * FROM proyects_tasks WHERE id = taskId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_users_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_users_insert`(IN userId INT, IN taskId INT, IN statusVar INT)
BEGIN
	
	INSERT INTO proyects_tasks_users (user_id, task_id, status) VALUES (userId, taskId, statusVar);
    
    SELECT * FROM proyects_tasks_users WHERE user_id=userId AND task_id=taskId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_user_status_of_proyects_tasks_id_users_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_user_status_of_proyects_tasks_id_users_id`(IN taskId INT, IN userId INT)
BEGIN

	SELECT proyects_tasks_users_status.* FROM proyects_tasks_users_status INNER JOIN proyects_tasks_users ON 
    proyects_tasks_users_status.id = proyects_tasks_users.status 
    AND proyects_tasks_users.user_id=userId 
    AND proyects_tasks_users.task_id=taskId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_update`(IN proyectId INT, IN titleVar VARCHAR(255), IN owner_idVar INT)
BEGIN

	UPDATE proyects SET title=titleVar, owner_id=owner_idVar WHERE id = proyectId;
    
    SELECT * FROM proyects WHERE id = proyectId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_insert`(IN usernameVar VARCHAR(255), IN emailVar VARCHAR(255), IN passwordVar VARCHAR(255), IN photoVar VARCHAR(255))
BEGIN
	DECLARE userId INT DEFAULT -1;

	INSERT INTO users (username, email, password, photo) VALUES (usernameVar, emailVar, passwordVar, photoVar);
    
    SET userId = LAST_INSERT_ID();
    
    SELECT * FROM users WHERE id = userId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_of_proyects_tasks_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_of_proyects_tasks_id`(IN taskId INT)
BEGIN
    
    SELECT users.*, proyects_tasks_users.* FROM users INNER JOIN proyects_tasks_users ON proyects_tasks_users.task_id=taskId AND users.id=proyects_tasks_users.user_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_of_proyect_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_of_proyect_id`(IN proyectId INT)
BEGIN
    
    SELECT proyects_members.*, users.* FROM proyects_members INNER JOIN users ON proyects_members.proyect_id = proyectId AND users.id = proyects_members.user_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_of_proyect_id_user_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_of_proyect_id_user_email`(IN userEmail VARCHAR(255), IN proyectId INT)
BEGIN

	SELECT proyects_members.*, users.* FROM proyects_members INNER JOIN users ON proyects_members.proyect_id = proyectId AND users.id = proyects_members.user_id AND users.email=userEmail;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_of_proyect_id_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_of_proyect_id_user_id`(IN userId INT, IN proyectId INT)
BEGIN

	SELECT proyects_members.*, users.* FROM proyects_members INNER JOIN users ON proyects_members.proyect_id = proyectId AND proyects_members.user_id=userId AND users.id = proyects_members.user_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_tokens_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_tokens_insert`(IN user_idVar INT, IN tokenVar VARCHAR(255), IN expire_dateVar VARCHAR(255))
BEGIN
	DECLARE tokenId INT DEFAULT -1;
        
	INSERT INTO users_tokens (user_id, token, expire_date) VALUES (user_idVar, tokenVar, expire_dateVar);
    
    SET tokenId = LAST_INSERT_ID();
    
    SELECT * FROM users_tokens WHERE id = tokenId;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_update`(IN userId INT, IN usernameVar VARCHAR(255), IN emailVar VARCHAR(255), IN passwordVar VARCHAR(255), IN photoVar VARCHAR(255))
BEGIN

	UPDATE users SET username=usernameVar, email=emailVar, password=passwordVar, photo=photoVar WHERE id = userId;
    
    SELECT * FROM users WHERE id = userId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_of_token_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_of_token_id`(IN tokenId INT)
BEGIN

	SELECT * FROM users WHERE id = (
		SELECT user_id FROM users_tokens WHERE id = tokenId
    );

END ;;
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

-- Dump completed on 2025-03-01 18:17:05
