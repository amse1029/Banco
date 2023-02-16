CREATE DATABASE  IF NOT EXISTS `e_banca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `e_banca`;
-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: e_banca
-- ------------------------------------------------------
-- Server version	8.0.31

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
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `apellidoPaterno` varchar(30) NOT NULL,
  `apellidoMaterno` varchar(30) DEFAULT NULL,
  `fechaNacimiento` date NOT NULL,
  `edad` int DEFAULT (timestampdiff(YEAR,`fechaNacimiento`,curdate())),
  `nip` int NOT NULL,
  `codigoDireccion` int NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `codigoDireccion` (`codigoDireccion`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`codigoDireccion`) REFERENCES `direcciones` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'asd','asd','asd','2002-02-02',21,1234,9);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuentas`
--

DROP TABLE IF EXISTS `cuentas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuentas` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `estado` enum('activo','cancelada') NOT NULL,
  `fechaApertura` date NOT NULL DEFAULT (curdate()),
  `saldo` int DEFAULT '0',
  `codigoCliente` int NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `codigoCliente` (`codigoCliente`),
  CONSTRAINT `cuentas_ibfk_1` FOREIGN KEY (`codigoCliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuentas`
--

LOCK TABLES `cuentas` WRITE;
/*!40000 ALTER TABLE `cuentas` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuentas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direcciones`
--

DROP TABLE IF EXISTS `direcciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direcciones` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `calle` varchar(50) NOT NULL,
  `numero` int NOT NULL,
  `colonia` varchar(50) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones`
--

LOCK TABLES `direcciones` WRITE;
/*!40000 ALTER TABLE `direcciones` DISABLE KEYS */;
INSERT INTO `direcciones` VALUES (1,'asss',33,'dada'),(2,'asd',12,'asd'),(3,'paris',33,'cortinas'),(4,'paris',33,'cortinas'),(5,'paris',33,'cortinas'),(6,'paris',44,'cortinas'),(7,'paris',44,'cortinas'),(8,'paris',66,'cortinas'),(9,'asd',233,'asd');
/*!40000 ALTER TABLE `direcciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retiros`
--

DROP TABLE IF EXISTS `retiros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retiros` (
  `folio` int NOT NULL AUTO_INCREMENT,
  `cantidad` int NOT NULL,
  `contraseña` int NOT NULL,
  `codigoCuentaDestino` int NOT NULL,
  `fechaRetiro` date NOT NULL DEFAULT (curdate()),
  `estado` enum('cancelado','retirado') DEFAULT NULL,
  PRIMARY KEY (`folio`),
  KEY `codigoCuentaDestino` (`codigoCuentaDestino`),
  CONSTRAINT `retiros_ibfk_1` FOREIGN KEY (`codigoCuentaDestino`) REFERENCES `cuentas` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retiros`
--

LOCK TABLES `retiros` WRITE;
/*!40000 ALTER TABLE `retiros` DISABLE KEYS */;
/*!40000 ALTER TABLE `retiros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transferencias`
--

DROP TABLE IF EXISTS `transferencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transferencias` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `fechaTransferencia` date NOT NULL DEFAULT (curdate()),
  `tipo` enum('retiro sin cuenta','transferencia') NOT NULL,
  `cantidad` int NOT NULL,
  `codigoCuenta` int NOT NULL,
  `codigoCuentaDestino` int NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `codigoCuenta` (`codigoCuenta`),
  KEY `codigoCuentaDestino` (`codigoCuentaDestino`),
  CONSTRAINT `transferencias_ibfk_1` FOREIGN KEY (`codigoCuenta`) REFERENCES `cuentas` (`codigo`),
  CONSTRAINT `transferencias_ibfk_2` FOREIGN KEY (`codigoCuentaDestino`) REFERENCES `cuentas` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transferencias`
--

LOCK TABLES `transferencias` WRITE;
/*!40000 ALTER TABLE `transferencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `transferencias` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-02-15 20:44:11
