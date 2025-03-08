-- MySQL dump 10.13  Distrib 8.0.40, for Linux (aarch64)
--
-- Host: localhost    Database: ecommerce_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Address`
--

DROP TABLE IF EXISTS `Address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Address` (
  `address_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `street_address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  `default_address` tinyint(1) NOT NULL DEFAULT '0',
  `title_address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Address`
--

LOCK TABLES `Address` WRITE;
/*!40000 ALTER TABLE `Address` DISABLE KEYS */;
INSERT INTO `Address` VALUES ('72ae28bb-1c5e-4b08-93ec-9dd12e805b45','9099029b-00ad-4378-b42b-930f9b09e120','Cisaat Kp Babakan Nagrak Pasar Cisaat','Sukabumi','123',0,'Home'),('d0113f21-3877-4e74-ad9b-e72e4cd72bf3','9099029b-00ad-4378-b42b-930f9b09e120','Jl Cilandak Barat, Midtown residence','Jakarta Selata','437721',1,'Office');
/*!40000 ALTER TABLE `Address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cart`
--

DROP TABLE IF EXISTS `Cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cart` (
  `cart_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `quantity` int NOT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `user_id` char(36) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  KEY `product_id` (`product_id`),
  KEY `Cart_Item_ibfk_1` (`user_id`),
  CONSTRAINT `Cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `Cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cart`
--

LOCK TABLES `Cart` WRITE;
/*!40000 ALTER TABLE `Cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `Cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Category`
--

