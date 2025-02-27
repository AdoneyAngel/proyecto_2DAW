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
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fr_usersProyects_users_idx` (`owner_id`),
  CONSTRAINT `fr_usersProyects_users` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects`
--

LOCK TABLES `proyects` WRITE;
/*!40000 ALTER TABLE `proyects` DISABLE KEYS */;
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
/*!40000 ALTER TABLE `proyects_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_members_history`
--

DROP TABLE IF EXISTS `proyects_members_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_members_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `proyect_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fr_proyectsMembersHistory_users_idx` (`user_id`),
  KEY `fr_proyectsMembersHistory_proyects_idx` (`proyect_id`),
  CONSTRAINT `fr_proyectsMembersHistory_proyects` FOREIGN KEY (`proyect_id`) REFERENCES `proyects` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsMembersHistory_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Historial en el cual se guardará los usuarios que entran, salen y hacen cualquier cosa como por ejemplo terminar una tarea';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_members_history`
--

LOCK TABLES `proyects_members_history` WRITE;
/*!40000 ALTER TABLE `proyects_members_history` DISABLE KEYS */;
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
  `status` int(11) DEFAULT NULL COMMENT '"todo", "progress", "review", "done"',
  PRIMARY KEY (`id`),
  KEY `fr_proyectsTasks_proyects_idx` (`proyect_id`),
  KEY `fr_proyectsTasks_users_idx` (`user_id`),
  KEY `fr_proyectsTasks_proyectsTasksStatus_idx` (`status`),
  CONSTRAINT `fr_proyectsTasks_proyects` FOREIGN KEY (`proyect_id`) REFERENCES `proyects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasks_proyectsTasksStatus` FOREIGN KEY (`status`) REFERENCES `proyects_tasks_status` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasks_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks`
--

LOCK TABLES `proyects_tasks` WRITE;
/*!40000 ALTER TABLE `proyects_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `proyects_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks_comments`
--

DROP TABLE IF EXISTS `proyects_tasks_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks_comments` (
  `id` int(11) NOT NULL,
  `task_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fr_proyectsTasksComments_users_idx` (`user_id`),
  KEY `fr_proyectsTasksComments_proyectsTasks_idx` (`task_id`),
  CONSTRAINT `fr_proyectsTasksComments_proyectsTasks` FOREIGN KEY (`task_id`) REFERENCES `proyects_tasks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fr_proyectsTasksComments_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_comments`
--

LOCK TABLES `proyects_tasks_comments` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `proyects_tasks_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyects_tasks_history`
--

DROP TABLE IF EXISTS `proyects_tasks_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyects_tasks_history` (
  `id` int(11) NOT NULL,
  `task_id` int(11) DEFAULT NULL,
  `new_status` varchar(255) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fr_proyectsTasksHistory_proyectsTasksUsers` (`task_id`),
  KEY `fr_proyectsTasksHistory_proyectsTasks_idx` (`task_id`),
  CONSTRAINT `fr_proyectsTasksHistory_proyectsTasks` FOREIGN KEY (`task_id`) REFERENCES `proyects_tasks` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyects_tasks_history`
--

LOCK TABLES `proyects_tasks_history` WRITE;
/*!40000 ALTER TABLE `proyects_tasks_history` DISABLE KEYS */;
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
/*!40000 ALTER TABLE `proyects_tasks_users_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_logs`
--

DROP TABLE IF EXISTS `query_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `query_logs` (
  `id` int(11) NOT NULL,
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
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `registred` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_tokens`
--

DROP TABLE IF EXISTS `users_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fr_usersTokens_users_idx` (`user_id`),
  CONSTRAINT `fr_usersTokens_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_tokens`
--

LOCK TABLES `users_tokens` WRITE;
/*!40000 ALTER TABLE `users_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_tokens` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-26 22:57:20
