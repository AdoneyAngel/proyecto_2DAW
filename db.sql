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
INSERT INTO `proyects` VALUES (1,17,'Fin de curso','2025-02-27 21:37:56'),(2,17,'prueba','2025-02-27 21:37:59'),(3,18,'prueba2','2025-02-27 22:16:20'),(4,18,'prueba3','2025-02-27 22:17:38'),(5,18,'prueba4','2025-02-28 09:03:10'),(6,17,'proyecto modificado 3 - 2','2025-02-28 09:04:11'),(7,6,'Proyecto de prueba 1','2025-02-28 17:03:13');
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
INSERT INTO `proyects_members` VALUES (1,8,1,1505),(1,10,1,5),(1,12,0,1),(1,15,1,5),(1,16,1,5),(2,16,0,1),(2,17,1,1),(3,17,1,1),(7,6,0,5);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Historial en el cual se guardará los usuarios que entran, salen y hacen cualquier cosa como por ejemplo terminar una tarea';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_members_history`
--

LOCK TABLES `proyects_members_history` WRITE;
/*!40000 ALTER TABLE `proyects_members_history` DISABLE KEYS */;
INSERT INTO `proyects_members_history` VALUES (1,6,'add',7,'2025-03-01 10:16:22'),(2,17,'add',1,'2025-03-03 15:26:47'),(3,10,'add',1,'2025-03-10 21:39:55'),(4,11,'add',1,'2025-03-12 22:15:33'),(5,12,'add',1,'2025-03-12 22:21:21'),(6,6,'add',1,'2025-03-15 12:16:38'),(7,6,'add',1,'2025-03-15 12:24:41');
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks`
--

LOCK TABLES `proyects_tasks` WRITE;
/*!40000 ALTER TABLE `proyects_tasks` DISABLE KEYS */;
INSERT INTO `proyects_tasks` VALUES (1,1,'descripcion modificada desde cliente','2025-02-28 15:28:25',12,1,'modificacion2','modificado 3','task',17,2),(4,1,'prueba tarea 4 modificado','2025-02-28 16:43:17',15,1,'pruebas','prueba4','task',NULL,1),(5,1,'prueba tarea 5','2025-02-28 16:45:33',15,0,'pruebas','prueba5','task',NULL,1),(6,1,'prueba tarea 5','2025-02-28 16:47:35',15,0,'pruebas','prueba5','task',NULL,1),(7,1,'prueba tarea 5','2025-02-28 16:48:01',15,0,'pruebas','prueba5','task',NULL,1),(8,1,'prueba tarea 6','2025-02-28 17:07:02',15,0,'pruebas','prueba6','task',NULL,1),(9,2,'prueba modificado2','2025-02-28 20:57:26',1,1,'modificado','prueba modificado','task',NULL,2),(10,7,'cambiando al siguiente estado','2025-03-01 10:54:42',1,5,'status','prueba tasks/issue, actualizado task 3','task',NULL,2),(11,1,'problema 1 desc','2025-03-01 15:39:21',5,3,'problema','primer problema','issue',16,1),(12,7,'tarea extra','2025-03-01 15:40:51',5,3,'nose','una tarea mas para hacer','task',17,1),(13,7,'pruebas task/issues, este task','2025-03-01 16:56:58',15,1,'pruebas','pruebas tasks','task',NULL,1),(14,1,'pruebas task/issues, este issue','2025-03-01 17:04:36',150,3,'pruebas','prueba tasks/issue, actualizado issue','issue',17,2),(18,1,'Probando insertar una tarea con usuarios a la vez','2025-03-06 17:41:54',5,10,'pruebas','tarea prueba con usuario modificado','task',NULL,3),(19,1,'prueba de insertar desde el cliente','2025-03-07 12:38:50',6,5,'pruebas','prueba insertar cliente','task',NULL,1),(21,7,'Una tarea extra para realizar permanentemente','2025-03-07 20:07:47',15,3,'nose','Tarea de proyecto de prueba 1','task',NULL,1),(26,1,'2121','2025-04-04 18:38:15',3,3,'pruebas','1111111111','issue',17,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_history`
--

