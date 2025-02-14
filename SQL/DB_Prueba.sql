-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         11.7.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para test
CREATE DATABASE IF NOT EXISTS `test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `test`;

-- Volcando estructura para tabla test.applications
CREATE TABLE IF NOT EXISTS `applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `candidate_id` int(11) DEFAULT NULL,
  `job_id` int(11) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `applied_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `job_id` (`job_id`),
  KEY `status_id` (`status_id`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `applications_ibfk_3` FOREIGN KEY (`status_id`) REFERENCES `statusdescription` (`status_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla test.applications: ~2 rows (aproximadamente)
INSERT INTO `applications` (`id`, `candidate_id`, `job_id`, `status_id`, `applied_at`) VALUES
	(1, 1, 1, 3, '2025-02-13 21:00:32'),
	(2, 2, 2, 2, '2025-02-14 01:46:47');

-- Volcando estructura para procedimiento test.ApplyToJob
DELIMITER //
CREATE PROCEDURE `ApplyToJob`(
    IN p_candidate_id INT,
    IN p_job_id INT
)
BEGIN
    INSERT INTO Applications (candidate_id, job_id, status_id, applied_at)
    VALUES (p_candidate_id, p_job_id, 1, NOW()); 
END//
DELIMITER ;

-- Volcando estructura para tabla test.cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla test.cache: ~0 rows (aproximadamente)

-- Volcando estructura para tabla test.cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla test.cache_locks: ~0 rows (aproximadamente)

-- Volcando estructura para tabla test.candidates
CREATE TABLE IF NOT EXISTS `candidates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `resume` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Is_Deleted` bit(1) DEFAULT b'0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla test.candidates: ~2 rows (aproximadamente)
INSERT INTO `candidates` (`id`, `first_name`, `last_name`, `email`, `phone`, `resume`, `created_at`, `updated_at`, `Is_Deleted`) VALUES
	(1, 'Roberto', 'Valderrama', 'rvalderrama44@gmail.com', '5610972174', 'resumen actualizado', '2025-02-13 20:50:26', '2025-02-13 21:02:17', b'0'),
	(2, 'Roberto', 'Valderrama 2', 'rvalderrama45@gmail.com', '5512342342', 'resumen actualizado', '2025-02-14 00:58:06', '2025-02-14 01:28:16', b'0');

-- Volcando estructura para procedimiento test.CreateCandidate
DELIMITER //
CREATE PROCEDURE `CreateCandidate`(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_resume TEXT
)
BEGIN
    INSERT INTO Candidates (first_name, last_name, email, phone, resume, Is_Deleted)
    VALUES (p_first_name, p_last_name, p_email, p_phone, p_resume, 0);
END//
DELIMITER ;

-- Volcando estructura para procedimiento test.CreateJob
DELIMITER //
CREATE PROCEDURE `CreateJob`(
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_location VARCHAR(150),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Jobs (title, description, location, salary)
    VALUES (p_title, p_description, p_location, p_salary);
END//
DELIMITER ;

-- Volcando estructura para procedimiento test.DeleteCandidate
DELIMITER //
CREATE PROCEDURE `DeleteCandidate`(
    IN p_candidate_id INT
)
BEGIN
    UPDATE Candidates
    SET Is_Deleted = 1
    WHERE id = p_candidate_id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento test.GetAllApplications
DELIMITER //
CREATE PROCEDURE `GetAllApplications`()
BEGIN
    SELECT a.id, c.first_name, c.last_name, j.title, s.description AS status, a.applied_at
    FROM Applications a
    JOIN Candidates c ON a.candidate_id = c.id
    JOIN Jobs j ON a.job_id = j.id
    JOIN StatusDescription s ON a.status_id = s.status_id
    WHERE c.Is_Deleted = 0;
END//
DELIMITER ;

-- Volcando estructura para procedimiento test.GetAllCandidates
DELIMITER //
CREATE PROCEDURE `GetAllCandidates`()
BEGIN
    SELECT id, first_name, last_name, email, phone, resume
    FROM Candidates
    WHERE Is_Deleted = 0;
END//
DELIMITER ;

-- Volcando estructura para procedimiento test.GetAllJobs
DELIMITER //
CREATE PROCEDURE `GetAllJobs`()
BEGIN
    SELECT * FROM Jobs;
END//
DELIMITER ;

-- Volcando estructura para tabla test.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla test.jobs: ~3 rows (aproximadamente)
INSERT INTO `jobs` (`id`, `title`, `description`, `location`, `salary`, `created_at`, `updated_at`) VALUES
	(1, 'Desarrollador Backend Actualizado', 'Descripcion para puesto de desarrollador backend actualizado', 'CDMX', 20500.00, '2025-02-13 20:56:48', '2025-02-13 23:29:03'),
	(2, 'Puesto nuevo 1 actualizado', 'Description puesto actualizado', 'CDMX', 10.00, '2025-02-14 01:11:02', '2025-02-14 01:12:45'),
	(3, 'Puesto nuevo 2', 'Description puesto', 'CDMX', 10.00, '2025-02-14 01:34:52', '2025-02-14 01:34:52'),
	(4, 'Puesto nuevo 2', 'Description puesto', 'CDMX', 10.00, '2025-02-14 01:36:17', '2025-02-14 01:36:17');

-- Volcando estructura para tabla test.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla test.migrations: ~2 rows (aproximadamente)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '0001_01_01_000001_create_cache_table', 1);

