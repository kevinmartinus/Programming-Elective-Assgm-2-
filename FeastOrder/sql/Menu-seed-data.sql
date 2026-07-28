-- ======================================================================
-- FeastOrder — Menu seed data
-- 4 categories, 18 menu items (3 Appetizers, 5 Main Courses, 5 Desserts,
-- 5 Beverages) also addition by admin
-- ======================================================================
USE feastorder_db;

ALTER TABLE menu_items
    ADD COLUMN IF NOT EXISTS ingredients TEXT AFTER description,
    ADD COLUMN IF NOT EXISTS addon_options VARCHAR(500) AFTER ingredients;

-- Categories --
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Appetizers',   'Small plates to start the meal'),
(2, 'Main Courses', 'Hearty, made-to-order mains'),
(3, 'Desserts',     'Sweet finishes to every meal'),
(4, 'Beverages',    'Cocktails and coffee-based drinks')
ON DUPLICATE KEY UPDATE category_name = category_name;

-- Appetizers --
INSERT INTO menu_items
    (item_id, name, description, ingredients, addon_options, nutritional_info, price, category_id, image_url, is_available, rating) VALUES
(1, 'Spring Rolls',
    'Crispy rolls with cabbage, carrot, glass noodles',
    'Cabbage:0.15 kg, Carrot:0.1 kg, Glass noodles:0.1 kg, Spring roll wrapper:6 pcs',
    'Extra Dipping Sauce, 2 Extra Rolls, Add Drink',
    '210 kcal, 6g fat, 28g carbs',
    5.90, 1, 'image/FO_springRoll.jpg', TRUE, 4.5),

(2, 'Garden Salad Bites',
    'Fresh mixed greens, cherry tomato, avocado, citrus vinaigrette',
    'Mixed greens:120 g, Cherry tomato:60 g, Avocado:0.5 pc, Citrus vinaigrette:30 ml',
    'Extra Avocado, Add Grilled Chicken, Dressing on the Side',
    '150 kcal, 8g fat, 12g carbs',
    7.50, 1, 'image/FO_appetizer.jpg', TRUE, 4.6),

(3, 'Chicken Satay Skewers',
    'Grilled marinated chicken skewers, peanut sauce, cucumber relish',
    'Chicken thigh:180 g, Peanut sauce:60 ml, Cucumber relish:40 g, Skewer sticks:6 pcs',
    'Extra Peanut Sauce, 2 Extra Skewers, Add Drink',
    '260 kcal, 14g fat, 9g carbs',
    8.90, 1, 'image/menu_chickenSatay.jpg', TRUE, 4.7)
ON DUPLICATE KEY UPDATE
    ingredients = VALUES(ingredients),
    addon_options = VALUES(addon_options);

-- Main Courses --
INSERT INTO menu_items
    (item_id, name, description, ingredients, addon_options, nutritional_info, price, category_id, image_url, is_available, rating) VALUES
(4, 'Grilled Chicken Rice',
    'Grilled chicken thigh, jasmine rice, side salad',
    'Chicken thigh:200 g, Jasmine rice:200 g, Side salad:80 g',
    'Extra Rice, Extra Chicken, Add Fried Egg',
    '480 kcal, 16g fat, 52g carbs',
    12.90, 2, 'image/FO_grilledChickenRice.jpg', TRUE, 4.7),

(5, 'Beef Burger',
    'Beef patty, cheddar, lettuce, tomato, brioche bun',
    'Beef patty:150 g, Cheddar:1 slice, Lettuce:20 g, Tomato:2 slices, Brioche bun:1 pc',
    'Extra Cheese, Add Bacon, Add Egg, Make it a Double',
    '620 kcal, 34g fat, 41g carbs',
    11.50, 2, 'image/FO_beefBurger.jpg', TRUE, 4.6),

(6, 'Signature Chef''s Platter',
    'Chef''s daily selection of grilled meats, roasted vegetables, jus',
    'Mixed grilled meats:250 g, Roasted vegetables:120 g, Jus:50 ml',
    'Extra Meat Selection, Extra Vegetables, Add Garlic Bread',
    '710 kcal, 38g fat, 45g carbs',
    18.90, 2, 'image/FO_mainCourse.jpg', TRUE, 4.8),

(7, 'Butter Garlic Prawn Pasta',
    'Linguine tossed in butter garlic sauce with pan-seared prawns',
    'Linguine:200 g, Prawns:120 g, Butter garlic sauce:80 ml, Parsley:5 g',
    'Extra Prawns, Extra Sauce, Add Parmesan',
    '590 kcal, 22g fat, 68g carbs',
    16.50, 2, 'image/menu_butterGarlic.jpg', TRUE, 4.7),

(8, 'Herb-Roasted Salmon',
    'Oven-roasted salmon fillet, lemon butter sauce, seasonal greens',
    'Salmon fillet:180 g, Lemon butter sauce:60 ml, Seasonal greens:100 g',
    'Extra Salmon, Extra Sauce, Add Mashed Potato',
    '540 kcal, 28g fat, 12g carbs',
    21.00, 2, 'image/menu_roastedSalmon.jpg', TRUE, 4.9)