LOCK TABLES `proyects_tasks_history` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_history` DISABLE KEYS */;
INSERT INTO `proyects_tasks_history` VALUES (1,10,1,'2025-03-01 12:56:58'),(2,10,2,'2025-03-01 12:57:16'),(3,11,1,'2025-03-01 15:39:21'),(4,12,1,'2025-03-01 15:40:51'),(5,13,1,'2025-03-01 16:56:58'),(6,14,1,'2025-03-01 17:04:36'),(8,14,2,'2025-03-01 17:26:22'),(11,18,1,'2025-03-06 17:41:54'),(12,19,1,'2025-03-07 12:38:50'),(13,NULL,1,'2025-03-07 13:53:49'),(14,21,1,'2025-03-07 20:07:47'),(16,18,2,'2025-03-15 10:27:07'),(17,18,3,'2025-03-15 10:39:36'),(18,18,2,'2025-03-15 10:40:01'),(19,18,1,'2025-03-15 10:40:11'),(20,18,2,'2025-03-15 10:40:23'),(21,18,3,'2025-03-15 10:43:14'),(22,18,2,'2025-03-15 11:00:38'),(23,18,3,'2025-03-15 11:02:14'),(24,18,2,'2025-03-15 11:02:21'),(25,18,3,'2025-03-15 11:02:33'),(26,18,2,'2025-03-15 11:06:02'),(27,18,3,'2025-03-15 11:06:49'),(28,18,2,'2025-03-15 11:08:01'),(29,18,3,'2025-03-15 11:08:04'),(30,18,2,'2025-03-15 11:08:13'),(31,18,3,'2025-03-15 11:08:22'),(32,1,1,'2025-03-16 16:05:29'),(33,1,2,'2025-03-16 16:05:41'),(34,9,2,'2025-04-03 19:54:58'),(35,9,1,'2025-04-03 19:55:39'),(36,9,2,'2025-04-03 19:56:30'),(37,9,1,'2025-04-03 20:42:08'),(38,9,3,'2025-04-03 20:42:11'),(39,9,2,'2025-04-03 20:42:14'),(43,26,1,'2025-04-04 18:38:15'),(44,9,3,'2025-04-04 19:17:48'),(45,9,2,'2025-04-04 19:18:00'),(46,9,3,'2025-04-04 19:18:06'),(47,9,2,'2025-04-04 19:18:15');
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
INSERT INTO `proyects_tasks_users` VALUES (6,21,1),(8,14,1),(8,26,1),(10,19,1),(15,1,1),(15,11,1),(15,26,1),(16,9,1),(16,11,1),(16,19,1),(18,10,1),(8,19,2),(10,1,2),(15,14,2),(17,9,2),(8,18,3),(15,18,3);
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
  `googleId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `googleEmail_UNIQUE` (`googleId`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (6,'prueba1','prueba1@gmail.com','$2y$10$vZLyvP4/rbsZkNmJYUZHbubZiHDcEX52tv85zGm37kWSe2p5LoaTi',NULL,'2025-02-27 16:10:51',NULL),(8,'prueba2','prueba2@gmail.com','$2y$10$vZLyvP4/rbsZkNmJYUZHbubZiHDcEX52tv85zGm37kWSe2p5LoaTi',NULL,'2025-02-27 16:15:10',NULL),(10,'prueba3','prueba3@gmail.com','$2y$10$vZLyvP4/rbsZkNmJYUZHbubZiHDcEX52tv85zGm37kWSe2p5LoaTi',NULL,'2025-02-27 17:24:09',NULL),(11,'prueba4','prueba4@gmail.com','$2y$10$A54oAaAwUklfqadIkrMBcua1yiN6iIp6NFBVxTvNc13596Lfo0vj6',NULL,'2025-02-27 17:25:01',NULL),(12,'prueba5','prueba5@gmail.com','$2y$10$dWYn8gBlnL/GMYDeoTdrmOSw4RR08w8B/1PjLPX.fznpm7P3qbWEC',NULL,'2025-02-27 17:27:02',NULL),(13,'prueba6','prueba6@gmail.com','$2y$10$SlaXZIHif0sgfKBGzr8Czeuijn3MU9y0.TnGV9B2GQN8RDgB1tQka',NULL,'2025-02-27 17:38:02',NULL),(14,'prueba7','prueba7@gmail.com','$2y$10$bgKeUMvh69njGy0Jxg0TLu4C7YQ06.PHgz/0ktTU99iT9EJtQ9NLi',NULL,'2025-02-27 17:55:01',NULL),(15,'prueba8','prueba8@gmail.com','$2y$10$4IgXXH9m5x10nxx4zlI2EuUevoHV/jxYHBN0rtTE0Oy1TID0XIBZG',NULL,'2025-02-27 17:55:24',NULL),(16,'prueba9','prueba9@gmail.com','$2y$10$/Vwcc62GAPw4jXFnV4RJf.dAdZCgtnY7gWVyPBX0bVz3xibYspNa.','16/photo.jpeg','2025-02-27 18:12:01',NULL),(17,'prueba10','prueba10@gmail.com','$2y$10$oyczg9w3OSp5vIJ2I7CZO.vCcigXTnNo3zjl2t05xxSZB28VcgOHW','17/photo.jpg','2025-02-27 18:15:31','111649442526121703710'),(18,'pruebaModificado2','pruebaModificado@gmail.com','$2y$10$2pzhMAmoK2BxUzbIwO1mae3vf3p2X7MTbc7S5m.XP2ZxSxfTH3Rbu','/modificado','2025-02-27 19:22:46',NULL),(19,'fasdfasfasfdas','asf@afd.com','$2y$10$rrappQ2bT9GIUYpKn9NTj./XYNV.WwEsT96Dkek/vucVaWStE7ddO',NULL,'2025-03-03 01:21:15',NULL),(20,'Adoney','fasfdsa@as.copm','$2y$10$x1RtwFpjLDaju/9XFluwYeB1S5x0UzMxhAR31weHoQ6CV8xYKRTpy',NULL,'2025-03-03 01:22:40',NULL),(21,'prueba Crear Usuario','pruebaCrearUsuario@gmail.com','$2y$10$po/o8RXWTnQsDGq9JB4CF.RVJVN7q2qTw8rYdsMA.3dvlWjYYdpAK',NULL,'2025-03-07 18:41:58',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_tokens`
--

LOCK TABLES `users_tokens` WRITE;
/*!40000 ALTER TABLE `users_tokens` DISABLE KEYS */;
INSERT INTO `users_tokens` VALUES (1,8,'12341234','2025-02-27 18:07:18'),(2,16,'$2y$10$.m77It4b8WhpB6PxMnj1X.PiGM742sivMfLE7kDvhnppHJ1c1hUR.','0000-00-00 00:00:00'),(3,17,'$2y$10$5.w30epawc2MvXSvCqq/2Oqu8Mc/1Q5NQPr7obkDSQjMlgWE0TG5S','2025-02-28 18:15:31'),(4,17,'$2y$10$h.jbhyyI/QATAsjpllk4L.4NybdzUT7di20ki/64bQZZfRk4Oa5r6','2025-02-28 18:45:47'),(5,17,'$2y$10$rZvngctruU.NfNc2luoz1eXQtcolNeHu0wWiut.tpHYPn.3ZMp6h6','2025-02-28 18:56:10'),(6,17,'$2y$10$PUVDTFgCx55SKpm05o3LnO2tmhGT2AzRtuMCv2LgErgm5523Xe2ZG','2025-02-28 18:56:13'),(7,17,'$2y$10$qtk3QKUQl1/vrEdSjbTVCuA66V./uZ7wgl8p/Bjgh.7fbjq0Nqgk.','2025-02-28 18:56:56'),(8,17,'$2y$10$ymTuQErPbv96ibl7Pt2PZuWPXzux3d.eaZC/waS2CyJj51sf6ZBQS','2025-02-28 18:57:36'),(9,18,'$2y$10$aTbz18w5fUogqVErLREeheIY7ogybjIoYgiQ2hKSyVj39/mBCGjr2','2025-02-28 19:22:46'),(10,18,'$2y$10$Wo3OMfrli6zlznKv8eKkcuL8Eed8cZD6KT.aPhXzmv6cGwBnYd.Ai','2025-02-28 19:27:33'),(11,18,'$2y$10$jnuMkhZrkAdacW4cQNjmBu0byc.UKVJhDVODi52HHgkp38rvriDzK','2025-02-28 19:27:48'),(12,18,'$2y$10$ZW3Q9wjJ3j1pjFjaRaBkn.uk5bUFNQTgyX1JKJ4mexiLyKPlFyUDi','2025-02-28 19:29:01'),(13,18,'$2y$10$aT2tCoYObS38VzYWOPJdSe1NqCxGK5tHnFUBlzue9V0zSfSCCGpf.','2025-02-28 19:30:45'),(14,18,'$2y$10$ow5J9FYpFn8s9NC3rNVbDehJgDOpeLSKhw/RzrcaBkLowzyk21O6y','2025-02-28 19:32:49'),(15,18,'$2y$10$TEukJ89DEHBhKklbL8L4uek7tPJtWrKvt95wIUbkHue2z7tEfKN1O','2025-02-28 19:32:51'),(16,18,'$2y$10$m9bnMpQj7FtrY8W64sGqUuHCO0br//nhWy87FXPrnqHe2WJxKDrue','2025-02-28 19:33:00'),(17,18,'$2y$10$ZVG57gZO1vlOjLUY1GChPula76250tGDPMEaAklfUFtveCpzFoOlO','2025-02-28 19:33:32'),(18,18,'$2y$10$Pq.WL8FWiGMai4EFvABhtegbhJyGLl.U7DLPMrc0YQdqbn4KgiX7S','2025-02-28 19:33:54'),(19,18,'$2y$10$YhlHLaKU8JvbBZr3PNJ/EOsSb.7nyVah0kga4eWZihqHHbPz9ss36','2025-02-28 19:33:58'),(20,18,'$2y$10$5o8p4qllO5pyEZ2wNGBFouM1rx/pcu44Q6/gU3TdB4U/i04e7BYPa','2025-02-28 19:34:06'),(21,18,'$2y$10$SRcRRxIcNVk/c.e.RuOiKOGCSrYMti1/1Q8eolCMTVnLDVqyHRVhG','2025-02-28 20:30:46'),(22,18,'$2y$10$OZmL9uAWlX7rkSRFBUeqIemNlRW1lLk9d/azMV7RowNiTXZAfnCGu','2025-02-27 20:37:00'),(23,18,'$2y$10$DlyJ7NzdYgkCDPNzuj9FPul2wtKSOoWCzVREPswlzvxPB/mWnW6pK','2025-02-28 20:43:20'),(24,18,'$2y$10$.7AEOrulJ.6AJKDaUlb9bOzC4yYP/VHUD6xln9bbc37WwdA5uchlC','2025-02-28 20:52:44'),(25,10,'$2y$10$6WfxTQ.CwRMIIGfoCjWlze64VWGqEgrtyWs4zq93PbOdlecEbtSsO','2025-03-01 09:15:15'),(26,10,'$2y$10$AJvmAzvqFRXRNgzRd6KTWeUDKNYrOwfKr4SJ03tI6DsoOR7QUapLW','2025-03-01 09:15:21'),(27,10,'$2y$10$a9sZ0LfUDMbsOur7h9K1x.3YZHKToZpAGrn/GVqz1TB.TTUkez2iG','2025-03-01 10:42:13'),(28,10,'$2y$10$AGgJAo0YtxQw2QD/aDR2iuTlahYu7njzKNUjaM.ZnfBOGqJypjQ3C','2025-03-01 10:46:35'),(29,18,'$2y$10$.V4ED4z0GOUzJOkZTWijHeN1kXd389qReMi8Z23bBlcjQCvHrOb7y','2025-03-01 10:46:53'),(30,17,'$2y$10$Bwo7TlqLPqZlwGdZ7X6BGeSB/ekxKNFTNS9lTCd03b5YU2mhfaKCq','2025-03-01 11:06:30'),(31,18,'$2y$10$lrUJ2E1IELc8xUat2GlxEecr8uy5iOLpXzpCCcGh3L9G77PY7JIpm','2025-03-01 11:12:44'),(32,17,'$2y$10$UoT88.2kAdR4zlkJaMLB/u2u4Ss4FD6aX7wwTb79ywirx87TR1bLq','2025-03-01 12:01:52'),(33,17,'$2y$10$zQ4XBXlO7SbPA/wRtWhaNemfbkhW.oh9WKfypOCK2HyzrpI7OGCja','2025-03-01 14:39:27'),(34,6,'$2y$10$XEJDjL6pKNzr2T4OjZWI4emXQ57pQKUnptBqYZZYxofYegOoFOygO','2025-03-01 20:19:22'),(35,18,'$2y$10$WZvOLK6g6nnluqOv44dTwu/s6ukqjS6xfHMOmL/.TjAlteQYUt1ti','2025-03-01 21:44:23'),(36,18,'$2y$10$xJr.C7s/Ikl5/C5CQT9Veu9CTnwYI1QzMsBG006KiPvQCNzfj6Ep6','2025-03-01 23:15:39'),(37,17,'$2y$10$wCjd9FLQ/f9Cio67d8fLQOSnUKTjx28JIZp5Lhzgo96609vykLN3a','2025-03-01 23:26:22'),(38,17,'$2y$10$s1JmdPUfBc8GTbDEmLdBSOoHRDRcf27I.2cgB8XLnm93dz6J2cvfm','2025-03-02 00:04:19'),(39,17,'$2y$10$B7Mti5OqBqge/X.6AAC8RetbqsPDd8BbwpUnr8uUGwtuTXm9aiQeu','2025-03-02 19:04:19'),(40,17,'$2y$10$tyUz7rLhfo8jtcVjRF/eL.R8MOTQ1ZdfEhp3.6ojMYqCVbsqAySeG','2025-03-02 19:06:24'),(41,17,'$2y$10$LlWNoAk0BHSM3RVpiTa2OeHqPyNYbMM7o0ubh7YcN5vD1cbedX2O6','2025-03-02 19:08:03'),(42,17,'$2y$10$l66bubZvmurvLCM7bexNp.CqxtMhgz0wbKTXT1oOs84EXgMDY.Jxy','2025-03-02 19:10:03'),(43,17,'$2y$10$lDrTN4VN1Irz/Tvz4D6MNO6zZIgcLNxRBz7z7YHdyiJT8EnimziNO','2025-03-02 19:10:17'),(44,17,'$2y$10$/dON2FrdMKF.6Pd4dZY9WuRimWXSXjOgjb2H3Miy9yD8oxfv7vAdC','2025-03-02 19:12:12'),(45,17,'$2y$10$kdICx30xz7XYJdyewr02aeewViC4M1e1hQX7K9r.tX9FjwbLeardS','2025-03-02 19:12:56'),(46,17,'$2y$10$7JzlPM0XDzJw2Wu08mnv9uoQXDIkdTfiDhO4uAYP00vscIfcb68MK','2025-03-02 19:15:31'),(47,17,'$2y$10$qMPmfFcTxhLMPYPil1cLqOyfA4H7NQhpKfp8PzYIc2Xa2BbVRGj42','2025-03-02 19:16:17'),(48,17,'$2y$10$AmkHvf0llbWX0Y0JLmLmMujAHrFP25dy3lOk5kCC2DwrpUzTMuG1S','2025-03-02 19:17:55'),(49,17,'$2y$10$YQWTHEO0hmb7AvRr8RgHIurtGs/uCofmBs5YYKobUmKHbwd1/QXt.','2025-03-02 19:18:30'),(50,17,'$2y$10$85bWUc6q22fdBvC6rBgelu6nSbW8DfV2R0SnuKgGz64pJFH.kB6F2','2025-03-02 19:20:09'),(51,17,'$2y$10$V8dydDUhOCj2xk54Oywbk.BK0GXTmqiSx61cfzODIxOIL9LarI5j2','2025-03-02 20:07:26'),(52,17,'$2y$10$sl7qNKOLpeHghZseSz5QJ.TUNO3UXv91H6P9FMwqNGn.EqK/5Vn.a','2025-03-02 20:30:28'),(53,17,'$2y$10$0HlPRnqGp95XvqOJeVQKMOkGe5f/e7CdNGpLgSEX3OBz2L/pI97m2','2025-03-02 20:30:47'),(54,17,'$2y$10$cX.naT7rNclJBauxWTlAmetVEX7FNwnLPIkvT/gmPcKVkjMuQ.cwC','2025-03-02 20:31:33'),(55,17,'$2y$10$HzRBGqdP8GU3htCcx0eWiuxcaCLEI5Y206wU0aBbFikW8.B0m2AFu','2025-03-02 20:32:32'),(56,17,'$2y$10$kN4F7zXU9Hi0N.m6UBsU.e0KwUSLTeMMiX2Zo6MVCr9DGyfK7ABN.','2025-03-02 20:33:26'),(57,17,'$2y$10$2WYkRHApJaVcdQdxCzrgPOVXRLS27w/xWrm.LQKKbBCWfjt5Cvegu','2025-03-02 20:34:10'),(58,17,'$2y$10$2XGBBCQg9nSSGS.s4UxuoOaS2ZoM8myIqcS1.58HAsyATlGWXJGJa','2025-03-02 20:35:31'),(59,17,'$2y$10$VNX1a57RTi7c4C7bDZ0p6ecBfOCrOBvpKcd9PhZPEMwBhaUL2vTL2','2025-03-02 20:37:04'),(60,17,'$2y$10$CO/ghJSOgRK4BujEmRXizeWBIfiNRrBfLlfTeY.CUej90KRdL/oXu','2025-03-02 20:38:40'),(61,17,'$2y$10$srvCRleu3KGibP55wqMniO3lAlk2tvJNYZ5aN/nZGTUZwzpBuBs7y','2025-03-02 20:39:16'),(62,17,'$2y$10$aWIOIT8hdZkPhQqEvL166ezx8cMZ6dAgr34rxBuv1Cz8VQ08F9Rau','2025-03-02 20:39:38'),(63,17,'$2y$10$RF1So8TBsJ88YHLRCYyIY.qDXZvLjl6b3gmn/GXNfUL3GdXvHT/KO','2025-03-02 20:40:07'),(64,17,'$2y$10$jy/H3nrrEtV/HrTFRMyELevxPG9msMhWt13CPB97MRn4yfM0IpoKy','2025-03-02 20:41:45'),(65,17,'$2y$10$sv666ejvl0twqdggVZy8.OH.TYJu4m7rJ4.dUwQvyQzXzYb9EjrvK','2025-03-02 20:42:52'),(66,17,'$2y$10$uca3GisOkzBQMNcJB/75uuq1r9cbLIqLO6uQIqF4jOpNGZ73KhCsm','2025-03-02 20:44:35'),(67,17,'$2y$10$3Tm16ldD8JLCCHR24Pkt9e3kHA/lQENMNnDtp7bQtZWNpFuC9KQBy','2025-03-02 20:44:38'),(68,17,'$2y$10$8QXjgQZkmOhjX5SV22U5aOZawJdYUW4.gtEol54hOD5QKsPvN6VaG','2025-03-02 20:44:49'),(69,17,'$2y$10$6uGcl/3Z3UN9V/c/7lMX.uum8vKT9a2xdid1bdqpNUYRrscjmHoee','2025-03-02 20:46:20'),(70,17,'$2y$10$al9HEgjidxGTLeb3eBYCheSFMUnIfqRYUCVl97xAOEGWE69yGV7GO','2025-03-02 20:46:56'),(71,17,'$2y$10$sYuzuuSXg57PRJvGzvL7h.cfddV8xqAz5PuXCqtyQWISwd8xtgnEi','2025-03-02 20:47:49'),(72,17,'$2y$10$Mx2ojNq..wnqHC/J5dnhgurnHvT10Wc0mZlfzjCR6DvlJXrtvT9du','2025-03-02 20:49:13'),(73,17,'$2y$10$v5NDfWmUK0c6YPt6OyVGQuNhQzZ7vHTzj9iKpg7rtonS9D9it/OAy','2025-03-02 20:51:46'),(74,17,'$2y$10$CkvAOYvxi8DsjaXaFp/1meXO1EMo/pc5w6ngD73wWFrfVMDZ/gPgC','2025-03-02 20:51:52'),(75,17,'$2y$10$HQcgM85PU9YYxM7uEd4i4.bjEX.mVKum4XcD22nwwt0viRlEBKsxi','2025-03-02 20:53:19'),(76,17,'$2y$10$pkzQPDAmvJQ8wbTh3066EO1W/Bw6F1j3YTCxJMZG9KzxrlmUv2SiK','2025-03-02 20:54:01'),(77,17,'$2y$10$cvP11z/xNEakWP8WreYqluQHQK89RE3CoLkaRKmswvU8B9YaSSU/6','2025-03-02 21:54:21'),(78,17,'$2y$10$8SOJ5s.ThDSV.98CRvjvmORGkDTN9.J0JbnuEoku/1mdS49izRG9m','2025-03-02 21:57:02'),(79,17,'$2y$10$jm8CpjDxaGSzVS8G4/6tN.h.mi1A0i/TibyixKkhyMkqLih3c3Ywm','2025-03-02 21:57:17'),(80,17,'$2y$10$oUUAJp0j/kpxgcrQmhgJPOXw7Rb5vxH5r6kZ67J87iPyI4ZMDuoMW','2025-03-02 21:57:25'),(81,17,'$2y$10$GT2z814W7xH0d6eksP3cNOovUY0jgJSe4gik61E.ljYDeLiUJNY96','2025-03-02 22:11:26'),(82,17,'$2y$10$qB/UqrFvmc6BN5BqOGdjL.SsQNO6m0QORUZ3mCrot50bokQS3v72O','2025-03-02 22:11:37'),(83,17,'$2y$10$5XvxNawDEJBOtZi8SbWiOe1OoCHGLHtu/Gqxb5ST8DW3VBLD8Ptii','2025-03-02 22:14:27'),(84,17,'$2y$10$fgG8pXvAbyWoLj5WgupHXeoCRpJ83aeUVOnoCRlYapSBzX4z85stK','2025-03-02 22:15:36'),(85,17,'$2y$10$P3k/bcIpkJdDCxp9a2THPOxQUppT/sKCYx79bpCWhKJ4vzkGMQnlG','2025-03-02 22:16:11'),(86,17,'$2y$10$B7j2qOB.Hyn7C0QK5h0WieR8tE1HCmyRW6LrJKeC.ZKvJ2RK3bfIG','2025-03-02 22:16:46'),(87,17,'$2y$10$ERkc3RxxExhZ1u6ajr8Ltu21NGCagYJs5C7DxbBn3KNcFAjsyyj4G','2025-03-02 22:16:59'),(88,17,'$2y$10$PVgIi7ji.jRr8euJCPq4OO47wf1vP0uT3IOc5fDfsyYpQ62QcQ6Pu','2025-03-02 22:36:26'),(89,17,'$2y$10$YENjvCbKYpyMyCKRCXYXbOJfoeRo3Hz9z1lkGrd7T/9VLA6rQqpee','2025-03-02 22:36:44'),(90,17,'$2y$10$E522ua7S07bLnpehCQ1KIuS/IEmcwIiCSCYpT05mj2n5qzK5lzU4K','2025-03-02 22:38:22'),(91,17,'$2y$10$wa8VLX3EC0zBNGTxDn.lfe5oeLKFw228D3h0Wg62j9yqs8hGTJO6i','2025-03-02 22:38:30'),(92,17,'$2y$10$vVn7WlMm3H2K7091HtbNCOljhbMeeSM75TebVdArhjsj722Kq88Fq','2025-03-02 22:38:49'),(93,17,'$2y$10$zRL05ngCxW0lzSewPi8b7ueB3VuTTCwzD/yN9hFo.HrUGxakQ7v8i','2025-03-02 22:39:40'),(94,17,'$2y$10$IeF02aoZLtwMY7QeSOKHZOJCf6QISno/uO27KeeEyu/ZYaQX5Dpu.','2025-03-02 22:40:58'),(95,17,'$2y$10$DXjuAT7RDNl3olmtyoUCmumGwJuL9Pc3.Tn6P42mYE/Z7EGTDFOeG','2025-03-02 22:42:38'),(96,17,'$2y$10$heGitAiwAmzKFncZQzC1aOQSt.Hf3Tiyzt/nBOQNLOAWkbqzSHZji','2025-03-02 22:43:53'),(97,17,'$2y$10$sM1Z/GAN/TZGpZPB7hJGWOgdHtJL.CmP8tIltUL/nLEB204AvkLcK','2025-03-02 22:44:28'),(98,17,'$2y$10$MdSuDh4BrfvlfTkaFtcaU.I.maqjcWAKCt82XrLlo6DqHw/yZuac.','2025-03-02 22:45:35'),(99,17,'$2y$10$hGks5CzhLlhBsCrfzNuk.OdmS.ZL.RGrH2HCirUalwfhpvncOsw76','2025-03-02 22:48:32'),(100,17,'$2y$10$ti57mojmPhbNpDU7LZ4oo.PdQHTwceUVAwcBnQWt/b2FStqcgekzG','2025-03-02 22:51:46'),(101,17,'$2y$10$Sq/4aZx/ayvpyGOsMQQSCeFiQDPIw/f/94D4tfJ.y7rHYV.IBZEW.','2025-03-02 22:54:00'),(102,17,'$2y$10$cj53/mFbl6XnwG5t7YuJMe9TqqVZad7fRZZhcYcbF5IaxRYpfc7TC','2025-03-02 22:54:02'),(103,17,'$2y$10$Sg4GgIYiLITxKb3yVefWWeTwTjDriNKbV7dWElExE1B3g94AECS/S','2025-03-02 22:59:53'),(104,17,'$2y$10$ndWPZsldXCyicj2K/owS1ewFE5X7l7HI0.ENmHQrIeBh8H5aJhOJG','2025-03-02 23:00:07'),(105,17,'$2y$10$RpY/kBx8PXXTsyLcetSsM.Ux.5E8W.4EXoOBRUt//uaLHRzkj/U3m','2025-03-02 23:00:38'),(106,17,'$2y$10$NDjDQbnqNJS/.h2F7CVt2eFATMM0YMKzdW6DbMWKeO3okSWxnG.X6','2025-03-02 23:01:10'),(107,17,'$2y$10$XwdAHkZ3NLWRpxMaSyc3du.J./8p/al9BWG3h9a/Mxus7pJ50qftm','2025-03-02 23:01:17'),(108,17,'$2y$10$hS4A4z9TzDRtG1Rq3bK7MOCO.6Pka7Kk939FNfF/5hXnY/6PnpDD.','2025-03-02 23:04:24'),(109,17,'$2y$10$pv..IvTECtl0tr5fLdXKJOTW8Qg9.WIiUach.QyFT6vRFqSvaCek.','2025-03-02 23:04:32'),(110,17,'$2y$10$0yiHNAhX9LjZvTCceq7jV.4Oil83YPISLr2fgXsOV44D.2yvduoxu','2025-03-02 23:06:43'),(111,17,'$2y$10$1wySuy.kMe8r8M6ciVFHxO1e2ZwezI0qprbW83Slqj8U3i3Dz0S5u','2025-03-02 23:07:21'),(112,17,'$2y$10$8bWzOAOUub3SJMSIhsNjoOVhWd7YMlqDMQrcn/3fKBdKhdICCn1yW','2025-03-02 23:07:24'),(113,17,'$2y$10$NcyPWlW/9JvEU1bJU6F7TOB.w1toAMQqS1mV6xV3KSJR601ddv4YS','2025-03-02 23:07:34'),(114,17,'$2y$10$t3nelV9rSgWzQyv4wtqCOOTWi7Xm/TIFRN/JHauQFWpPAdj8U5AoK','2025-03-02 23:08:14'),(115,17,'$2y$10$81VPhmC4ltc04W7aRKV/8uJqvRB75iKP67brLbzg4ON4xUJRGFtHW','2025-03-02 23:08:39'),(116,17,'$2y$10$8/PibN4nxVzS1CKVC90tHu0EWVx7xLXgbUPgk08LzlaxavqAk1cNe','2025-03-02 23:09:32'),(117,17,'$2y$10$2wi5n4lZEry80QQp8dWqo.ZwMyRaTP5VMnMe6RhXSNSdi9ASF.jDG','2025-03-02 23:09:40'),(118,17,'$2y$10$51q3xd3.Nu7LHZcqJidcvub5Tzn9CCr/gPsnox9GdrHX8U1fof/zq','2025-03-02 23:09:58'),(119,17,'$2y$10$.wgE/cYYjCCWewvTDZ8k6.pRT8dPXQ0RxTLm9X.HsS3xclKczlQri','2025-03-02 23:10:08'),(120,17,'$2y$10$IcmcLmwijHBRGkvMngwWfe3UPFdr8UjnX8QyrQSW1QSXcVBM4nF5S','2025-03-02 23:11:03'),(121,17,'$2y$10$.exDeHLNmp2PkrtAKPVeDuy1ekqKos.ORl9afTYsbwEGG7xnz0c.m','2025-03-02 23:12:14'),(122,17,'$2y$10$dMgftSVxXjrvzKJb8mqkuOd426mHp9WtU7SuZRo2h30inKK8ObRHy','2025-03-02 23:14:05'),(123,17,'$2y$10$.cjO4RT3v0RMvo3DlbnOkuoNdCZ7RdOuOACg/NVrJzO7U5nVvzbNa','2025-03-02 23:14:24'),(124,17,'$2y$10$YtdEcv/4vhlEaVCPT2142ug4bwLmbw2nsdXY85iVJpcQPsn1hUaBC','2025-03-02 23:14:29'),(125,17,'$2y$10$Qci5B6tFx.GEsoGzrGZ7TeyMCVT.yyv4nxVzB99I2BBp1t6F7rkoq','2025-03-02 23:14:59'),(126,17,'$2y$10$hPAGa2rJC9Z1wT1JUWTmf.CXuw/MVA4ZcEMkr/NW/zchCJkTqySIS','2025-03-02 23:15:08'),(127,17,'$2y$10$IRhIpkw/G027DbZe82qDpe8TRI7oowUg6Dk8T3fYy7ETsMSFE1aKG','2025-03-02 23:29:00'),(128,17,'$2y$10$cSD4LyOShGO6Ypc1IGsEI.ILImBkQO86rgWC1BkeCS5rhN.PzvADm','2025-03-02 23:29:52'),(129,17,'$2y$10$HVcZt9PGB4aOdddiAtFOY.0L6u2K0MECZeEMmvDds1caXfimkMj9e','2025-03-02 23:31:48'),(130,17,'$2y$10$lvhM39ttuNBn/N96h1.Ul.Q/opUUu8IxOQtECjM2fuGBCu69bpvr6','2025-03-02 23:32:32'),(131,17,'$2y$10$7/5gs5CUPN4IdM6xB163Su8a8Hp2pE9yVTZnRPkkOnatw7AsF7Vli','2025-03-02 23:33:53'),(132,17,'$2y$10$vT8u8y8O8PfdinzbIUD1hO2PfYK6X4r7q.jbltDNMHlSzgdprV5r2','2025-03-02 23:34:07'),(133,17,'$2y$10$gruquRNFAr6qYIyWBxHWte7s.QhagoXITMFmS2uEhjXAHNUS.LGK6','2025-03-02 23:34:35'),(134,17,'$2y$10$26rQrWkLjGFijm03Q4LNZO9agVljU94lPZXvy6J9MCDHD7tUlWF6y','2025-03-02 23:34:40'),(135,17,'$2y$10$wPO8sQdwFV3ULPxdIR5ShuY28sFP/4hD19uOxSnnOrtuAYxQUMhy6','2025-03-02 23:34:51'),(136,17,'$2y$10$W3uBu9gLMyE/0K.kPdFlPe/GnKeivYsijWGHeMA4zBMOravSxekBu','2025-03-02 23:35:07'),(137,17,'$2y$10$4PHHnSWaFjvmPUsVawUdCOM/a8xvCqo6lugPyPfh/pA5aclNaZB1y','2025-03-02 23:39:52'),(138,17,'$2y$10$.UdnaetrLBs44rjBo3KmTeP5UHTJvsCGSNz5hXNpJXNIJXi96UB7i','2025-03-02 23:42:07'),(139,17,'$2y$10$ICVZcluC6DDSvPcn0xrIs.NE4uOBcBCok2e9xqnt4kdnoiMSUyr0.','2025-03-02 23:42:22'),(140,17,'$2y$10$Bb/YlzvFVVDhy8W2Px2rc.7CBCzibLlqagmUgIh5.aP9pMhawviO2','2025-03-02 23:42:44'),(141,17,'$2y$10$Z7aAR0VmDC11tQYV2OOos.S7p0uQ4zjYMKS0Pu5TTlCCj/IQFTQMu','2025-03-02 23:42:55'),(142,17,'$2y$10$G8ftzBYggLXQsOSfxvfN.euPggIeA.BhQxYMkBYdG9ysKs2V.8L2O','2025-03-02 23:43:15'),(143,17,'$2y$10$tuIOdJ7bwa4oZU.DIROJv./n3ERaSK/0fX82QY42G2olQ24N9fhXW','2025-03-02 23:43:34'),(144,17,'$2y$10$81VI2eUM2XtSoKfFp7IPVO9I2NzQnFq2N8GKNkoJgJHffSBkR7Uqi','2025-03-03 22:44:02'),(145,17,'$2y$10$9JD06/1mB8LE897dUD1Dh.MTxAiQ7b6QE8.qWsBdUJS893u/f5bGK','2025-03-03 22:44:37'),(146,17,'$2y$10$P.LoBYobqzORqS5xupGXaemHfWYG0kX0MM6U7WKrwpxRqGLoyGcaa','2025-03-03 23:56:07'),(147,17,'$2y$10$hQHBlK7OCdfpe6Y4/25JDusyxhtEKqIN0omf37yEV4n8oXNT3rVIi','2025-03-04 00:06:01'),(148,17,'$2y$10$5jqoKbkjAtafR9UCOH8h/e2hgjEpjOeV5DwPg9A74l7IvRv.kT7wy','2025-03-04 00:41:57'),(149,17,'$2y$10$xMETgw5z0j9fFQfYvPDkOe5emU4OMhcP3ySMOozPW//Fqr7n.E4Tu','2025-03-04 00:42:00'),(150,17,'$2y$10$rwnxraasZjGnHTdV22u4/OHZ.Mi0q4QEcVL0hvOCxsGqmjEQ2qLSm','2025-03-04 00:42:01'),(151,19,'$2y$10$apy3vVAn4ehvPd.c.sgrWuLKaBH5ocffqbzycepi6aAsxwk99ghJ2','2025-03-04 01:21:15'),(152,20,'$2y$10$Z6qtmcHW78t/haI6xyU4/eQHhvPHy4EHrzBItLleKi4x.ms4iY09O','2025-03-04 01:22:40'),(153,17,'$2y$10$nC0MOTUqs2ZOyf8F/snMOOvsJ1jPoPmoL3QfjoRH90gb4zwbwMJuO','2025-03-04 01:27:42'),(154,17,'$2y$10$nDSNSmzlCni16utCr29Noe5SFQxRmG3hBm/ec7MLwVLRUXENvPLl2','2025-03-04 01:30:57'),(155,17,'$2y$10$H9djWKOHmCms93KUN5hqhOHlmJXy.MTkP4kOk9Np1.1Q3pNJw3ake','2025-03-04 09:13:30'),(156,17,'$2y$10$OnTyxT6p4LWtBAizcq.c.uhibuqoV9PdMgCRM066ENObZUvesPWqa','2025-03-04 09:38:17'),(157,18,'$2y$10$rHYoMjZS7LcveWMfD.s2Ge8qf46uj.oXSDSvlX.OFGfItsL10FUMe','2025-03-04 09:56:17'),(158,17,'$2y$10$exRNIBFbC/MWBbAq4nEFFOb31sZEZefNeQLJm9Srf85SjVxK1GFaW','2025-03-04 09:56:48'),(159,18,'$2y$10$p3uMuYUom2kk2NGjvjqmL.WIDgnAPKf2XkYlNiokv/93LDTUJ5yYe','2025-03-04 15:25:33'),(160,6,'$2y$10$ao1GE5UXgtIJ1IrlyZlHqO/CICv9lXStkw6uJJ5063faFKsEN/hee','2025-03-04 22:53:10'),(161,17,'$2y$10$rzp0STfrz6FcJNgx2lMTK.sAE4vSoYhD02MGS4.d27D/qSE0Ct5CO','2025-03-04 22:57:41'),(162,18,'$2y$10$1Sq3q.dK8FtFXk0dujPSI.02v1Lhh6jwBndxGNo2zfGieQGwzlb/O','2025-03-04 22:58:42'),(163,18,'$2y$10$CHrE6HFOvzXB7deYNUFx0.bHmgmpBcNkPmQusQc2wIN6OMxx5BLv2','2025-03-05 00:38:07'),(164,17,'$2y$10$eiLZTCQ/jjIeZdFXKz41wuQ1yGOpfufkb/gFsGyr0tKNTOv4SnQpS','2025-03-05 00:38:10'),(165,17,'$2y$10$T9OKMrIgVe7O1ulMANgiYOm4ZsWVA.hDe8kAIshQdXHE85/IGyWca','2025-03-05 00:59:54'),(166,17,'$2y$10$wykzv3B.Ma/9aEm5hLEFp.KQQ2rL6I/ZqpyyKBPKeyQMbx80gJwrG','2025-03-06 09:59:49'),(167,17,'$2y$10$z4vWsbkI28Z/Eg0C3uLPMuD92iA1CjepgN2w3pN87/qtvgd39VWeC','2025-03-06 10:08:47'),(168,6,'$2y$10$vEISZC78DGcIkBNtRdKec.apzZLqlQfnXFQBvu4Lr.xIyUUCMKX8W','2025-03-06 20:43:45'),(169,17,'$2y$10$bwFBAuJNZVyzYON7AZLGpuvqfCYT9U0MaOL5oNUh2O6tZmK72J9WC','2025-03-06 21:08:33'),(170,17,'$2y$10$i7LAFDoWodXMwn2AQo6rke3K7aA3P3Fm2jIOxdqV6TLqW85TgwHoK','2025-03-07 17:38:26'),(171,17,'$2y$10$YSLnrnHhuNMeBw1LXZifGuPVbQYunx8irkzreijdUOoWiThSNy8oi','2025-03-07 23:28:37'),(172,21,'$2y$10$U23V6jaHVpCPZV6WMJXpA.xOajhg1LqxI8nSI3gKdznouiq6G77i2','2025-03-08 18:41:58'),(173,21,'$2y$10$3wyciACoBo6AgPeAnR550eBz1BqYWU/FpG2KOrKWgOvgnkEplOhuW','2025-03-08 18:42:29'),(174,6,'$2y$10$iK0TH.xlIpSW8y94etI4wetbhTPmirnZP1y0yTru2W9B1tjuqMW9.','2025-03-08 18:42:42'),(175,6,'$2y$10$NqgpSuHvVlATbpgr46veOejlRU3iv8PMrPpdzjc0NFO77E8ep0O0.','2025-03-08 18:42:56'),(176,17,'$2y$10$Xo7YTuMQm66jOsAlOqXAnuNnWScoXPpDV5AZLhQl6DGxxNCfVEED2','2025-03-08 20:36:46'),(177,17,'$2y$10$1oVgIziNBa5bjdOxJKX0nO/2kWCO.Gfnx4ZAxutrrejLTrdfEOJ7G','2025-03-09 11:56:20'),(178,16,'$2y$10$hxB6UttVdJe.Zt7RZrGA/egYa0IKmFp8RT5rhmDfbZHxjUqZJ5sQe','2025-03-09 14:22:01'),(179,17,'$2y$10$Fm8t1J3gml9.Rgqibtohnuj3XVQuecyRBbXVxS5CLIEFDtulDSSB2','2025-03-09 14:24:25'),(180,8,'$2y$10$eNmO4qM6DngRpl86WPF5U.7ms3GQckbTRZyejTRdlIpiRsbqzXvoy','2025-03-09 19:48:07'),(181,17,'$2y$10$6mJ1814S3/5OOq5p1qwCZeJM64Y1LDvifzRBCtIsLM5pBgc3RiBZ6','2025-03-11 21:08:10'),(182,17,'$2y$10$yv.3S3rkDlxbpvuIevEr9OtEbB6iqJYvKeKLCM91GUGQ2lgXYrIK.','2025-03-11 21:36:28'),(183,16,'$2y$10$yjkEEbEGCuKj6WyBPlgPK.6q09.5kkfiMMdYovo8NXsxDnB1nvxlO','2025-03-12 21:27:30'),(184,17,'$2y$10$vABEE.rZFRmlgq3zEI7v3.CW19cb4rECKgjf5lE8zPyYGHoM/XsRW','2025-03-12 22:25:52'),(185,11,'$2y$10$lwCH71oeIzB9JV2Zo/04NuXTuQXznBX0dNZh.u7hb5YL6OZTXffp2','2025-03-13 22:15:47'),(186,17,'$2y$10$e7dRwGGyLGZZjaHeb9jxHO7skvrHMyQJBV0xADJOs4PbCeba/93La','2025-03-13 22:21:03'),(187,17,'$2y$10$1BckPRuaumVA8nkaxTu/XOM8VPjFOsTkP6qkQMpygcSQo7zi/0ugC','2025-03-15 17:40:43'),(188,8,'$2y$10$Ql3QhtIk5xKQ0MrkNGNfhunGGDDJLNJSrFf3sJuE5CMOKhuXB9rb2','2025-03-15 17:41:48'),(189,17,'$2y$10$Zqz3vTQx0b/2DfsZA5rsy.Vfmcbtu57NPhEPn0LtosaVTMtz4on3G','2025-03-16 12:04:36'),(190,17,'$2y$10$mnAdponX0nY3QUq83pIYBuRikeubAJtbliiNDA2VD8g0X5LH0Pjb2','2025-03-17 12:24:15'),(191,10,'$2y$10$2suoacNwt2en.Lo9jncL7uWsHztZV6U4puxjSQ00eZ/MVkd9KT6kC','2025-03-17 16:05:12'),(192,17,'$2y$10$QbX3vhpqIoP8X3hqm5G9LOHvICzu01lklDe6yPn6UARt4D5ua00Hq','2025-03-18 19:02:56'),(193,17,'$2y$10$A0R8iLJbifMtMcL8HspCxu3UBuBvrr7/4BYujs9ha5kBCJTqPtc6O','2025-03-18 19:04:10'),(194,17,'$2y$10$GTe4VmDxHHiHa8jPjEdon.SAHQkvAIZgRW1K.7bmuyG6d0tr2E.Fi','2025-03-22 13:47:45'),(195,17,'$2y$10$KKYP.GjbWD3rmnV2D/slZut1VOV9.MUVUtV4QCMhQ6ZthEJB4p5YO','2025-03-22 16:17:59'),(196,8,'$2y$10$XbDzkVJESn2kwrE.fsW3J.7dKJgAsjYfM6Kg41SVuJmiXuaP9DLXm','2025-04-04 18:47:53'),(197,17,'$2y$10$WgiXRa1vK02G7DDbNTWe0ew8s.soGKLYqJCpAuIPWIVIYUcUP7xrS','2025-04-04 18:52:17'),(198,17,'$2y$10$snVN.8vcoF80aKUXFGQEbex2.IrMQSxRmS01pzZcKuWPZWMWGCQAO','2025-04-05 18:52:24'),(199,17,'$2y$10$t5q.3kl7Twup8/Ae193o..69BJSZq6PIKBssT0IwmyWuGeV9pkq2G','2025-04-08 15:21:47'),(200,8,'$2y$10$OvEJ22BsQsWr7cetM3PMzOlIg7XEmaykGfxaPjYogeHTVsw2VXrxm','2025-04-08 20:38:32'),(201,17,'$2y$10$N8TbXVixDO0lD8MCDIIwdO7TJal.WzeT1Mm8I89.Uyz0PhcIMYDFO','2025-04-08 20:50:46');
/*!40000 ALTER TABLE `users_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pulse'
--

--
-- Dumping routines for database 'pulse'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_google_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_google_account`(IN idUser INT, IN googleIdVar VARCHAR(255))
BEGIN

	UPDATE users SET googleId = googleIdVar WHERE id = idUser;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_delete`(IN proyectId INT, IN userId INT)
BEGIN

	DELETE FROM proyects_members WHERE proyect_id = proyectId AND user_id = userId;	
    
    DELETE FROM proyects_tasks_users WHERE user_id = userId AND task_id IN (
			SELECT id FROM proyects_tasks WHERE proyect_id = proyectId
	);

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
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_of_user_id_proyect_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_of_user_id_proyect_id`(IN userId INT, IN proyectId INT)
BEGIN

	SELECT proyects_members.*,
    users.id AS user_id,
    users.username AS user_username,
    users.email AS user_email,
    users.password AS user_password,
    users.registred AS user_registred,
    users.photo AS user_photo
    FROM proyects_members INNER JOIN users ON proyects_members.user_id = users.id AND users.id = userId AND proyects_members.proyect_id = proyectId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_select_pendings_of_proyect_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_select_pendings_of_proyect_id`(IN proyectId INT)
BEGIN
    
    SELECT proyects_members.* ,
    users.username AS user_username,
    users.email AS user_email,
    users.password AS user_password,
    users.photo AS user_photo,
    users.registred AS user_registred,
    users.id AS user_id
    FROM proyects_members INNER JOIN users ON proyects_members.user_id = users.id AND proyects_members.proyect_id = proyectId AND proyects_members.status = 0;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_select_pendings_of_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_select_pendings_of_user_id`(IN userId INT)
BEGIN
    
    SELECT proyects_members.* ,
    users.username AS user_username,
    users.email AS user_email,
    users.password AS user_password,
    users.photo AS user_photo,
    users.registred AS user_registred,
    users.id AS user_id
    FROM proyects_members INNER JOIN users ON proyects_members.user_id = users.id AND users.id = userId AND proyects_members.status = 0;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_members_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_members_update`(IN userId INT, IN proyectId INT, IN statusVar INT, IN effectiveTime INT)
BEGIN

	UPDATE proyects_members SET status=statusVar, effective_time=effectiveTime WHERE user_id=userId AND proyect_id=proyectId;

	SELECT proyects_members.*,
    users.username AS user_username,
    users.email AS user_email,
    users.password AS user_password,
    users.photo AS user_photo,
    users.registred AS user_registred
    FROM proyects_members INNER JOIN users ON proyects_members.user_Id=users.id AND users.id=userId AND proyects_members.proyect_id=proyectID;

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
		SELECT proyect_id FROM proyects_members WHERE user_id = user_idVar AND status = 1
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proyects_of_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_of_user_id`(IN user_idVar INT)
BEGIN

	SELECT * FROM proyects WHERE id IN (
		SELECT proyect_id FROM proyects_members WHERE user_id = user_idVar AND status = 1
    )
    OR id IN (SELECT id FROM proyects WHERE owner_id = user_idVar);

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
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_select_tag_of_proyect_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_select_tag_of_proyect_id`(IN proyectId INT)
BEGIN

	SELECT DISTINCT tag FROM proyects_tasks WHERE proyect_id=proyectId AND length(tag) > 0;

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
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_users_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_users_delete`(IN taskId INT, IN userId INT)
BEGIN

	DELETE FROM proyects_tasks_users WHERE task_id=taskId AND user_id=userId;

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
/*!50003 DROP PROCEDURE IF EXISTS `proyects_tasks_users_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proyects_tasks_users_update`(IN taskId INT, IN userId INT, IN statusVar INT)
BEGIN

	UPDATE proyects_tasks_users SET status = statusVar WHERE task_id=taskId AND user_id = userId;

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
/*!50003 DROP PROCEDURE IF EXISTS `remove_google_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_google_account`(IN userId INT)
BEGIN

	UPDATE users SET googleId = null WHERE id = userId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tasks_select_unassigned_of_proyect_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tasks_select_unassigned_of_proyect_id`(IN proyectId INT)
BEGIN

	SELECT * FROM proyects_tasks WHERE proyect_id=proyectId
    AND id NOT IN (
		SELECT task_id FROM proyects_tasks_users
    );

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
    
    SELECT users.*, proyects_tasks_users.* FROM users, proyects_tasks_users WHERE proyects_tasks_users.task_id=taskId AND users.id=proyects_tasks_users.user_id AND
    (
		SELECT status FROM proyects_members WHERE user_id=users.id AND proyects_members.proyect_id=
		(
			SELECT proyect_id FROM proyects_tasks WHERE id = taskId
		)
    )=1
    ;

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
    
    SELECT proyects_members.*, users.* FROM proyects_members INNER JOIN users ON proyects_members.proyect_id = proyectId AND users.id = proyects_members.user_id AND proyects_members.status = 1;

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
/*!50003 DROP PROCEDURE IF EXISTS `users_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_search`(IN text VARCHAR(255))
BEGIN

	SELECT * FROM users WHERE email LIKE CONCAT(text, "%")  OR username LIKE CONCAT(text, "%");

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_search_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_search_email`(IN emailVar VARCHAR(255))
BEGIN

	SELECT * FROM users WHERE email LIKE CONCAT(emailVar, "%");

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `users_search_username` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_search_username`(IN usernameVar VARCHAR(255))
BEGIN

	SELECT * FROM users WHERE username LIKE CONCAT(usernameVar, "%");

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

-- Dump completed on 2025-04-07 22:55:14