-- Volcando estructura para tabla test.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla test.password_reset_tokens: ~0 rows (aproximadamente)

-- Volcando estructura para tabla test.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla test.sessions: ~4 rows (aproximadamente)
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
	('6bSCZ9O4RsUIO88L3bSpwPMI4bYLfW22Cd6dknxb', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiREFWcjlIcTJRcGswUW0yTUp4dlBFWnloZTlBeWgzUVZXM2dDb2EzaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1739497035),
	('tqKWL5rO8jMyjAgvdGrQ6Azh2Hhag7k73aBBqM89', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNng0WXZaT0RDNkliSjliNjNZbEF3cGVvOXFEWTBNTXFSd1RxTDBVYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1739494521),
	('WoRaJsfSUItXVuahxtRwuIQBT8niZCGeHuC475dd', NULL, '127.0.0.1', 'PostmanRuntime/7.43.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiazNGSVNuV1ZYN2NVRFpvVkhkY0IzNjlTZUNQZEhUS3BsOURBTlNuRyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzI6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9jYW5kaWRhdGVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1739493311),
	('yn90AP5neem3NtsmgES38I9XRLNYJXJqnEdPdvwj', NULL, '::1', 'PostmanRuntime/7.43.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSndYdG5yck9YSmk5U3VKdkhPTnh4c2FWM0RyTnhQeGs0TVJuSDhwbCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1739497635);

-- Volcando estructura para tabla test.statusdescription
CREATE TABLE IF NOT EXISTS `statusdescription` (
  `status_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla test.statusdescription: ~4 rows (aproximadamente)
INSERT INTO `statusdescription` (`status_id`, `description`) VALUES
	(1, 'Pending'),
	(2, 'Reviewed'),
	(3, 'Accepted'),
	(4, 'Rejected');

-- Volcando estructura para procedimiento test.UpdateApplicationStatus
DELIMITER //
CREATE PROCEDURE `UpdateApplicationStatus`(
    IN p_application_id INT,
    IN p_status_id INT
)
BEGIN
    UPDATE Applications
    SET status_id = p_status_id
    WHERE id = p_application_id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento test.UpdateCandidate
DELIMITER //
CREATE PROCEDURE `UpdateCandidate`(
    IN p_candidate_id INT,
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_resume TEXT
)
BEGIN
    UPDATE Candidates
    SET email = p_email,
        phone = p_phone,
        resume = p_resume
    WHERE id = p_candidate_id AND Is_Deleted = 0;
END//
DELIMITER ;

-- Volcando estructura para procedimiento test.UpdateJob
DELIMITER //
CREATE PROCEDURE `UpdateJob`(
    IN p_id INT,
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_location VARCHAR(150),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    UPDATE Jobs
    SET 
        title = p_title,
        description = p_description,
        location = p_location,
        salary = p_salary,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
END//
DELIMITER ;

-- Volcando estructura para tabla test.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla test.users: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