DROP TABLE IF EXISTS `Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Category` (
  `category_id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Category`
--

LOCK TABLES `Category` WRITE;
/*!40000 ALTER TABLE `Category` DISABLE KEYS */;
INSERT INTO `Category` VALUES ('44354bb0-cd27-11ef-a748-0242ac120002','',NULL),('5e991e67-caa4-11ef-818b-0242ac120003','Mobile Device','mobile phone'),('732ec68e-0b32-47d8-93e2-6bc5085f8b2d','Kamera','Kamera device'),('b33ccc9b-ec0a-4547-ae45-4e1781d28cea','Electronic','Lorem ipsum'),('d1caa7d2-2452-45b8-ac10-24b32fb83c56','Otomotif','Lorem ipsum'),('e71e59ca-ed28-11ef-ad99-0242ac120002','Figure','Figure Action');
/*!40000 ALTER TABLE `Category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Order`
--

DROP TABLE IF EXISTS `Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Order` (
  `order_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `status` enum('Pending','Processing','Shipped','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
  `total_price` decimal(10,2) DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `address_id` char(36) NOT NULL,
  `payment_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `fk_order_address` (`address_id`),
  KEY `fk_payment_id` (`payment_id`),
  CONSTRAINT `fk_order_address` FOREIGN KEY (`address_id`) REFERENCES `Address` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `Payment` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `Order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Order`
--

LOCK TABLES `Order` WRITE;
/*!40000 ALTER TABLE `Order` DISABLE KEYS */;
INSERT INTO `Order` VALUES ('387ec307-712a-4960-8345-71e793f97034','9099029b-00ad-4378-b42b-930f9b09e120','Pending',NULL,'2025-03-07 21:23:05','72ae28bb-1c5e-4b08-93ec-9dd12e805b45','e84d9c0c-cb95-4487-9772-8be4d7def20f'),('aa75cfc2-ab58-4ebc-8c88-7bc960f5035f','9099029b-00ad-4378-b42b-930f9b09e120','Pending',NULL,'2025-03-08 07:47:45','d0113f21-3877-4e74-ad9b-e72e4cd72bf3','3de81e64-bc44-47c0-a1e3-3af604b3005e'),('abc3c4a4-eacf-4d01-9520-ec278b036959','9099029b-00ad-4378-b42b-930f9b09e120','Pending',NULL,'2025-03-08 08:09:44','d0113f21-3877-4e74-ad9b-e72e4cd72bf3',NULL),('d796917c-f324-4ed1-9a4b-35304e1c81ac','9099029b-00ad-4378-b42b-930f9b09e120','Pending',NULL,'2025-03-08 07:39:43','72ae28bb-1c5e-4b08-93ec-9dd12e805b45','c8fcaa7f-3b59-4362-a34a-a5d86a6a4245'),('e86742d7-df08-4a58-91f8-97fe95436e50','9099029b-00ad-4378-b42b-930f9b09e120','Pending',NULL,'2025-03-07 21:22:12','72ae28bb-1c5e-4b08-93ec-9dd12e805b45','a8b90249-ad44-47b9-b5cd-a3b4f62a85d3');
/*!40000 ALTER TABLE `Order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Order_Item`
--

DROP TABLE IF EXISTS `Order_Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Order_Item` (
  `order_item_id` char(36) NOT NULL,
  `order_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `Order_Item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Order` (`order_id`),
  CONSTRAINT `Order_Item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Order_Item`
--

LOCK TABLES `Order_Item` WRITE;
/*!40000 ALTER TABLE `Order_Item` DISABLE KEYS */;
INSERT INTO `Order_Item` VALUES ('0ad09481-a571-4290-a749-e4286912d21b','e86742d7-df08-4a58-91f8-97fe95436e50','2db739a4-16cf-4843-be53-966854c4dff1',1),('0db6e70e-f6d3-4f27-b66d-cde19881cd27','aa75cfc2-ab58-4ebc-8c88-7bc960f5035f','fff895c1-4c57-41e5-8d88-28aa05fe638a',1),('56d58ac2-3789-4448-b37e-f108840d7eca','abc3c4a4-eacf-4d01-9520-ec278b036959','e2834d4f-d9fd-4649-8e5f-fac2c5c3b44c',1),('8fa7ad4a-7d30-48c2-b760-e803c2cc354e','d796917c-f324-4ed1-9a4b-35304e1c81ac','6daac228-2951-4bfe-9d35-e7560fa8f758',2),('9198427e-1b9c-4c96-8288-04d4ae7b2be3','387ec307-712a-4960-8345-71e793f97034','8775dd1d-3bcf-4cb6-a077-d4244176bdca',1),('d96411db-5b24-4324-a850-44e7096ef0f2','aa75cfc2-ab58-4ebc-8c88-7bc960f5035f','2db739a4-16cf-4843-be53-966854c4dff1',1),('ef809702-26e6-4856-82ba-f58031d592e0','aa75cfc2-ab58-4ebc-8c88-7bc960f5035f','6daac228-2951-4bfe-9d35-e7560fa8f758',2);
/*!40000 ALTER TABLE `Order_Item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payment`
--

DROP TABLE IF EXISTS `Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payment` (
  `payment_id` char(36) NOT NULL,
  `order_id` char(36) NOT NULL,
  `transaction_id` char(36) DEFAULT NULL,
  `payment_type` varchar(255) DEFAULT NULL,
  `gross_amount` decimal(10,2) DEFAULT NULL,
  `transaction_time` timestamp NULL DEFAULT NULL,
  `settlement_time` timestamp NULL DEFAULT NULL,
  `expiry_time` timestamp NULL DEFAULT NULL,
  `transaction_status` varchar(255) DEFAULT NULL,
  `payment_link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `Payment_ibfk_1` (`order_id`),
  CONSTRAINT `Payment_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Order` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment`
--

LOCK TABLES `Payment` WRITE;
/*!40000 ALTER TABLE `Payment` DISABLE KEYS */;
INSERT INTO `Payment` VALUES ('3de81e64-bc44-47c0-a1e3-3af604b3005e','aa75cfc2-ab58-4ebc-8c88-7bc960f5035f','1cb53f2c-0962-4a31-aadc-7d7861a78709','bank_transfer',46430000.00,'2025-03-08 07:48:19','2025-03-08 07:49:03','2025-03-09 07:48:19','settlement','https://app.sandbox.midtrans.com/payment-links/390ca61c-8e02-43cc-92e4-c2330091b4ae'),('a8b90249-ad44-47b9-b5cd-a3b4f62a85d3','e86742d7-df08-4a58-91f8-97fe95436e50','61f8f156-972c-4767-89ec-57ba8b447d06','bank_transfer',12249000.00,'2025-03-07 21:22:25','2025-03-07 21:22:38','2025-03-08 21:22:25','settlement','https://app.sandbox.midtrans.com/payment-links/f2737041-e130-4a85-93ba-7e90ea74e9d2'),('c8fcaa7f-3b59-4362-a34a-a5d86a6a4245','d796917c-f324-4ed1-9a4b-35304e1c81ac','3f0c048d-698a-42c7-ad5c-5d952fce70a2','bank_transfer',33680000.00,'2025-03-08 07:40:13','2025-03-08 07:40:27','2025-03-09 07:40:13','settlement','https://app.sandbox.midtrans.com/payment-links/be8eb5bb-d5de-4594-9123-627a1fadfa1d'),('e84d9c0c-cb95-4487-9772-8be4d7def20f','387ec307-712a-4960-8345-71e793f97034','c5c58d15-2721-4d8a-ac16-d4a46a16f140','bank_transfer',15849000.00,'2025-03-07 21:23:07',NULL,'2025-03-08 21:23:07','pending','https://app.sandbox.midtrans.com/payment-links/192a9ea9-8d3c-4d69-88c8-44373546ba71');
/*!40000 ALTER TABLE `Payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Product` (
  `product_id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `images` json DEFAULT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `sold_quantity` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `Product_ibfk_1` (`user_id`),
  CONSTRAINT `Product_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
INSERT INTO `Product` VALUES ('2db739a4-16cf-4843-be53-966854c4dff1','iPhone 15 128GB Garansi Resmi Apple Indonesia - Black','NETWORK Technology\nGSM / CDMA / HSPA / EVDO / LTE / 5G\nBODY Dimensions 147.6 x 71.6 x 7.8 mm (5.81 x 2.82 x 0.31 in)\nWeight 171 g (6.03 oz)\nBuild Glass front (Corning-made glass), glass back (Corning-made glass), aluminum frame\nSIM Nano-SIM and eSIM - International\nIP68 dust/water resistant (up to 6m for 30 min)\nDISPLAY Type Super Retina XDR OLED, HDR10, Dolby Vision, 1000 nits (HBM), 2000 nits (peak)\nSize 6.1 inches, 91.3 cm2\nResolution 1179 x 2556 pixels\nProtection Ceramic Shield glass\nPLATFORM OS iOS 17, upgradable to iOS 17.1\nChipset Apple A16 Bionic (4 nm)\nCPU Hexa-core (2x3.46 GHz Everest + 4x2.02 GHz Sawtooth)\nGPU Apple GPU (5-core graphics)\nMEMORY Card slot No\nInternal 128GB 6GB RAM NVMe\nMAIN CAMERA Dual 48 MP, f/1.6, 26mm (wide), 1/1.56\", 1.0µm, dual pixel PDAF, sensor-shift OIS\n12 MP, f/2.4, 13mm, 120˚ (ultrawide)\nSELFIE CAMERA Single 12 MP, f/1.9, 23mm (wide), 1/3.6\", PDAF\nBATTERY Type Li-Ion 3349 mAh, non-removable\nCharging Wired, PD2.0, 50% in 30 min\n\n• Garansi Resmi Apple Indonesia 1 tahun\n• Not Activated\n• Dapat Di klaim disemua Service Centre Resmi Apple Indonesia.\n• IMEI terdaftar di Kemenperin\n\nPengiriman di hari yang sama untuk kota medan dengan gojek/grab.\n\nbisa dm atau langsung chat ke admin kami y gan\nWA / Telp : 085312226226\nIG: intikom.stores\n\nKenapa beli di INTIKOM :\n\n1. INTIKOM Adalah Apple Authorized Seller\n\n2. Garansi Resmi 1 tahun Apple Indonesia\n\n3. Kami hanya menjual produk Smartphone dan Laptop berGARANSI RESMI NASIONAL, Unit dan Aksesoris 100% Original dan 100% NEW.\n\n4. 14 Days Replacement, kami memberikan GARANSI 14 HARI GANTI UNIT BARU sejak pembelian, khusus produk Apple (hanya berlaku untuk kerusakan pabrikan)\n\n5. Trusted Seller yang menjual produk Gadget lengkap dari Smartphone hingga Laptop.\n\nSo, tunggu apa lagi guys, buruan order, kepuasan anda prioritas kami :)',12499000.00,93,'09f2e73f-9812-4555-8686-adcafd29e46e','[{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794003/e-commerece-pwa/yusuf%40gmail.com/products/np4bz6p1vp9jgpfcc1rf.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/np4bz6p1vp9jgpfcc1rf\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794003/e-commerece-pwa/yusuf%40gmail.com/products/blqivqhrl0eheabwiiyr.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/blqivqhrl0eheabwiiyr\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794003/e-commerece-pwa/yusuf%40gmail.com/products/bdn3qtfltnhbrnpcf3d9.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/bdn3qtfltnhbrnpcf3d9\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794003/e-commerece-pwa/yusuf%40gmail.com/products/chghgdlfvro1c5ohircy.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/chghgdlfvro1c5ohircy\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794004/e-commerece-pwa/yusuf%40gmail.com/products/d6yxbon19dktipzxnlae.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/d6yxbon19dktipzxnlae\"}]',250000.00,7,'2025-02-17 12:06:44'),('469edadc-c965-467c-8536-34ac48d808e0','POLYTRON Smart Cinemax Google TV 43 inch PLD 43BG9058','\"Smart Google TV dengan Garansi 5 Tahun dan dilengkapi dengan FREE 12 Bulan langganan Mola dan 6 bulan langganan Vidio Platinum\n\nMendukung aplikasi popular seperti Youtube, Netflix, Disney+ Hotstar dan lainnya yang dapat diunduh pada google play store.\"\n\"- Garansi 5 Tahun (Pelopor LED TV dengan garansi 5 Tahun, termasuk PANEL LED)\n- Digital TV (DVB-T2) : gambar lebih jernih dan tidak berbayang\n- DIPE Engine : menghasilkan detail dan ketajaman gambar sebenarnya\n- Google TV OS with Mola TV, YouTube, Vidio, Prime Video\n- USB Play Movie : Movie, MP3, Jpeg\"',3999000.00,66,'09f2e73f-9812-4555-8686-adcafd29e46e','[{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416741/e-commerece-pwa/yusuf%40gmail.com/products/zjbzn7hbfkp4lfv99et2.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/zjbzn7hbfkp4lfv99et2\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416742/e-commerece-pwa/yusuf%40gmail.com/products/wnoy5auycldxbktvjdd0.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/wnoy5auycldxbktvjdd0\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416741/e-commerece-pwa/yusuf%40gmail.com/products/xpniw4uevx0gxbcguumr.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/xpniw4uevx0gxbcguumr\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416742/e-commerece-pwa/yusuf%40gmail.com/products/njkk2pubarncyx0asvur.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/njkk2pubarncyx0asvur\"}]',450000.00,0,'2025-03-08 06:52:22'),('6daac228-2951-4bfe-9d35-e7560fa8f758','DJI Mini 4 Pro Combo (DJI RC 2) - Camera Drone','Sensor 1/1.3-inch CMOS\n4K/60fps HDR True Vertical Shooting\nOmnidirectional Obstacle Sensing untuk pelacakan yang stabil\n20km FHD Video Transmission\nFitur ActiveTrack 360°\nDilengkapi Advanced Pilot Assistance Systems (APAS) untuk keamanan tambahan\n\nKamera\nImage Sensor\n1/1.3-inch CMOS, Effective Pixels: 48 MP\n\nAircraft\nTakeoff Weight\n< 249 g\nStandard aircraft weight (including the Intelligent Flight Battery, propellers, and a microSD card).\n\nDimensions\nFolded (without propellers): 148×94×64 mm (L×W×H)\nUnfolded (with propellers): 298×373×101 mm (L×W×H)\n\nMax Ascent Speed\n5 m/s (S Mode)\n5 m/s (N Mode)\n3 m/s (C Mode)\n\nGimbal\nStabilization\n3-axis mechanical gimbal (tilt, roll, pan)\n\nMechanical Range\nTilt: -135° to 80°\nRoll: -135° to 45°\nPan: -30° to 30°\n\nControllable Range\nTilt: -90° to 60°\nRoll: -90° or 0°\n\nBaterai\nCompatible Battery\nDJI Mini 4 Pro Intelligent Flight Battery, DJI Mini 3 Series Intelligent Flight Battery Plus\n\nCapacity\nIntelligent Flight Battery: 2590 mAh\nIntelligent Flight Battery Plus: 3850 mAh\n\nWeight\nIntelligent Flight Battery: approx. 77.9 g\nIntelligent Flight Battery Plus: approx. 121 g\n\nNominal Voltage\nIntelligent Flight Battery: 7.32 V\nIntelligent Flight Battery Plus: 7.38 V\n\nRecommended Charger\nDJI 30W USB-C Charger or other USB Power Delivery chargers (30 W)\n\nKelengkapan di dalam dus :\nDJI Mini 4 Pro x1\nDJI RC 2 Remote Controller x1\nIntelligent Flight Battery x3\nTwo-Way Charging Hub x1\nShoulder Bag x1\nUSB-C Cable x1\nSpare Propellers (Pair) x3\nScrews x18\nScrewdriver x1\nType-C to Type-C PD Cable x1\nGimbal Protector x1\nPropeller Holder x1\n\nDapatkan poin MyEraspace setiap pembelian di \"DJI Official Store\" dengan cara berikut:\n1. Daftar menjadi member atau Login di eraspace.com\n2. Kunjungi eraspace.com/myeraspace/claim-transaction, lalu pilih Klaim Transaksi\n3. Masukkan No Invoice dari Tokopedia\nNote : Alamat email yang digunakan untuk transaksi di \"DJI Official Store\" harus sama dengan email yang didaftarkan di MyEraspace.',17090000.00,46,'09f2e73f-9812-4555-8686-adcafd29e46e','[{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741417015/e-commerece-pwa/yusuf%40gmail.com/products/c1mmsjd49rsfxkqpfazx.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/c1mmsjd49rsfxkqpfazx\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741417014/e-commerece-pwa/yusuf%40gmail.com/products/wakbvjcf1xl3q7zbt8zx.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/wakbvjcf1xl3q7zbt8zx\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741417015/e-commerece-pwa/yusuf%40gmail.com/products/ltjcb37x5evj0w2sb9kq.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/ltjcb37x5evj0w2sb9kq\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741417015/e-commerece-pwa/yusuf%40gmail.com/products/ew66jft9hy7edn4m9wnx.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/ew66jft9hy7edn4m9wnx\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741417015/e-commerece-pwa/yusuf%40gmail.com/products/wyrmluwapoyuzjvxhl1k.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/wyrmluwapoyuzjvxhl1k\"}]',250000.00,4,'2025-03-08 06:56:57'),('8775dd1d-3bcf-4cb6-a077-d4244176bdca','Macbook Pro M10 Edan Parah','Garansi Resmi Apple Indonesia 1 Tahun\n\n100% Original Baru dan Segel Pabrik Apple\n\nUntuk Apple Macbook Resmi Indonesia Model Number ID/A kode Negara indonesia dan Charger Standard Indonesia , dapat di klaim Garansi di Seluruh Apple Resmi di Indonesia iBox / Digimap / Story-i / QCD / Apple Resmi lainnya\n\nSpesifikasi M3 8/256 GB :\n\nChip Apple M3\n\nCPU 8‑core dengan 4 core performa dan 4 core efisiensi\nGPU 8‑core\nNeural Engine 16‑core\n\nMemori terintegrasi 8 GB\nPenyimpanan SSD 256 GB\n\nBaterai dan Daya\nBaterai lithium-polymer 52,6 watt-jam\nAdaptor Daya USB‑C 30 W (disertakan pada M3 dengan GPU 8‑core)\n\nSpesifikasi M3 8/512 GB :\n\nChip Apple M3\n\nCPU 8‑core dengan 4 core performa dan 4 core efisiensi\nGPU 10‑core\nNeural Engine 16‑core\n\nMemori terintegrasi 8 GB\nPenyimpanan SSD 512 GB\n\nBaterai dan Daya\nBaterai lithium-polymer 52,6 watt-jam\nAdaptor Daya Port USB‑C Ganda 35 W (disertakan pada M3 dengan GPU 10‑core)\n\nSpesifikasi M3 16/512 GB :\n\nChip Apple M3\n\nCPU 8‑core dengan 4 core performa dan 4 core efisiensi\nGPU 10‑core\nNeural Engine 16‑core\n\nMemori terintegrasi 16 GB\nPenyimpanan SSD 512 GB\n\nBaterai dan Daya\nBaterai lithium-polymer 52,6 watt-jam\nAdaptor Daya Port USB‑C Ganda 35 W (disertakan pada M3 dengan GPU 10‑core)\n\nSpesifikasi M3 16/256 GB :\n\nChip Apple M3\n\nCPU 8‑core dengan 4 core performa dan 4 core efisiensi\nGPU 8‑core\nNeural Engine 16‑core\n\nMemori terintegrasi 16 GB\nPenyimpanan SSD 256 GB\n\nBaterai dan Daya\nBaterai lithium-polymer 52,6 watt-jam\nAdaptor Daya USB‑C 30 W (disertakan pada M3 dengan GPU 8‑core)\n\nSpesifikasi M3 24/512 GB :\n\nChip Apple M3\n\nCPU 8‑core dengan 4 core performa dan 4 core efisiensi\nGPU 10‑core\nNeural Engine 16‑core\n\nMemori terintegrasi 24 GB\nPenyimpanan SSD 512 GB\n\nBaterai dan Daya\nBaterai lithium-polymer 52,6 watt-jam\nAdaptor Daya Port USB‑C Ganda 35 W (disertakan pada M3 dengan GPU 10‑core)\n\nLayar\nLayar Liquid Retina\n\nLayar 13,6 inci (diagonal) dengan lampu latar LED dan teknologi IPS;1\nresolusi bawaan 2560 x 1664 pada 224 piksel per inci\nKecerahan 500 nit\n\nWarna\n\nMendukung 1 miliar warna\nWarna luas (P3)\nTeknologi True Tone\n\nPengisian Daya dan Ekspansi\nPort pengisian daya MagSafe 3\n\nJek headphone 3,5 mm\n\nDua port Thunderbolt/USB 4 dengan dukungan untuk:\n\nPengisian daya\nDisplayPort\nThunderbolt 3 (hingga 40 Gb/dtk)\nUSB 4 (hingga 40 Gb/dtk)\n\nDukungan Layar\nM3\n\nSecara bersamaan mendukung resolusi asli penuh pada layar bawaan dalam 1 miliar warna dan:\nSatu layar eksternal dengan resolusi hingga 6K pada kecepatan 60 Hz\nTutup layar MacBook Air untuk menggunakan layar eksternal kedua dengan resolusi hingga 5K pada 60 Hz\n\nNirkabel\n\nWi‑Fi 6E (802.11ax)4\nBluetooth 5.3\n\nKamera\nKamera FaceTime HD 1080p\nProsesor sinyal gambar canggih menggunakan video komputasional\n\nUkuran dan Berat\nTebal: 1,13 cm\nPanjang: 30,41 cm\nLebar: 21,5 cm\nBerat: 1,24 kg5',16349000.00,100,'09f2e73f-9812-4555-8686-adcafd29e46e','[{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794152/e-commerece-pwa/yusuf%40gmail.com/products/a0hs1tho1h4gj5weiepi.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/a0hs1tho1h4gj5weiepi\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794151/e-commerece-pwa/yusuf%40gmail.com/products/ciqriphggott1sshvhrq.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/ciqriphggott1sshvhrq\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794152/e-commerece-pwa/yusuf%40gmail.com/products/v5pyr8eqox5alxisdhw1.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/v5pyr8eqox5alxisdhw1\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794153/e-commerece-pwa/yusuf%40gmail.com/products/or9ofvs0sxzwfim0kltf.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/or9ofvs0sxzwfim0kltf\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794154/e-commerece-pwa/yusuf%40gmail.com/products/xqxabeyqtc0b3npsojcu.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/xqxabeyqtc0b3npsojcu\"}]',500000.00,0,'2025-02-17 12:09:17'),('e2834d4f-d9fd-4649-8e5f-fac2c5c3b44c','SONY WH-1000XM5 Smoky Pink Wireless Noise Cancelling Headphone / WH1000XM5','The Best Noise Cancelling Headphones\nDua prosesor mengendalikan 8 mikrofon untuk noise cancelling yang belum pernah terjadi sebelumnya. Dengan Auto NC Optimizer, Noise Cancelling secara otomatis dioptimalkan berdasarkan kondisi penggunaan dan lingkungan Anda.\n\nMagnificent Sound\nDirancang dengan sempurna dengan Integrated Processor V1 yang baru. Menghasilkan kualitas suara yang clear dan balance.\n\nCrystal clear hands-free calling\nDengan 4 mikrofon beamforming, pengambilan suara yang tepat, dan pemrosesan sinyal audio yang canggih.\n\nUp to 30-hour battery life\nAnda dapat menikmati daya hingga 30 jam pada headphone Anda setiap kali Anda meninggalkan rumah. Dan, demi kenyamanan Anda, pengisian cepat 3 menit akan memberi Anda waktu playback hingga 60 menit.\n\nGeneral Features\nDRIVER UNIT: 30mm\nIMPEDANCE (OHM): 48 ohm(1kHz) (when connecting via the headphone cable with the unit turned on) , 16 ohm(1kHz) (when connecting via the headphone cable with the unit turned off)\nFREQUENCY RESPONSE: 4 Hz - 40,000 Hz (JEITA)\nFREQUENCY RESPONSE (ACTIVE OPERATION): 4 Hz - 40,000 Hz\nSENSITIVITIES (DB/MW):102dB(1kHz) / mW (when connecting via the headphone cable with the unit turned on) , 100dB / mW(1kHz) (when connecting via the headphone cable with the unit turned off)\nVOLUME CONTROL: Touch Sensor\nCORD TYPE: Single-sided (detachable)\nCORD LENGTH: approx. 1.2m\nWEARING STYLE: Over Ear\nDSEE EXTREME: Yes\nPASSIVE OPERATION: Yes\nAMBIENT SOUND MODE: Yes\n\nBattery\nBATTERY CHARGE TIME: Approx. 3.5 hrs\nBATTERY LIFE(CONTINUOUS MUSIC PLAYBACK TIME): Max. 30 hrs (NC ON) , Max. 40 hrs (NC OFF)\nBATTERY LIFE(CONTINUOUS COMMUNICATION TIME): Max. 24 hrs (NC ON) , Max. 32 hrs (NC OFF)\n\nBluetooth Specification\nBLUETOOTH VERSION: Version5.2\nEFFECTIVE RANGE: 10m\nFREQUENCY RANGE: 2.4GHz band (2.4000GHz-2.4835GHz)\n\nWhat\'s In The Box\nCarrying Case\nConnection Cable\nUSB Cable',4599000.00,60,'09f2e73f-9812-4555-8686-adcafd29e46e','[{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416588/e-commerece-pwa/yusuf%40gmail.com/products/kgmo07gguuqvx7lgogmk.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/kgmo07gguuqvx7lgogmk\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416587/e-commerece-pwa/yusuf%40gmail.com/products/yrsbx3n9xu1cr399y6g7.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/yrsbx3n9xu1cr399y6g7\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416587/e-commerece-pwa/yusuf%40gmail.com/products/jk2cedzlrrpwchzj0mxo.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/jk2cedzlrrpwchzj0mxo\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416588/e-commerece-pwa/yusuf%40gmail.com/products/g9xahg0qcefqi2izfazn.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/g9xahg0qcefqi2izfazn\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1741416588/e-commerece-pwa/yusuf%40gmail.com/products/mzockgvzapbyz9cybxio.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/mzockgvzapbyz9cybxio\"}]',1000000.00,0,'2025-03-08 06:49:49'),('fff895c1-4c57-41e5-8d88-28aa05fe638a','Labubu X Coca Cola Pendant Original','Labubu X Coca Cola Pendant (Special Edition)\n\nReady Stock Siap Kirim\nOriginal 100% Pop Mart\nBuka Box Hanya Lihat Kartu',1000000.00,99,'09f2e73f-9812-4555-8686-adcafd29e46e','[{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794566/e-commerece-pwa/yusuf%40gmail.com/products/r8esg19p2kryy3zqgjtb.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/r8esg19p2kryy3zqgjtb\"}, {\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739794566/e-commerece-pwa/yusuf%40gmail.com/products/gyuv3gchqyd12lyq1yyf.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/products/gyuv3gchqyd12lyq1yyf\"}]',499000.00,1,'2025-02-17 12:16:07');
/*!40000 ALTER TABLE `Product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product_Category`
--

DROP TABLE IF EXISTS `Product_Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Product_Category` (
  `product_id` char(36) NOT NULL,
  `category_id` char(36) NOT NULL,
  PRIMARY KEY (`product_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `Product_Category_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `Product_Category_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `Category` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product_Category`
--

LOCK TABLES `Product_Category` WRITE;
/*!40000 ALTER TABLE `Product_Category` DISABLE KEYS */;
INSERT INTO `Product_Category` VALUES ('2db739a4-16cf-4843-be53-966854c4dff1','5e991e67-caa4-11ef-818b-0242ac120003'),('8775dd1d-3bcf-4cb6-a077-d4244176bdca','5e991e67-caa4-11ef-818b-0242ac120003'),('6daac228-2951-4bfe-9d35-e7560fa8f758','732ec68e-0b32-47d8-93e2-6bc5085f8b2d'),('2db739a4-16cf-4843-be53-966854c4dff1','b33ccc9b-ec0a-4547-ae45-4e1781d28cea'),('469edadc-c965-467c-8536-34ac48d808e0','b33ccc9b-ec0a-4547-ae45-4e1781d28cea'),('6daac228-2951-4bfe-9d35-e7560fa8f758','b33ccc9b-ec0a-4547-ae45-4e1781d28cea'),('8775dd1d-3bcf-4cb6-a077-d4244176bdca','b33ccc9b-ec0a-4547-ae45-4e1781d28cea'),('e2834d4f-d9fd-4649-8e5f-fac2c5c3b44c','b33ccc9b-ec0a-4547-ae45-4e1781d28cea'),('fff895c1-4c57-41e5-8d88-28aa05fe638a','e71e59ca-ed28-11ef-ad99-0242ac120002');
/*!40000 ALTER TABLE `Product_Category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Review`
--

DROP TABLE IF EXISTS `Review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Review` (
  `review_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Review_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `Review_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `Review_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
/*!40000 ALTER TABLE `Review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Shipping`
--

DROP TABLE IF EXISTS `Shipping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Shipping` (
  `shipping_id` char(36) NOT NULL,
  `order_id` char(36) NOT NULL,
  `address_id` char(36) NOT NULL,
  `shipping_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delivery_date` timestamp NULL DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `payment_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`shipping_id`),
  KEY `order_id` (`order_id`),
  KEY `address_id` (`address_id`),
  KEY `fk_shipping_payment` (`payment_id`),
  CONSTRAINT `fk_shipping_payment` FOREIGN KEY (`payment_id`) REFERENCES `Payment` (`payment_id`) ON DELETE CASCADE,
  CONSTRAINT `Shipping_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Order` (`order_id`),
  CONSTRAINT `Shipping_ibfk_2` FOREIGN KEY (`address_id`) REFERENCES `Address` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Shipping`
--

LOCK TABLES `Shipping` WRITE;
/*!40000 ALTER TABLE `Shipping` DISABLE KEYS */;
/*!40000 ALTER TABLE `Shipping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `user_id` char(36) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `role` enum('admin','user','seller') DEFAULT 'user',
  `refresh_token` text,
  `verified_email` tinyint(1) DEFAULT '0',
  `phone_number` varchar(20) DEFAULT NULL,
  `verified_phone_number` tinyint(1) NOT NULL DEFAULT '0',
  `surename` varchar(255) DEFAULT NULL,
  `avatar` json DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('09f2e73f-9812-4555-8686-adcafd29e46e','Yusuf Cendol','yusuf@gmail.com','$2b$10$Ykwp0zZupm6NxTP9LAyxh.DvXrpMRxgHqBtz5Nv8ObHxsFSGSN/bK','2024-12-30 13:17:17','seller','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA5ZjJlNzNmLTk4MTItNDU1NS04Njg2LWFkY2FmZDI5ZTQ2ZSIsImVtYWlsIjoieXVzdWZAZ21haWwuY29tIiwicm9sZSI6InNlbGxlciIsImlhdCI6MTc0MTQxNjk5OSwiZXhwIjoxNzQyMDIxNzk5fQ.JIVmY5FdB00bDhJWfzw1fJar44ZkRcBuppSmBYdb654',0,NULL,0,NULL,'{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739796139/e-commerece-pwa/yusuf%40gmail.com/q9dzum2vi4nmjrbnu79z.jpg\", \"public_id\": \"e-commerece-pwa/yusuf@gmail.com/q9dzum2vi4nmjrbnu79z\"}'),('170188f0-157b-4945-a87d-18f25d433d60','Yusuf Backup','yusufbackupwa@gmail.com','$2b$10$0yksRLGA3kCp8429GMwQOOv9rKE1LVWJsejQI5UpDM64o5TZd.lQe','2025-01-01 15:44:47','seller','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE3MDE4OGYwLTE1N2ItNDk0NS1hODdkLTE4ZjI1ZDQzM2Q2MCIsImVtYWlsIjoieXVzdWZiYWNrdXB3YUBnbWFpbC5jb20iLCJyb2xlIjoic2VsbGVyIiwiaWF0IjoxNzM2Njk5NzEzLCJleHAiOjE3MzczMDQ1MTN9.to9oAyrm8nb65DM3FM1tpAV4f7_3r_eKVfkrNpavPK8',0,NULL,0,NULL,NULL),('31bcece8-2398-4092-bee6-d0dbe129eed1','admin','admin@gmail.com','$2b$10$0yksRLGA3kCp8429GMwQOOv9rKE1LVWJsejQI5UpDM64o5TZd.lQe','2024-12-30 14:21:06','admin','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMxYmNlY2U4LTIzOTgtNDA5Mi1iZWU2LWQwZGJlMTI5ZWVkMSIsImVtYWlsIjoiYWRtaW5AZ21haWwuY29tIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzQxNDIxMjgzLCJleHAiOjE3NDIwMjYwODN9.WoHpdFalREWepvrncJ5u3Y5-_gLcjJYGWTEb7ydqFF8',0,NULL,0,NULL,NULL),('9099029b-00ad-4378-b42b-930f9b09e120','yusuf Buyyer','yusuffauziyan@gmail.com','$2b$10$0yksRLGA3kCp8429GMwQOOv9rKE1LVWJsejQI5UpDM64o5TZd.lQe','2025-01-01 07:22:00','user','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjkwOTkwMjliLTAwYWQtNDM3OC1iNDJiLTkzMGY5YjA5ZTEyMCIsImVtYWlsIjoieXVzdWZmYXV6aXlhbkBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc0MTM1MDI4NSwiZXhwIjoxNzQxOTU1MDg1fQ.PPrGlfjBLeVrVb8bedsoKcvQ5ZYuc5zjuCCTzT7eMdA',NULL,'+6289658043193',1,'Joko Frangky','{\"url\": \"https://res.cloudinary.com/dtowni8oi/image/upload/v1739809932/e-commerece-pwa/yusuffauziyan%40gmail.com/pivpaijwxincxwizz4jd.jpg\", \"public_id\": \"e-commerece-pwa/yusuffauziyan@gmail.com/pivpaijwxincxwizz4jd\"}'),('a892bee1-d92a-453a-9b95-b2a47f41c2a3','test','test@gmail.com','$2b$10$gHoBXwuEIJf.Y12xf1RGAeyEHEVU0dYRTp39ZNShlTENcvBZ2H1g.','2025-01-05 14:45:17','user',NULL,NULL,NULL,0,NULL,NULL);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-08  9:31:01
