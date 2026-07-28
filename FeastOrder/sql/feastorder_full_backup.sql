-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: feastorder_db
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Appetizers','Small plates to start the meal'),(2,'Main Courses','Hearty, made-to-order mains'),(3,'Desserts','Sweet finishes to every meal'),(4,'Beverages','Cocktails and coffee-based drinks');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `ingredients` text,
  `addon_options` varchar(500) DEFAULT NULL,
  `nutritional_info` varchar(255) DEFAULT NULL,
  `price` decimal(8,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `rating` decimal(2,1) NOT NULL DEFAULT '0.0',
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`item_id`),
  KEY `fk_menu_items_category` (`category_id`),
  CONSTRAINT `fk_menu_items_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (1,1,'Spring Rolls','Crispy rolls with cabbage, carrot, glass noodles','Cabbage:0.15 kg, Carrot:0.1 kg, Glass noodles:0.1 kg, Spring roll wrapper:6 pcs','Extra Dipping Sauce, 2 Extra Rolls, Add Drink','210 kcal, 6g fat, 28g carbs',5.90,'image/FO_springRoll.jpg',4.5,1),(2,1,'Garden Salad Bites','Fresh mixed greens, cherry tomato, avocado, citrus vinaigrette','Mixed greens:120 g, Cherry tomato:60 g, Avocado:0.5 pc, Citrus vinaigrette:30 ml','Extra Avocado, Add Grilled Chicken, Dressing on the Side','150 kcal, 8g fat, 12g carbs',7.50,'image/FO_appetizer.jpg',4.6,1),(3,1,'Chicken Satay Skewers','Grilled marinated chicken skewers, peanut sauce, cucumber relish','Chicken thigh:180 g, Peanut sauce:60 ml, Cucumber relish:40 g, Skewer sticks:6 pcs','Extra Peanut Sauce, 2 Extra Skewers, Add Drink','260 kcal, 14g fat, 9g carbs',8.90,'image/menu_chickenSatay.jpg',4.7,1),(4,2,'Grilled Chicken Rice','Grilled chicken thigh, jasmine rice, side salad','Chicken thigh:200 g, Jasmine rice:200 g, Side salad:80 g','Extra Rice, Extra Chicken, Add Fried Egg','480 kcal, 16g fat, 52g carbs',12.90,'image/FO_grilledChickenRice.jpg',4.7,1),(5,2,'Beef Burger','Beef patty, cheddar, lettuce, tomato, brioche bun','Beef patty:150 g, Cheddar:1 slice, Lettuce:20 g, Tomato:2 slices, Brioche bun:1 pc','Extra Cheese, Add Bacon, Add Egg, Make it a Double','620 kcal, 34g fat, 41g carbs',11.50,'image/FO_beefBurger.jpg',4.6,1),(6,2,'Signature Chef\'s Platter','Chef\'s daily selection of grilled meats, roasted vegetables, jus','Mixed grilled meats:250 g, Roasted vegetables:120 g, Jus:50 ml','Extra Meat Selection, Extra Vegetables, Add Garlic Bread','710 kcal, 38g fat, 45g carbs',18.90,'image/FO_mainCourse.jpg',4.8,1),(7,2,'Butter Garlic Prawn Pasta','Linguine tossed in butter garlic sauce with pan-seared prawns','Linguine:200 g, Prawns:120 g, Butter garlic sauce:80 ml, Parsley:5 g','Extra Prawns, Extra Sauce, Add Parmesan','590 kcal, 22g fat, 68g carbs',16.50,'image/menu_butterGarlic.jpg',4.7,1),(8,2,'Herb-Roasted Salmon','Oven-roasted salmon fillet, lemon butter sauce, seasonal greens','Salmon fillet:180 g, Lemon butter sauce:60 ml, Seasonal greens:100 g','Extra Salmon, Extra Sauce, Add Mashed Potato','540 kcal, 28g fat, 12g carbs',21.00,'image/menu_roastedSalmon.jpg',4.9,1),(9,3,'Chocolate Lava Cake','Warm chocolate cake with molten center','Chocolate cake batter:150 g, Molten chocolate center:40 g, Vanilla ice cream:1 scoop','Add Vanilla Ice Cream, Add Berry Compote, Extra Molten Center','390 kcal, 19g fat, 46g carbs',6.90,'image/FeastOrder_chocoLava.jpg',4.8,1),(10,3,'Classic Tiramisu','Espresso-soaked sponge, mascarpone cream, cocoa dust','Espresso-soaked sponge:120 g, Mascarpone cream:80 g, Cocoa dust:5 g','Extra Espresso Shot, Add Chocolate Shavings','420 kcal, 24g fat, 38g carbs',7.50,'image/FO_dessert.jpg',4.7,1),(11,3,'Mango Sticky Rice','Sweet glutinous rice, fresh mango, coconut cream','Glutinous rice:150 g, Fresh mango:1 pc, Coconut cream:60 ml','Extra Mango, Extra Coconut Cream','350 kcal, 9g fat, 62g carbs',6.50,'image/menu_mangoSticky.jpg',4.6,1),(12,3,'New York Cheesecake','Baked cheesecake, berry compote, buttery biscuit base','Baked cheesecake:150 g, Berry compote:50 g, Biscuit base:1 layer','Extra Berry Compote, Add Whipped Cream','460 kcal, 26g fat, 44g carbs',7.90,'image/menu_nyCheesecake.jpg',4.8,1),(13,3,'Creme Brulee','Silky vanilla custard, caramelized sugar crust','Vanilla custard:150 g, Caramelized sugar crust:10 g','Extra Sugar Crust, Add Fresh Berries','380 kcal, 27g fat, 24g carbs',7.20,'image/menu_cremeBrulee.jpg',4.7,1),(14,4,'Aperol Spritz','Italy\'s most iconic aperitivo - bittersweet Aperol topped with chilled Prosecco and a splash of soda, poured over ice and finished with a fresh orange slice.','Aperol:45 ml, Prosecco:90 ml, Soda water:30 ml, Orange slice:1 pc','Extra Orange Garnish, Make it a Double','Contains alcohol. Must be of legal drinking age to order.',28.00,'image/menu_aperolSpritz.jpg',4.8,1),(15,4,'Espresso Martini','Vodka shaken hard with coffee liqueur and a fresh shot of espresso until dark, rich, and topped with a silky crema.','Vodka:45 ml, Coffee liqueur:20 ml, Fresh espresso:1 shot','Extra Espresso Shot, Make it a Double','Contains alcohol and caffeine. Must be of legal drinking age to order.',32.00,'image/menu_espressoMartini.jpg',4.9,1),(16,4,'Bellini','Chilled Prosecco poured gently over silky white peach puree - a Venetian classic invented at Harry\'s Bar in 1948.','Prosecco:100 ml, White peach puree:40 ml','Extra Peach Puree, Make it a Double','Contains alcohol. Must be of legal drinking age to order.',26.00,'image/menu_bellini.jpg',4.7,1),(17,4,'Negroni','Equal parts gin, Campari, and sweet vermouth, stirred slowly over ice and finished with an orange twist.','Gin:30 ml, Campari:30 ml, Sweet vermouth:30 ml, Orange twist:1 pc','Extra Orange Twist, Make it a Double','Contains alcohol. Must be of legal drinking age to order.',30.00,'image/menu_negroni.jpg',4.6,1),(18,4,'Affogato al Caffe','A generous scoop of vanilla gelato \"drowned\" tableside in a hot shot of espresso - dessert and coffee in one glass.','Vanilla gelato:2 scoops, Hot espresso:1 shot','Extra Espresso Shot, Extra Gelato Scoop','Contains dairy and caffeine.',14.00,'image/menu_affogato.jpg',4.9,1);
/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `quantity` int NOT NULL,
  `add_ons` varchar(255) DEFAULT NULL,
  `subtotal` decimal(8,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `fk_order_items_order` (`order_id`),
  KEY `fk_order_items_menu_item` (`item_id`),
  CONSTRAINT `fk_order_items_menu_item` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,2,'Garden Salad Bites',1,'',7.50),(2,2,1,'Spring Rolls',1,'',5.90),(3,2,2,'Garden Salad Bites',1,'',7.50);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'PENDING',
  `order_type` varchar(20) NOT NULL DEFAULT 'Pickup',
  `delivery_address` varchar(255) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `order_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `fk_orders_user` (`user_id`),
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,7.50,'PENDING','Pickup',NULL,'','2026-07-11 23:40:09'),(2,1,13.40,'PENDING','Pickup',NULL,'','2026-07-11 23:40:21');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'ADMIN','FeastOrder','feastorder@gmail.com','pxl3U+tbWwodPsuN8AXN9Q==:C3iSOZhwpIRVLziZfNj/IJzlv6QqTGbrc9+wSSklwAo=','+60123456789','admin','2026-07-11 23:06:47'),(2,'CUSTOMER','KevinMH','kevin@gmail.com','iCL8vrypFb6yZ+zqoOlotw==:I1aWYwVJD0/yDoy78er0OA6nyAcoiQj3in5A6G1Kb7E=','+6023456789','customer','2026-07-11 23:19:05');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-12 15:40:14