ON DUPLICATE KEY UPDATE
    ingredients = VALUES(ingredients),
    addon_options = VALUES(addon_options);

-- Desserts --
INSERT INTO menu_items
    (item_id, name, description, ingredients, addon_options, nutritional_info, price, category_id, image_url, is_available, rating) VALUES
(9, 'Chocolate Lava Cake',
    'Warm chocolate cake with molten center',
    'Chocolate cake batter:150 g, Molten chocolate center:40 g, Vanilla ice cream:1 scoop',
    'Add Vanilla Ice Cream, Add Berry Compote, Extra Molten Center',
    '390 kcal, 19g fat, 46g carbs',
    6.90, 3, 'image/FeastOrder_chocoLava.jpg', TRUE, 4.8),

(10, 'Classic Tiramisu',
    'Espresso-soaked sponge, mascarpone cream, cocoa dust',
    'Espresso-soaked sponge:120 g, Mascarpone cream:80 g, Cocoa dust:5 g',
    'Extra Espresso Shot, Add Chocolate Shavings',
    '420 kcal, 24g fat, 38g carbs',
    7.50, 3, 'image/FO_dessert.jpg', TRUE, 4.7),

(11, 'Mango Sticky Rice',
    'Sweet glutinous rice, fresh mango, coconut cream',
    'Glutinous rice:150 g, Fresh mango:1 pc, Coconut cream:60 ml',
    'Extra Mango, Extra Coconut Cream',
    '350 kcal, 9g fat, 62g carbs',
    6.50, 3, 'image/menu_mangoSticky.jpg', TRUE, 4.6),

(12, 'New York Cheesecake',
    'Baked cheesecake, berry compote, buttery biscuit base',
    'Baked cheesecake:150 g, Berry compote:50 g, Biscuit base:1 layer',
    'Extra Berry Compote, Add Whipped Cream',
    '460 kcal, 26g fat, 44g carbs',
    7.90, 3, 'image/menu_nyCheesecake.jpg', TRUE, 4.8),

(13, 'Creme Brulee',
    'Silky vanilla custard, caramelized sugar crust',
    'Vanilla custard:150 g, Caramelized sugar crust:10 g',
    'Extra Sugar Crust, Add Fresh Berries',
    '380 kcal, 27g fat, 24g carbs',
    7.20, 3, 'image/menu_cremeBrulee.jpg', TRUE, 4.7)
ON DUPLICATE KEY UPDATE
    ingredients = VALUES(ingredients),
    addon_options = VALUES(addon_options);

-- Beverages --
INSERT INTO menu_items
    (item_id, name, description, ingredients, addon_options, nutritional_info, price, category_id, image_url, is_available, rating) VALUES
(14, 'Aperol Spritz',
    'Italy''s most iconic aperitivo - bittersweet Aperol topped with chilled Prosecco and a splash of soda, poured over ice and finished with a fresh orange slice.',
    'Aperol:45 ml, Prosecco:90 ml, Soda water:30 ml, Orange slice:1 pc',
    'Extra Orange Garnish, Make it a Double',
    'Contains alcohol. Must be of legal drinking age to order.',
    28.00, 4, 'image/menu_aperolSpritz.jpg', TRUE, 4.8),

(15, 'Espresso Martini',
    'Vodka shaken hard with coffee liqueur and a fresh shot of espresso until dark, rich, and topped with a silky crema.',
    'Vodka:45 ml, Coffee liqueur:20 ml, Fresh espresso:1 shot',
    'Extra Espresso Shot, Make it a Double',
    'Contains alcohol and caffeine. Must be of legal drinking age to order.',
    32.00, 4, 'image/menu_espressoMartini.jpg', TRUE, 4.9),

(16, 'Bellini',
    'Chilled Prosecco poured gently over silky white peach puree - a Venetian classic invented at Harry''s Bar in 1948.',
    'Prosecco:100 ml, White peach puree:40 ml',
    'Extra Peach Puree, Make it a Double',
    'Contains alcohol. Must be of legal drinking age to order.',
    26.00, 4, 'image/menu_bellini.jpg', TRUE, 4.7),

(17, 'Negroni',
    'Equal parts gin, Campari, and sweet vermouth, stirred slowly over ice and finished with an orange twist.',
    'Gin:30 ml, Campari:30 ml, Sweet vermouth:30 ml, Orange twist:1 pc',
    'Extra Orange Twist, Make it a Double',
    'Contains alcohol. Must be of legal drinking age to order.',
    30.00, 4, 'image/menu_negroni.jpg', TRUE, 4.6),

(18, 'Affogato al Caffe',
    'A generous scoop of vanilla gelato "drowned" tableside in a hot shot of espresso - dessert and coffee in one glass.',
    'Vanilla gelato:2 scoops, Hot espresso:1 shot',
    'Extra Espresso Shot, Extra Gelato Scoop',
    'Contains dairy and caffeine.',
    14.00, 4, 'image/menu_affogato.jpg', TRUE, 4.9)
ON DUPLICATE KEY UPDATE
    ingredients = VALUES(ingredients),
    addon_options = VALUES(addon_options);