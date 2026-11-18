USE ospos;

-- Create the legacy schema and seed rows before applying versioned migrations.
-- Create/select the ospos database before running this file.
-- Run this as a SQL script so each semicolon-separated statement executes separately.

-- -----------------------------------------------------------------------------
-- Script: initial_schema.sql
-- -----------------------------------------------------------------------------


--
-- Table structure for table `ospos_app_config`
--

CREATE TABLE `ospos_app_config` (
    `key` varchar(50) NOT NULL,
    `value` varchar(500) NOT NULL,
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_app_config`
--

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
    ('address', '123 Nowhere street'),
    ('company', 'Open Source Point of Sale'),
    ('default_tax_rate', '8'),
    ('email', 'changeme@example.com'),
    ('fax', ''),
    ('phone', '555-555-5555'),
    ('return_policy', 'Test'),
    ('timezone', 'America/New_York'),
    ('website', ''),
    ('company_logo', ''),
    ('tax_included', '0'),
    ('barcode_content', 'id'),
    ('barcode_type', 'Code39'),
    ('barcode_width', '250'),
    ('barcode_height', '50'),
    ('barcode_quality', '100'),
    ('barcode_font', 'Arial'),
    ('barcode_font_size', '10'),
    ('barcode_first_row', 'category'),
    ('barcode_second_row', 'item_code'),
    ('barcode_third_row', 'unit_price'),
    ('barcode_num_in_row', '2'),
    ('barcode_page_width', '100'),
    ('barcode_page_cellspacing', '20'),
    ('barcode_generate_if_empty', '0'),
    ('receipt_show_taxes', '0'),
    ('receipt_show_total_discount', '1'),
    ('receipt_show_description', '1'),
    ('receipt_show_serialnumber', '1'),
    ('invoice_enable', '1'),
    ('recv_invoice_format', '$CO'),
    ('sales_invoice_format', '$CO'),
    ('invoice_email_message', 'Dear $CU, In attachment the receipt for sale $INV'),
    ('invoice_default_comments', 'This is a default comment'),
    ('print_silently', '1'),
    ('print_header', '0'),
    ('print_footer', '0'),
    ('print_top_margin', '0'),
    ('print_left_margin', '0'),
    ('print_bottom_margin', '0'),
    ('print_right_margin', '0'),
    ('default_sales_discount', '0'),
    ('lines_per_page', '25'),
    ('dateformat', 'm/d/Y'),
    ('timeformat', 'H:i:s'),
    ('currency_symbol', '$'),
    ('number_locale', 'en_US'),
    ('thousands_separator', '1'),
    ('currency_decimals', '2'),
    ('tax_decimals', '2'),
    ('quantity_decimals', '0'),
    ('country_codes', 'us'),
    ('msg_msg', ''),
    ('msg_uid', ''),
    ('msg_src', ''),
    ('msg_pwd', ''),
    ('notify_horizontal_position', 'center'),
    ('notify_vertical_position', 'bottom'),
    ('payment_options_order', 'cashdebitcredit'),
    ('protocol', 'mail'),
    ('mailpath', '/usr/sbin/sendmail'),
    ('smtp_port', '465'),
    ('smtp_timeout', '5'),
    ('smtp_crypto', 'ssl'),
    ('receipt_template', 'receipt_default'),
    ('theme', 'flatly'),
    ('statistics', '1'),
    ('language', 'english'),
    ('language_code', 'en');


-- --------------------------------------------------------

--
-- Table structure for table `ospos_customers`
--

CREATE TABLE `ospos_customers` (
    `person_id` int(10) NOT NULL,
    `company_name` varchar(255) DEFAULT NULL,
    `account_number` varchar(255) DEFAULT NULL,
    `taxable` int(1) NOT NULL DEFAULT '1',
    `discount_percent` decimal(15,2) NOT NULL DEFAULT '0',
    `deleted` int(1) NOT NULL DEFAULT '0',
    PRIMARY KEY `person_id` (`person_id`),
    UNIQUE KEY `account_number` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_customers`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_employees`
--

CREATE TABLE `ospos_employees` (
    `username` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
    `person_id` int(10) NOT NULL,
    `deleted` int(1) NOT NULL DEFAULT '0',
    `hash_version` int(1) NOT NULL DEFAULT '2',
    PRIMARY KEY `person_id` (`person_id`),
    UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_employees`
--

INSERT INTO `ospos_employees` (`username`, `password`, `person_id`, `deleted`, `hash_version`) VALUES
    ('admin', '$2y$10$vJBSMlD02EC7ENSrKfVQXuvq9tNRHMtcOA8MSK2NYS748HHWm.gcG', 1, 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `ospos_giftcards`
--

CREATE TABLE `ospos_giftcards` (
    `record_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `giftcard_id` int(11) NOT NULL AUTO_INCREMENT,
    `giftcard_number` int(10) NOT NULL,
    `value` decimal(15,2) NOT NULL,
    `deleted` int(1) NOT NULL DEFAULT '0',
    `person_id` INT(10) DEFAULT NULL,
    PRIMARY KEY (`giftcard_id`),
    UNIQUE KEY `giftcard_number` (`giftcard_number`),
    KEY `person_id` (`person_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_giftcards`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_inventory`
--

CREATE TABLE `ospos_inventory` (
    `trans_id` int(11) NOT NULL AUTO_INCREMENT,
    `trans_items` int(11) NOT NULL DEFAULT '0',
    `trans_user` int(11) NOT NULL DEFAULT '0',
    `trans_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `trans_comment` text NOT NULL,
    `trans_location` int(11) NOT NULL,
    `trans_inventory` decimal(15,3) NOT NULL DEFAULT '0',
    PRIMARY KEY (`trans_id`),
    KEY `trans_items` (`trans_items`),
    KEY `trans_user` (`trans_user`),
    KEY `trans_location` (`trans_location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `ospos_inventory`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_items`
--

CREATE TABLE `ospos_items` (
    `name` varchar(255) NOT NULL,
    `category` varchar(255) NOT NULL,
    `supplier_id` int(11) DEFAULT NULL,
    `item_number` varchar(255) DEFAULT NULL,
    `description` varchar(255) NOT NULL,
    `cost_price` decimal(15,2) NOT NULL,
    `unit_price` decimal(15,2) NOT NULL,
    `reorder_level` decimal(15,3) NOT NULL DEFAULT '0',
    `receiving_quantity` decimal(15,3) NOT NULL DEFAULT '1',
    `item_id` int(10) NOT NULL AUTO_INCREMENT,
    `pic_id` int(10) DEFAULT NULL,
    `allow_alt_description` tinyint(1) NOT NULL,
    `is_serialized` tinyint(1) NOT NULL,
    `deleted` int(1) NOT NULL DEFAULT '0',
    `custom1` VARCHAR(25) NOT NULL,
    `custom2` VARCHAR(25) NOT NULL,
    `custom3` VARCHAR(25) NOT NULL,
    `custom4` VARCHAR(25) NOT NULL,
    `custom5` VARCHAR(25) NOT NULL,
    `custom6` VARCHAR(25) NOT NULL,
    `custom7` VARCHAR(25) NOT NULL,
    `custom8` VARCHAR(25) NOT NULL,
    `custom9` VARCHAR(25) NOT NULL,
    `custom10` VARCHAR(25) NOT NULL,
    PRIMARY KEY (`item_id`),
    UNIQUE KEY `item_number` (`item_number`),
    KEY `supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Table structure for table `ospos_attachments`
--

CREATE TABLE `ospos_attachments` (
    `attachment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `entity_type` varchar(32) NOT NULL,
    `entity_id` int(10) unsigned NOT NULL,
    `attachment_type` varchar(32) NOT NULL DEFAULT 'file',
    `file_name` varchar(255) NOT NULL,
    `mime_type` varchar(127) NOT NULL,
    `file_size` int(10) unsigned NOT NULL,
    `file_data` longblob NOT NULL,
    `is_primary` tinyint(1) NOT NULL DEFAULT 0,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    PRIMARY KEY (`attachment_id`),
    KEY `attachments_entity` (`entity_type`, `entity_id`, `attachment_type`, `is_primary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ospos_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_items_taxes`
--

CREATE TABLE `ospos_items_taxes` (
    `item_id` int(10) NOT NULL,
    `name` varchar(255) NOT NULL,
    `percent` decimal(15,3) NOT NULL,
    PRIMARY KEY (`item_id`,`name`,`percent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_items_taxes`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_item_kits`
--

CREATE TABLE `ospos_item_kits` (
    `item_kit_id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `description` varchar(255) NOT NULL,
    PRIMARY KEY (`item_kit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `ospos_item_kits`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_item_kit_items`
--

CREATE TABLE `ospos_item_kit_items` (
    `item_kit_id` int(11) NOT NULL,
    `item_id` int(11) NOT NULL,
    `quantity` decimal(15,3) NOT NULL,
    PRIMARY KEY (`item_kit_id`,`item_id`,`quantity`),
    KEY `ospos_item_kit_items_ibfk_2` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_item_kit_items`
--

-- --------------------------------------------------------

--
-- Table structure for table `ospos_item_quantities`
--

CREATE TABLE IF NOT EXISTS `ospos_item_quantities` (
    `item_id` int(11) NOT NULL,
    `location_id` int(11) NOT NULL,
    `quantity` decimal(15,3) NOT NULL DEFAULT '0',
    PRIMARY KEY (`item_id`,`location_id`),
    KEY `item_id` (`item_id`),
    KEY `location_id` (`location_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

-- --------------------------------------------------------

--
-- Table structure for table `ospos_modules`
--

CREATE TABLE `ospos_modules` (
    `name_lang_key` varchar(255) NOT NULL,
    `desc_lang_key` varchar(255) NOT NULL,
    `sort` int(10) NOT NULL,
    `module_id` varchar(255) NOT NULL,
    PRIMARY KEY (`module_id`),
    UNIQUE KEY `desc_lang_key` (`desc_lang_key`),
    UNIQUE KEY `name_lang_key` (`name_lang_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_modules`
--

INSERT INTO `ospos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
    ('module_config', 'module_config_desc', 110, 'config'),
    ('module_customers', 'module_customers_desc', 10, 'customers'),
    ('module_employees', 'module_employees_desc', 80, 'employees'),
    ('module_giftcards', 'module_giftcards_desc', 90, 'giftcards'),
    ('module_items', 'module_items_desc', 20, 'items'),
    ('module_item_kits', 'module_item_kits_desc', 30, 'item_kits'),
    ('module_messages', 'module_messages_desc', 100, 'messages'),
    ('module_receivings', 'module_receivings_desc', 60, 'receivings'),
    ('module_reports', 'module_reports_desc', 50, 'reports'),
    ('module_sales', 'module_sales_desc', 70, 'sales'),
    ('module_suppliers', 'module_suppliers_desc', 40, 'suppliers');

-- --------------------------------------------------------

--
-- Table structure for table `ospos_people`
--

CREATE TABLE `ospos_people` (
    `first_name` varchar(255) NOT NULL,
    `last_name` varchar(255) NOT NULL,
    `gender` int(1) DEFAULT NULL,
    `phone_number` varchar(255) NOT NULL,
    `email` varchar(255) NOT NULL,
    `address_1` varchar(255) NOT NULL,
    `address_2` varchar(255) NOT NULL,
    `city` varchar(255) NOT NULL,
    `state` varchar(255) NOT NULL,
    `zip` varchar(255) NOT NULL,
    `country` varchar(255) NOT NULL,
    `comments` text NOT NULL,
    `person_id` int(10) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`person_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `ospos_people`
--

INSERT INTO `ospos_people` (`first_name`, `last_name`, `phone_number`, `email`, `address_1`, `address_2`, `city`, `state`, `zip`, `country`, `comments`, `person_id`) VALUES
    ('John', 'Doe', '555-555-5555', 'changeme@example.com', 'Address 1', '', '', '', '', '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `ospos_permissions`
--

CREATE TABLE `ospos_permissions` (
    `permission_id` varchar(255) NOT NULL,
    `module_id` varchar(255) NOT NULL,
    `location_id` int(10) DEFAULT NULL,
    PRIMARY KEY (`permission_id`),
    KEY `module_id` (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_permissions`
--

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
    ('reports_customers', 'reports'),
    ('reports_receivings', 'reports'),
    ('reports_items', 'reports'),
    ('reports_employees', 'reports'),
    ('reports_suppliers', 'reports'),
    ('reports_sales', 'reports'),
    ('reports_discounts', 'reports'),
    ('reports_taxes', 'reports'),
    ('reports_inventory', 'reports'),
    ('reports_categories', 'reports'),
    ('reports_payments', 'reports'),
    ('customers', 'customers'),
    ('employees', 'employees'),
    ('giftcards', 'giftcards'),
    ('items', 'items'),
    ('item_kits', 'item_kits'),
    ('messages', 'messages'),
    ('receivings', 'receivings'),
    ('reports', 'reports'),
    ('sales', 'sales'),
    ('config', 'config'),
    ('suppliers', 'suppliers');

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`, `location_id`) VALUES
    ('items_stock', 'items', 1),
    ('sales_stock', 'sales', 1),
    ('receivings_stock', 'receivings', 1);

-- --------------------------------------------------------

--
-- Table structure for table `ospos_grants`
--

CREATE TABLE `ospos_grants` (
    `permission_id` varchar(255) NOT NULL,
    `person_id` int(10) NOT NULL,
    PRIMARY KEY (`permission_id`,`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_grants`
--
-- --------------------------------------------------------

INSERT INTO `ospos_grants` (`permission_id`, `person_id`) VALUES
    ('reports_customers', 1),
    ('reports_receivings', 1),
    ('reports_items', 1),
    ('reports_inventory', 1),
    ('reports_employees', 1),
    ('reports_suppliers', 1),
    ('reports_sales', 1),
    ('reports_discounts', 1),
    ('reports_taxes', 1),
    ('reports_categories', 1),
    ('reports_payments', 1),
    ('customers', 1),
    ('employees', 1),
    ('giftcards', 1),
    ('items', 1),
    ('item_kits', 1),
    ('messages', 1),
    ('receivings', 1),
    ('reports', 1),
    ('sales', 1),
    ('config', 1),
    ('items_stock', 1),
    ('sales_stock', 1),
    ('receivings_stock', 1),
    ('suppliers', 1);

--
-- Table structure for table `ospos_receivings`
--

CREATE TABLE `ospos_receivings` (
    `receiving_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `supplier_id` int(10) DEFAULT NULL,
    `employee_id` int(10) NOT NULL DEFAULT '0',
    `comment` text NOT NULL,
    `receiving_id` int(10) NOT NULL AUTO_INCREMENT,
    `payment_type` varchar(20) DEFAULT NULL,
    `reference` varchar(32) DEFAULT NULL,
    PRIMARY KEY (`receiving_id`),
    KEY `supplier_id` (`supplier_id`),
    KEY `employee_id` (`employee_id`),
    KEY `reference` (`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `ospos_receivings`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_receivings_items`
--

CREATE TABLE `ospos_receivings_items` (
    `receiving_id` int(10) NOT NULL DEFAULT '0',
    `item_id` int(10) NOT NULL DEFAULT '0',
    `description` varchar(30) DEFAULT NULL,
    `serialnumber` varchar(30) DEFAULT NULL,
    `line` int(3) NOT NULL,
    `quantity_purchased` decimal(15,3) NOT NULL DEFAULT '0',
    `item_cost_price` decimal(15,2) NOT NULL,
    `item_unit_price` decimal(15,2) NOT NULL,
    `discount_percent` decimal(15,2) NOT NULL DEFAULT '0',
    `item_location` int(11) NOT NULL,
    `receiving_quantity` decimal(15,3) NOT NULL DEFAULT '1',
    PRIMARY KEY (`receiving_id`,`item_id`,`line`),
    KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_receivings_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales`
--

CREATE TABLE `ospos_sales` (
    `sale_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `customer_id` int(10) DEFAULT NULL,
    `employee_id` int(10) NOT NULL DEFAULT '0',
    `comment` text NOT NULL,
    `invoice_number` varchar(32) DEFAULT NULL,
    `sale_id` int(10) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`sale_id`),
    KEY `customer_id` (`customer_id`),
    KEY `employee_id` (`employee_id`),
    KEY `sale_time` (`sale_time`),
    UNIQUE KEY `invoice_number` (`invoice_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `ospos_sales`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales_items`
--

CREATE TABLE `ospos_sales_items` (
    `sale_id` int(10) NOT NULL DEFAULT '0',
    `item_id` int(10) NOT NULL DEFAULT '0',
    `description` varchar(30) DEFAULT NULL,
    `serialnumber` varchar(30) DEFAULT NULL,
    `line` int(3) NOT NULL DEFAULT '0',
    `quantity_purchased` decimal(15,3) NOT NULL DEFAULT '0',
    `item_cost_price` decimal(15,2) NOT NULL,
    `item_unit_price` decimal(15,2) NOT NULL,
    `discount_percent` decimal(15,2) NOT NULL DEFAULT '0',
    `item_location` int(11) NOT NULL,
    PRIMARY KEY (`sale_id`,`item_id`,`line`),
    KEY `sale_id` (`sale_id`),
    KEY `item_id` (`item_id`),
    KEY `item_location` (`item_location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_sales_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales_items_taxes`
--

CREATE TABLE `ospos_sales_items_taxes` (
    `sale_id` int(10) NOT NULL,
    `item_id` int(10) NOT NULL,
    `line` int(3) NOT NULL DEFAULT '0',
    `name` varchar(255) NOT NULL,
    `percent` decimal(15,3) NOT NULL,
    PRIMARY KEY (`sale_id`,`item_id`,`line`,`name`,`percent`),
    KEY `sale_id` (`sale_id`),
    KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_sales_items_taxes`
--

-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales_payments`
--

CREATE TABLE `ospos_sales_payments` (
    `sale_id` int(10) NOT NULL,
    `payment_type` varchar(40) NOT NULL,
    `payment_amount` decimal(15,2) NOT NULL,
    PRIMARY KEY (`sale_id`,`payment_type`),
    KEY `sale_id` (`sale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_sales_payments`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales_suspended`
--

CREATE TABLE `ospos_sales_suspended` (
     `sale_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
     `customer_id` int(10) DEFAULT NULL,
     `employee_id` int(10) NOT NULL DEFAULT '0',
     `comment` text NOT NULL,
     `invoice_number` varchar(32) DEFAULT NULL,
     `sale_id` int(10) NOT NULL AUTO_INCREMENT,
     PRIMARY KEY (`sale_id`),
     KEY `customer_id` (`customer_id`),
     KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `ospos_sales_suspended`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales_suspended_items`
--

CREATE TABLE `ospos_sales_suspended_items` (
    `sale_id` int(10) NOT NULL DEFAULT '0',
    `item_id` int(10) NOT NULL DEFAULT '0',
    `description` varchar(30) DEFAULT NULL,
    `serialnumber` varchar(30) DEFAULT NULL,
    `line` int(3) NOT NULL DEFAULT '0',
    `quantity_purchased` decimal(15,3) NOT NULL DEFAULT '0',
    `item_cost_price` decimal(15,2) NOT NULL,
    `item_unit_price` decimal(15,2) NOT NULL,
    `discount_percent` decimal(15,2) NOT NULL DEFAULT '0',
    `item_location` int(11) NOT NULL,
    PRIMARY KEY (`sale_id`,`item_id`,`line`),
    KEY `sale_id` (`sale_id`),
    KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_sales_suspended_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales_suspended_items_taxes`
--

CREATE TABLE `ospos_sales_suspended_items_taxes` (
    `sale_id` int(10) NOT NULL,
    `item_id` int(10) NOT NULL,
    `line` int(3) NOT NULL DEFAULT '0',
    `name` varchar(255) NOT NULL,
    `percent` decimal(15,3) NOT NULL,
    PRIMARY KEY (`sale_id`,`item_id`,`line`,`name`,`percent`),
    KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_sales_suspended_items_taxes`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sales_suspended_payments`
--

CREATE TABLE `ospos_sales_suspended_payments` (
    `sale_id` int(10) NOT NULL,
    `payment_type` varchar(40) NOT NULL,
    `payment_amount` decimal(15,2) NOT NULL,
    PRIMARY KEY (`sale_id`,`payment_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_sales_suspended_payments`
--


-- --------------------------------------------------------

--
-- Table structure for table `ospos_sessions`
--

CREATE TABLE `ospos_sessions` (
    `id` varchar(40) NOT NULL,
    `ip_address` varchar(45) NOT NULL,
    `timestamp` int(10) unsigned DEFAULT 0 NOT NULL,
    `data` blob NOT NULL,
    KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_sessions`
--

-- --------------------------------------------------------

--
-- Table structure for table `ospos_stock_locations`
--

CREATE TABLE `ospos_stock_locations` (
    `location_id` int(11) NOT NULL AUTO_INCREMENT,
    `location_name` varchar(255) DEFAULT NULL,
    `deleted` int(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`location_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Dumping data for table `ospos_stock_locations`
--

INSERT INTO `ospos_stock_locations` ( `deleted`, `location_name` ) VALUES ('0', 'stock');

-- --------------------------------------------------------

--
-- Table structure for table `ospos_suppliers`
--

CREATE TABLE `ospos_suppliers` (
    `person_id` int(10) NOT NULL,
    `company_name` varchar(255) NOT NULL,
    `agency_name` varchar(255) NOT NULL,
    `account_number` varchar(255) DEFAULT NULL,
    `deleted` int(1) NOT NULL DEFAULT '0',
    PRIMARY KEY `person_id` (`person_id`),
    UNIQUE KEY `account_number` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ospos_suppliers`
--
--

-- Apply migrations in dependency order.

-- -----------------------------------------------------------------------------
-- Script: 3.0.2_to_3.1.1.sql
-- -----------------------------------------------------------------------------

-- alter quantity fields to be all decimal

ALTER TABLE `ospos_items`
  ADD COLUMN `stock_type` TINYINT(2) NOT NULL DEFAULT 0,
  ADD COLUMN `item_type` TINYINT(2) NOT NULL DEFAULT 0;

ALTER TABLE `ospos_item_kits`
  ADD COLUMN `item_id` INT(10) NOT NULL DEFAULT 0,
  ADD COLUMN `kit_discount_percent` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  ADD COLUMN `price_option` TINYINT(2) NOT NULL DEFAULT 0,
  ADD COLUMN `print_option` TINYINT(2) NOT NULL DEFAULT 0;

ALTER TABLE `ospos_item_kit_items`
  ADD COLUMN `kit_sequence` INT(3) NOT NULL DEFAULT 0;

ALTER TABLE `ospos_sales_items`
  ADD COLUMN `print_option` TINYINT(2) NOT NULL DEFAULT 0;

ALTER TABLE `ospos_sales_suspended`
  ADD COLUMN `quote_number` varchar(32) DEFAULT NULL AFTER `invoice_number`;

ALTER TABLE `ospos_sales_suspended_items`
  ADD COLUMN `print_option` TINYINT(2) NOT NULL DEFAULT 0;

-- alter pic_id field, to rather contain a file name

ALTER TABLE `ospos_items` CHANGE `pic_id` `pic_filename` VARCHAR(255);

--
-- Table structure for table `ospos_dinner_tables`
--

CREATE TABLE IF NOT EXISTS `ospos_dinner_tables` (
  `dinner_table_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`dinner_table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `ospos_dinner_tables` (`dinner_table_id`, `name`, `status`, `deleted`) VALUES
(1, 'Delivery', 0, 0),
(2, 'Take Away', 0, 0);

-- alter ospos_sales table

ALTER TABLE `ospos_sales`
  ADD COLUMN `dinner_table_id` int(11) NULL AFTER `invoice_number`;

ALTER TABLE `ospos_sales`
  ADD KEY `dinner_table_id` (`dinner_table_id`),
  ADD CONSTRAINT `ospos_sales_ibfk_3` FOREIGN KEY (`dinner_table_id`) REFERENCES `ospos_dinner_tables` (`dinner_table_id`);

-- alter ospos_sales_suspended table

ALTER TABLE `ospos_sales_suspended`
  ADD COLUMN `dinner_table_id` int(11) NULL AFTER `quote_number`;

ALTER TABLE `ospos_sales_suspended`
  ADD KEY `dinner_table_id` (`dinner_table_id`),
  ADD CONSTRAINT `ospos_sales_suspended_ibfk_3` FOREIGN KEY (`dinner_table_id`) REFERENCES `ospos_dinner_tables` (`dinner_table_id`);

-- add enabled dinner tables key into config

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('date_or_time_format', ''),
('sales_quote_format', 'Q%y{QSEQ:6}'),
('default_register_mode', 'sale'),
('last_used_invoice_number', '0'),
('last_used_quote_number', '0'),
('line_sequence', '0'),
('dinner_table_enable', '0'),
('customer_sales_tax_support', '0');

--
-- Table structure for table `ospos_customer_packages`
--

CREATE TABLE IF NOT EXISTS `ospos_customers_packages` (
  `package_id` int(11) NOT NULL AUTO_INCREMENT,
  `package_name` varchar(255) DEFAULT NULL,
  `points_percent` float NOT NULL DEFAULT '0',
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

INSERT INTO `ospos_customers_packages` (`package_id`, `package_name`, `points_percent`, `deleted`) VALUES
(1, 'Default', 0, 0),
(2, 'Bronze', 10, 0),
(3, 'Silver', 20, 0),
(4, 'Gold', 30, 0),
(5, 'Premium', 50, 0);

--
-- Table structure for table `ospos_customer_points`
--

CREATE TABLE IF NOT EXISTS `ospos_customers_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `sale_id` int(11) NOT NULL,
  `points_earned` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

--
-- Table structure for table `ospos_sales_reward_points`
--

CREATE TABLE IF NOT EXISTS `ospos_sales_reward_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) NOT NULL,
  `earned` float NOT NULL,
  `used` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- alter ospos_customers table

ALTER TABLE ospos_customers
  ADD COLUMN `package_id` int(11) DEFAULT NULL AFTER `discount_percent`,
  ADD COLUMN `points` int(11) DEFAULT NULL AFTER `package_id`;

-- add enabled reward points key into config

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('customer_reward_enable', '0');

--
-- The following changes are in support of customer sales tax changes
--

CREATE TABLE IF NOT EXISTS `ospos_tax_codes` (
  `tax_code` varchar(32) NOT NULL,
  `tax_code_name` varchar(255) NOT NULL DEFAULT '',
  `tax_code_type` tinyint(2) NOT NULL DEFAULT 0,
  `city` varchar(255) NOT NULL DEFAULT '',
  `state` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`tax_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ospos_tax_code_rates` (
  `rate_tax_code` varchar(32) NOT NULL,
  `rate_tax_category_id` int(10) NOT NULL,
  `tax_rate` decimal(15,4) NOT NULL DEFAULT 0.0000,
  `rounding_code` tinyint(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`rate_tax_code`,`rate_tax_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ospos_sales_taxes` (
  `sale_id` int(10) NOT NULL,
  `tax_type` smallint(2) NOT NULL,
  `tax_group` varchar(32) NOT NULL,
  `sale_tax_basis` decimal(15,4) NOT NULL,
  `sale_tax_amount` decimal(15,4) NOT NULL,
  `print_sequence` tinyint(2) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `tax_rate` decimal(15,4) NOT NULL,
  `sales_tax_code` varchar(32) NOT NULL DEFAULT '',
  `rounding_code` tinyint(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`sale_id`,`tax_type`,`tax_group`),
  KEY `print_sequence` (`sale_id`,`print_sequence`,`tax_type`,`tax_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ospos_tax_categories` (
  `tax_category_id` int(10) NOT NULL,
  `tax_category` varchar(32) NOT NULL,
  `tax_group_sequence` tinyint(2) NOT NULL,
  PRIMARY KEY (`tax_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `ospos_items`
  ADD COLUMN `tax_category_id` int(10) NOT NULL DEFAULT 0;

ALTER TABLE `ospos_sales`
  ADD COLUMN `quote_number` varchar(32) DEFAULT NULL,
  ADD COLUMN `sale_status` tinyint(2) NOT NULL DEFAULT 0;

ALTER TABLE `ospos_sales_items_taxes`
  MODIFY COLUMN `percent` decimal(15,4) NOT NULL DEFAULT 0.0000,
  ADD COLUMN `tax_type` tinyint(2) NOT NULL DEFAULT 0,
  ADD COLUMN `rounding_code` tinyint(2) NOT NULL DEFAULT 0,
  ADD COLUMN `cascade_tax` tinyint(2) NOT NULL DEFAULT 0,
  ADD COLUMN `cascade_sequence` tinyint(2) NOT NULL DEFAULT 0,
  ADD COLUMN `item_tax_amount` decimal(15,4) NOT NULL DEFAULT 0;

ALTER TABLE `ospos_customers`
  ADD COLUMN `sales_tax_code` varchar(32) NOT NULL DEFAULT '1';

INSERT IGNORE INTO `ospos_app_config` (`key`, `value`) VALUES
('customer_sales_tax_support', '0'),
('default_origin_tax_code', ''),
('default_tax_category', 'Standard'),
('default_tax_1_name', ''),
('default_tax_1_rate', ''),
('default_tax_2_name', ''),
('default_tax_2_rate', '');

INSERT IGNORE INTO `ospos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
('module_taxes', 'module_taxes_desc', 105, 'taxes');

INSERT IGNORE INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('taxes', 'taxes');

-- add support for cash rounding into config

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('cash_decimals', '2'),
('cash_rounding_code', '0');

-- alter people table (create email index)

ALTER TABLE `ospos_people`
  ADD INDEX `email` (`email`);

-- add financial year start into config

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('financial_year', '1');

-- alter giftcard field number to be varchar

ALTER TABLE `ospos_giftcards` CHANGE `giftcard_number` `giftcard_number` VARCHAR(255) NULL;

-- add support for select between gitcard number series or random

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('giftcard_number', 'series');

-- add option to print company name in receipt

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('receipt_show_company_name', '1');

-- add support for sales tax history migration

INSERT INTO `ospos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
('module_migrate', 'module_migrate_desc', 120, 'migrate');

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('migrate', 'migrate');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`) VALUES
('migrate', 1);

-- update to receivings

UPDATE ospos_items SET receiving_quantity = 1 WHERE receiving_quantity = 0;

-- long alternate description

ALTER TABLE `ospos_sales_items`
  MODIFY COLUMN `description` varchar(255) DEFAULT NULL;

-- fix tax category maintenance

DELETE FROM `ospos_tax_categories` where tax_category_id in (0, 1, 2, 3);

ALTER TABLE `ospos_tax_categories`
  MODIFY COLUMN `tax_category_id` int(10) NOT NULL AUTO_INCREMENT;

ALTER TABLE `ospos_items`
  MODIFY COLUMN `tax_category_id` int(10) DEFAULT NULL;

-- If you have added any tax codes, the following will correct the rate_tax_category_id on the tax_code_rates table,
-- but you might need to add more UPDATE statements depending on how may tax codes and/or tax categories you've added

UPDATE `ospos_tax_code_rates` SET rate_tax_category_id = 4 WHERE rate_tax_category_id = 3;
UPDATE `ospos_tax_code_rates` SET rate_tax_category_id = 3 WHERE rate_tax_category_id = 2;
UPDATE `ospos_tax_code_rates` SET rate_tax_category_id = 2 WHERE rate_tax_category_id = 1;
UPDATE `ospos_tax_code_rates` SET rate_tax_category_id = 1 WHERE rate_tax_category_id = 0;

-- add receipt font size

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('receipt_font_size', '12');

--
-- Add rewards foreign keys
--

ALTER TABLE `ospos_customers_points`
  ADD KEY `person_id` (`person_id`),
  ADD KEY `package_id` (`package_id`),
  ADD KEY `sale_id` (`sale_id`),
  ADD CONSTRAINT `ospos_customers_points_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `ospos_customers` (`person_id`),
  ADD CONSTRAINT `ospos_customers_points_ibfk_2` FOREIGN KEY (`package_id`) REFERENCES `ospos_customers_packages` (`package_id`),
  ADD CONSTRAINT `ospos_customers_points_ibfk_3` FOREIGN KEY (`sale_id`) REFERENCES `ospos_sales` (`sale_id`);

ALTER TABLE `ospos_sales_reward_points`
  ADD KEY `sale_id` (`sale_id`),
  ADD CONSTRAINT `ospos_sales_reward_points_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `ospos_sales` (`sale_id`);

ALTER TABLE `ospos_customers`
  ADD KEY `package_id` (`package_id`),
  ADD CONSTRAINT `ospos_customers_ibfk_2` FOREIGN KEY (`package_id`) REFERENCES `ospos_customers_packages` (`package_id`);

-- add reCAPTCHA configuration

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('gcaptcha_enable', '0'),
('gcaptcha_secret_key', ''),
('gcaptcha_site_key', '');

-- add Barcode formats and other missing keys

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('barcode_formats', '[]');

-- replace old tokens in ospos_app_config

UPDATE `ospos_app_config` SET `value` = REPLACE(`value`, '$CO', '{CO}');
UPDATE `ospos_app_config` SET `value` = REPLACE(`value`, '$CU', '{CU}');
UPDATE `ospos_app_config` SET `value` = REPLACE(`value`, '$INV', '{ISEQ}');
UPDATE `ospos_app_config` SET `value` = REPLACE(`value`, '$SCO', '{SCO}');

--
-- Copy suspended sales to sales table
--

INSERT INTO `ospos_sales` (sale_time, customer_id, employee_id, comment, invoice_number, sale_status)
  SELECT sale_time, customer_id, employee_id, comment, invoice_number, 1 FROM `ospos_sales_suspended`;
INSERT INTO `ospos_sales_items` (sale_id, item_id, description, serialnumber, line, quantity_purchased, item_cost_price, item_unit_price,
  discount_percent, item_location) SELECT sale_id, item_id, description, serialnumber, line, quantity_purchased, item_cost_price, item_unit_price,
  discount_percent, item_location FROM ospos_sales_suspended_items;
INSERT INTO `ospos_sales_payments` (sale_id, payment_type, payment_amount) SELECT sale_id, payment_type, payment_amount FROM `ospos_sales_suspended_payments`;
INSERT INTO `ospos_sales_items_taxes` (sale_id, item_id, line, name, percent) SELECT sale_id, item_id, line, name, percent FROM `ospos_sales_suspended_items_taxes`;

DROP TABLE `ospos_sales_suspended_payments`, `ospos_sales_suspended_items_taxes`, `ospos_sales_suspended_items`, `ospos_sales_suspended`;

--
-- General fixing to realign upgraded database to clean database structure
--

DELETE FROM `ospos_app_config` WHERE `key` = 'print_after_sale';

ALTER TABLE ospos_giftcards MODIFY value decimal(15,2) NOT NULL;
ALTER TABLE ospos_items MODIFY cost_price decimal(15,2) NOT NULL;
ALTER TABLE ospos_items MODIFY unit_price decimal(15,2) NOT NULL;
ALTER TABLE ospos_receivings_items MODIFY discount_percent decimal(15,2) NOT NULL DEFAULT '0.00';
ALTER TABLE ospos_receivings_items MODIFY item_unit_price decimal(15,2) NOT NULL;
ALTER TABLE ospos_sales_items MODIFY discount_percent decimal(15,2) NOT NULL DEFAULT '0.00';
ALTER TABLE ospos_sales_items MODIFY item_unit_price decimal(15,2) NOT NULL;

-- Change collation on columns to be utf8_general_ci

ALTER TABLE ospos_app_config CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_customers CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_customers_packages CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_customers_points CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_dinner_tables CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_employees CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_giftcards CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_grants CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_inventory CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_item_kit_items CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_item_kits CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_item_quantities CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_items CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_items_taxes CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_modules CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_people CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_permissions CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_receivings CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_receivings_items CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_sales CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_sales_items CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_sales_items_taxes CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_sales_payments CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_sales_reward_points CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_sales_taxes CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_sessions CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_stock_locations CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_suppliers CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_tax_categories CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_tax_code_rates CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_tax_codes CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

--
-- Increase acceptable length of custom fields and allow null values
--

ALTER TABLE ospos_items
  MODIFY custom1 VARCHAR(255) DEFAULT NULL,
  MODIFY custom2 VARCHAR(255) DEFAULT NULL,
  MODIFY custom3 VARCHAR(255) DEFAULT NULL,
  MODIFY custom4 VARCHAR(255) DEFAULT NULL,
  MODIFY custom5 VARCHAR(255) DEFAULT NULL,
  MODIFY custom6 VARCHAR(255) DEFAULT NULL,
  MODIFY custom7 VARCHAR(255) DEFAULT NULL,
  MODIFY custom8 VARCHAR(255) DEFAULT NULL,
  MODIFY custom9 VARCHAR(255) DEFAULT NULL,
  MODIFY custom10 VARCHAR(255) DEFAULT NULL;

-- Change language code en to be en-US

UPDATE `ospos_app_config` SET `value` = 'en-US' WHERE `key` = 'language_code' AND `value` = 'en';

-- -----------------------------------------------------------------------------
-- Script: 3.1.1_to_3.2.0.sql
-- -----------------------------------------------------------------------------

--
-- Add support for office menu group
--

ALTER TABLE `ospos_grants`
  ADD COLUMN `menu_group` varchar(32) DEFAULT 'home';

INSERT INTO `ospos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
('module_office', 'module_office_desc', 1, 'office'),
('module_home', 'module_home_desc', 1, 'home');

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('office', 'office'),
('home', 'home');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`, `menu_group`) VALUES
('office', 1, 'home'),
('home', 1, 'office');

UPDATE `ospos_grants`
SET menu_group = 'office'
WHERE permission_id in ('config', 'home', 'employees', 'taxes', 'migrate')
AND person_id = 1;

--
-- Add support for Work Orders
--

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('work_order_enable', '0'),
('work_order_format', 'W%y{WSEQ:6}'),
('last_used_work_order_number', '0');

ALTER TABLE `ospos_sales`
  ADD COLUMN `work_order_number` varchar(32) DEFAULT NULL,
  ADD COLUMN `sale_type` tinyint(2) NOT NULL DEFAULT 0;

-- sale_type (0=pos, 1=invoice, 2=work order, 3=quote, 4=return)

UPDATE `ospos_sales`
  SET `sale_type` = 0;

UPDATE ospos_sales t1
  SET sale_type = 4
WHERE EXISTS (SELECT t2.sale_id FROM ospos_sales_items t2 WHERE t1.sale_id = t2.sale_id AND t2.quantity_purchased < 0);

UPDATE `ospos_sales`
  SET `sale_type` = 3
WHERE `quote_number` IS NOT NULL;

-- The following is needed only if quotes were being treated as work orders.
-- UPDATE `ospos_sales`
--   SET `sale_type` = 2, `work_order_number` = `quote_number`
-- WHERE quote_number IS NOT NULL;

-- Identify invoices
UPDATE `ospos_sales`
  SET `sale_type` = 1
WHERE `invoice_number` IS NOT NULL;


--  Add permissions for deleting sales and default grant for employee id 1

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('sales_delete', 'sales');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`, `menu_group`) VALUES
('sales_delete', 1, '--');


-- Add columns to save per-user language selection

ALTER TABLE `ospos_employees`
  ADD COLUMN `language` VARCHAR(48) DEFAULT NULL,
  ADD COLUMN `language_code` VARCHAR(8) DEFAULT NULL;


-- Add support for custom search suggestion format

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('suggestions_first_column', 'name'),
('suggestions_second_column', ''),
('suggestions_third_column', '');


-- Add key->value to save setting for allowing duplicate barcodes

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('allow_duplicate_barcodes', '0');


-- Modify items table to allow duplicate barcodes

ALTER TABLE `ospos_items`
  DROP INDEX `item_number`,
  ADD KEY `item_number` (item_number);


-- Remove Migrate module as auto migration is supported

DELETE FROM `ospos_modules` WHERE `ospos_modules`.`module_id` = 'migrate';
DELETE FROM `ospos_permissions` WHERE `ospos_permissions`.`permission_id` = 'migrate';
DELETE FROM `ospos_grants` WHERE `ospos_grants`.`permission_id` = 'migrate' AND `ospos_grants`.`person_id` = 1;


-- Move Office Module to Right side of Modules list

UPDATE `ospos_modules`
SET `sort` = 999
WHERE `name_lang_key` = 'module_office';

UPDATE `ospos_modules`
SET `sort` = 98
WHERE `name_lang_key` = 'module_messages';


--
-- Add support for expenses tracking
--

INSERT INTO `ospos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
('module_expenses', 'module_expenses_desc', 108, 'expenses'),
('module_expenses_categories', 'module_expenses_categories_desc', 109, 'expenses_categories');

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('expenses_categories', 'expenses_categories'),
('expenses', 'expenses'),
('reports_expenses_categories', 'reports');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`) VALUES
('expenses', 1),
('expenses_categories', 1),
('reports_expenses_categories', 1);


-- Table structure for table `ospos_expense_categories`

CREATE TABLE IF NOT EXISTS `ospos_expense_categories` (
  `expense_category_id` int(10) NOT NULL,
  `category_name` varchar(255) DEFAULT NULL,
  `category_description` varchar(255) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Table structure for table `ospos_expenses`

CREATE TABLE IF NOT EXISTS `ospos_expenses` (
  `expense_id` int(10) NOT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` decimal(15,2) NOT NULL,
  `payment_type` varchar(40) NOT NULL,
  `expense_category_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `employee_id` int(10) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Indexes for table `ospos_expense_categories`

ALTER TABLE `ospos_expense_categories`
  ADD PRIMARY KEY (`expense_category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);


-- Indexes for table `ospos_expenses`

ALTER TABLE `ospos_expenses`
  ADD PRIMARY KEY (`expense_id`),
  ADD KEY `expense_category_id` (`expense_category_id`),
  ADD KEY `employee_id` (`employee_id`);


-- AUTO_INCREMENT for table `ospos_expense_categories`

ALTER TABLE `ospos_expense_categories`
  MODIFY `expense_category_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;


-- AUTO_INCREMENT for table `ospos_expenses`

ALTER TABLE `ospos_expenses`
  MODIFY `expense_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;


-- Constraints for table `ospos_expenses`

ALTER TABLE `ospos_expenses`
  ADD CONSTRAINT `ospos_expenses_ibfk_1` FOREIGN KEY (`expense_category_id`) REFERENCES `ospos_expense_categories` (`expense_category_id`),
  ADD CONSTRAINT `ospos_expenses_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `ospos_employees` (`person_id`);


-- Add extra columns to `ospos_expenses`

ALTER TABLE `ospos_expenses`
  ADD COLUMN `supplier_name` varchar(255) DEFAULT NULL,
  ADD COLUMN `supplier_tax_code` varchar(255) DEFAULT NULL,
  ADD COLUMN `tax_amount` decimal(15,2) DEFAULT NULL;


-- Remove unused barcode quality

DELETE FROM `ospos_app_config` WHERE `key` = 'barcode_quality';


-- Add new config option to allow derive sale quantity feature

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('derive_sale_quantity', '0');


-- Add new config option to set print and email receipt behaviour

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('email_receipt_check_behaviour', 'last'),
('print_receipt_check_behaviour', 'last');


-- This is to provide distinct default comments for both quotes and invoices

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('quote_default_comments', 'This is a default quote comment');

-- -----------------------------------------------------------------------------
-- Script: 3.2.0_to_3.2.1.sql
-- -----------------------------------------------------------------------------

--
-- Add support for GDPR utility
--

-- Add columns to customer table for tracking purposes and explicit consent of data registration

ALTER TABLE `ospos_customers`
  ADD COLUMN `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN `employee_id` int(10) NOT NULL,
  ADD COLUMN `consent` int(1) NOT NULL DEFAULT '0';

-- This is to enforce privacy by means of scrambling customer details

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('enforce_privacy', '0');


-- Add print receipt autoreturn delay

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('print_delay_autoreturn', '0');


-- Insure that the receiving quantity is not zero

UPDATE ospos_receivings_items SET receiving_quantity = 1 WHERE receiving_quantity = 0;

-- -----------------------------------------------------------------------------
-- Script: 3.2.1_to_3.3.0.sql
-- -----------------------------------------------------------------------------

--
-- Add support for Multi-Package Items
--

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('multi_pack_enabled', '0');

ALTER TABLE `ospos_items`
  ADD COLUMN `qty_per_pack` decimal(15,3) NOT NULL DEFAULT 1 AFTER `tax_category_id`,
  ADD COLUMN `pack_name` varchar(8) DEFAULT 'Each' AFTER `qty_per_pack`,
  ADD COLUMN `low_sell_item_id` int(10) DEFAULT 0 AFTER `pack_name`;

UPDATE `ospos_items`
  SET `low_sell_item_id` = `item_id`
  WHERE `low_sell_item_id` = 0;

--
-- Add support for Discount on Sales Fixed
--

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('default_sales_discount_type', '0');

ALTER TABLE `ospos_item_kits`
    CHANGE COLUMN `kit_discount_percent` `kit_discount` DECIMAL(15,2) NOT NULL DEFAULT 0 AFTER `item_id`,
    ADD COLUMN `kit_discount_type` TINYINT(2) NOT NULL DEFAULT '0' AFTER `kit_discount`;

ALTER TABLE `ospos_customers`
    CHANGE COLUMN `discount_percent` `discount` DECIMAL(15,2) NOT NULL DEFAULT 0 AFTER `sales_tax_code`,
    ADD COLUMN `discount_type` TINYINT(2) NOT NULL DEFAULT '0' AFTER `discount`;

ALTER TABLE `ospos_sales_items`
    CHANGE COLUMN `discount_percent` `discount` DECIMAL(15,2) NOT NULL DEFAULT 0 AFTER `item_unit_price`,
    ADD COLUMN `discount_type` TINYINT(2) NOT NULL DEFAULT '0' AFTER `discount`;

ALTER TABLE `ospos_receivings_items`
    CHANGE COLUMN `discount_percent` `discount` DECIMAL(15,2) NOT NULL DEFAULT 0 AFTER `item_unit_price`,
    ADD COLUMN `discount_type` TINYINT(2) NOT NULL DEFAULT '0' AFTER `discount`;

--
-- Add support for module cashups
--

-- Set config module sort number to one of the latest

UPDATE `ospos_modules`
SET `sort` = 900
WHERE `name_lang_key` = 'module_config';

-- Add cashup module

INSERT INTO `ospos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
('module_cashups', 'module_cashups_desc', 110, 'cashups');

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('cashups', 'cashups');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`) VALUES
('cashups', 1);

-- Table structure for table `ospos_cash_up`

CREATE TABLE `ospos_cash_up` (
  `cashup_id` int(10) NOT NULL,
  `open_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `close_date` timestamp NULL,
  `open_amount_cash` decimal(15,2) NOT NULL,
  `transfer_amount_cash` decimal(15,2) NOT NULL,
  `note` int(1) NOT NULL,
  `closed_amount_cash` decimal(15,2) NOT NULL,
  `closed_amount_card` decimal(15,2) NOT NULL,
  `closed_amount_check` decimal(15,2) NOT NULL,
  `closed_amount_total` decimal(15,2) NOT NULL,
  `description` varchar(255) NOT NULL,
  `open_employee_id` int(10) NOT NULL,
  `close_employee_id` int(10) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Indexes for table `ospos_cash_up`

ALTER TABLE `ospos_cash_up`
  ADD PRIMARY KEY (`cashup_id`),
  ADD KEY `open_employee_id` (`open_employee_id`),
  ADD KEY `close_employee_id` (`close_employee_id`),
  ADD CONSTRAINT `ospos_cash_up_ibfk_1` FOREIGN KEY (`open_employee_id`) REFERENCES `ospos_employees` (`person_id`),
  ADD CONSTRAINT `ospos_cash_up_ibfk_2` FOREIGN KEY (`close_employee_id`) REFERENCES `ospos_employees` (`person_id`);

-- AUTO_INCREMENT for table `ospos_cash_up`

ALTER TABLE `ospos_cash_up`
  MODIFY `cashup_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

-- Change collation on columns to be utf8_general_ci

ALTER TABLE ospos_cash_up CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_expense_categories CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE ospos_expenses CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Add amount due

ALTER TABLE `ospos_cash_up`
  ADD `closed_amount_due` decimal(15,2) NOT NULL;

--
-- Add Suppliers category
--

ALTER TABLE `ospos_suppliers`
  ADD COLUMN `category` TINYINT NOT NULL;

UPDATE `ospos_suppliers`
  SET `category` = 0;


--
-- Link Expenses with Suppliers
--

-- Add supplier id

ALTER TABLE `ospos_expenses`
  ADD COLUMN `supplier_id` int(10) NULL;

-- Link suppliers

UPDATE `ospos_expenses`
  INNER JOIN `ospos_suppliers`
    ON `ospos_expenses`.`supplier_name` = `ospos_suppliers`.`company_name`
SET `ospos_expenses`.`supplier_id` = `ospos_suppliers`.`person_id`;

-- Save name in description for those expenses whose supplier isn't registered

UPDATE `ospos_expenses`
  SET `description` = CONCAT(`description`, CONCAT('\nSupplier name: ', `supplier_name`))
  WHERE `supplier_id` is NULL;

-- Add foreign key

ALTER TABLE `ospos_expenses`
  ADD CONSTRAINT `ospos_expenses_ibfk_3` FOREIGN KEY (`supplier_id`) REFERENCES `ospos_suppliers` (`person_id`);

-- Delete supplier name

ALTER TABLE `ospos_expenses`
  DROP COLUMN `supplier_name`;

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
  ('default_receivings_discount_type', '0'),
  ('default_receivings_discount', '0');

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_add_iso_4217.sql
-- -----------------------------------------------------------------------------

INSERT INTO
`ospos_app_config` (`key`,`value`)
VALUES
('currency_code','');

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_attributes.sql
-- -----------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `ospos_attribute_definitions` (
 `definition_id` INT(10) NOT NULL AUTO_INCREMENT,
 `definition_name` VARCHAR(255) NOT NULL,
 `definition_type` VARCHAR(45) NOT NULL,
 `definition_flags` TINYINT(4) NOT NULL,
 `definition_fk` INT(10) NULL,
 `deleted` TINYINT(1) NOT NULL DEFAULT 0,
 PRIMARY KEY (`definition_id`),
 KEY `definition_fk` (`definition_fk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `ospos_attribute_values` (
 `attribute_id` INT NOT NULL AUTO_INCREMENT,
 `attribute_value` VARCHAR(255) UNIQUE NULL,
 `attribute_datetime` DATETIME NULL,
 PRIMARY KEY (`attribute_id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `ospos_attribute_links` (
 `attribute_id` INT NULL,
 `definition_id` INT NOT NULL,
 `item_id` INT NULL,
 `sale_id` INT NULL,
 `receiving_id` INT NULL,
 KEY `attribute_id` (`attribute_id`),
 KEY `definition_id` (`definition_id`),
 KEY `item_id` (`item_id`),
 KEY `sale_id` (`sale_id`),
 KEY `receiving_id` (`receiving_id`),
 UNIQUE `attribute_links_uq1` (`attribute_id`, `definition_id`, `item_id`, `sale_id`, `receiving_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


ALTER TABLE `ospos_attribute_definitions`
 ADD CONSTRAINT `fk_ospos_attribute_definitions_ibfk_1` FOREIGN KEY (`definition_fk`) REFERENCES `ospos_attribute_definitions` (`definition_id`);


ALTER TABLE `ospos_attribute_links`
 ADD CONSTRAINT `ospos_attribute_links_ibfk_1` FOREIGN KEY (`definition_id`) REFERENCES `ospos_attribute_definitions` (`definition_id`) ON DELETE CASCADE,
 ADD CONSTRAINT `ospos_attribute_links_ibfk_2` FOREIGN KEY (`attribute_id`) REFERENCES `ospos_attribute_values` (`attribute_id`) ON DELETE CASCADE,
 ADD CONSTRAINT `ospos_attribute_links_ibfk_3` FOREIGN KEY (`item_id`)  REFERENCES `ospos_items` (`item_id`),
 ADD CONSTRAINT `ospos_attribute_links_ibfk_4` FOREIGN KEY (`receiving_id`) REFERENCES `ospos_receivings` (`receiving_id`),
 ADD CONSTRAINT `ospos_attribute_links_ibfk_5` FOREIGN KEY (`sale_id`) REFERENCES `ospos_sales` (`sale_id`);

INSERT INTO `ospos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
 ('module_attributes', 'module_attributes_desc', 107, 'attributes');

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
 ('attributes', 'attributes');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`, `menu_group`) VALUES
 ('attributes', 1, 'office');

-- migrate custom fields to text attributes
-- NOTE: items with custom attributes won't keep their selected category!!
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom1_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom2_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom3_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom4_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom5_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom6_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom7_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom8_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom9_name' AND `value` <> '';
INSERT INTO `ospos_attribute_definitions` (definition_name, definition_type, definition_flags) SELECT `value`, 'TEXT', 1 FROM ospos_app_config WHERE `key` = 'custom10_name' AND `value` <> '';

INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom1_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom1 IS NOT NULL AND custom1 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom2_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom2 IS NOT NULL AND custom2 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom3_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom3 IS NOT NULL AND custom3 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom4_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom4 IS NOT NULL AND custom4 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom5_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom5 IS NOT NULL AND custom5 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom6_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom6 IS NOT NULL AND custom6 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom7_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom7 IS NOT NULL AND custom7 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom8_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom8 IS NOT NULL AND custom8 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom9_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom9 IS NOT NULL AND custom9 != '';
INSERT INTO ospos_attribute_links (definition_id, item_id) SELECT definition_id, item_id FROM ospos_attribute_definitions, ospos_app_config, ospos_items
 WHERE ospos_app_config.`key` = 'custom10_name' AND ospos_app_config.`value` = ospos_attribute_definitions.definition_name AND custom10 IS NOT NULL AND custom10 != '';

INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom1 FROM ospos_items WHERE custom1 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom1_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom2 FROM ospos_items WHERE custom2 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom2_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom3 FROM ospos_items WHERE custom3 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom3_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom4 FROM ospos_items WHERE custom4 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom4_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom5 FROM ospos_items WHERE custom5 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom5_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom6 FROM ospos_items WHERE custom6 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom6_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom7 FROM ospos_items WHERE custom7 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom7_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom8 FROM ospos_items WHERE custom8 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom8_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom9 FROM ospos_items WHERE custom9 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom9_name');
INSERT IGNORE INTO ospos_attribute_values (attribute_value) SELECT DISTINCT custom10 FROM ospos_items WHERE custom10 <> '' AND '' <> (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom10_name');

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom1
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom1_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom2
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom2_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom3
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom3_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom4
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom4_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom5
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom5_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom6
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom6_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom7
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom7_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom8
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom8_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom9
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom9_name' AND `value` IS NOT NULL));

UPDATE ospos_attribute_links
 INNER JOIN ospos_items ON ospos_attribute_links.item_id = ospos_items.item_id
 INNER JOIN ospos_attribute_values ON attribute_value = custom10
 SET ospos_attribute_links.attribute_id = ospos_attribute_values.attribute_id
 WHERE definition_id IN (SELECT definition_id FROM ospos_attribute_definitions
 WHERE definition_name = (SELECT `value` FROM ospos_app_config WHERE `key` = 'custom10_name' AND `value` IS NOT NULL));

ALTER TABLE `ospos_items`
 DROP COLUMN `custom1`,
 DROP COLUMN `custom2`,
 DROP COLUMN `custom3`,
 DROP COLUMN `custom4`,
 DROP COLUMN `custom5`,
 DROP COLUMN `custom6`,
 DROP COLUMN `custom7`,
 DROP COLUMN `custom8`,
 DROP COLUMN `custom9`,
 DROP COLUMN `custom10`;

 DELETE FROM `ospos_app_config` WHERE `key` IN ('custom1_name','custom2_name','custom3_name','custom4_name','custom5_name','custom6_name','custom7_name','custom8_name','custom9_name','custom10_name');

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_decimal_attribute_type.sql
-- -----------------------------------------------------------------------------

ALTER TABLE ospos_attribute_values
ADD COLUMN attribute_decimal DECIMAL(7,3) DEFAULT NULL AFTER attribute_datetime;

ALTER TABLE ospos_attribute_definitions
ADD COLUMN definition_unit VARCHAR(16) DEFAULT NULL AFTER definition_type;

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_fix_attribute_datetime.sql
-- -----------------------------------------------------------------------------

ALTER TABLE `ospos_attribute_values` CHANGE `attribute_datetime` `attribute_date` DATE DEFAULT NULL;

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_indiagst.sql
-- -----------------------------------------------------------------------------

-- --------------------------------
-- Start of India GST Tax Changes
-- --------------------------------

INSERT INTO `ospos_app_config` (`key`, `value`) VALUES
('include_hsn', '0'),
('invoice_type', 'invoice'),
('default_tax_jurisdiction', ''),
('tax_id', '');

UPDATE `ospos_app_config`
    SET `key` = 'use_destination_based_tax'
    WHERE `key` = 'customer_sales_tax_support';

UPDATE `ospos_app_config`
    SET `key` = 'default_tax_code'
    WHERE `key` = 'default_origin_tax_code';

RENAME TABLE `ospos_tax_codes` TO `ospos_tax_codes_backup`;

CREATE TABLE IF NOT EXISTS `ospos_tax_codes` (
    `tax_code_id` int(11) NOT NULL AUTO_INCREMENT,
    `tax_code` varchar(32) NOT NULL,
    `tax_code_name` varchar(255) NOT NULL DEFAULT '',
    `city` varchar(255) NOT NULL DEFAULT '',
    `state` varchar(255) NOT NULL DEFAULT '',
    `deleted` int(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`tax_code_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

ALTER TABLE `ospos_customers`
    ADD COLUMN `tax_id` varchar(32) NOT NULL DEFAULT '' AFTER `taxable`,
    ADD COLUMN `sales_tax_code_id` int(11) DEFAULT NULL AFTER `tax_id`;

ALTER TABLE `ospos_items`
    ADD COLUMN `hsn_code` varchar(32) NOT NULL DEFAULT '' AFTER `low_sell_item_id`;

ALTER TABLE `ospos_sales_items_taxes`
    ADD COLUMN `sales_tax_code_id` int(11) DEFAULT NULL AFTER `item_tax_amount`,
    ADD COLUMN `jurisdiction_id` int(11) DEFAULT NULL AFTER `sales_tax_code_id`,
    ADD COLUMN `tax_category_id` int(11) DEFAULT NULL AFTER `jurisdiction_id`,
    DROP COLUMN `cascade_tax`;

RENAME TABLE `ospos_sales_taxes` TO `ospos_sales_taxes_backup`;

CREATE TABLE `ospos_sales_taxes` (
    `sales_taxes_id` int(11) NOT NULL AUTO_INCREMENT,
    `sale_id` int(10) NOT NULL,
    `jurisdiction_id` int(11) DEFAULT NULL,
    `tax_category_id` int(11) DEFAULT NULL,
    `tax_type` smallint(2) NOT NULL,
    `tax_group` varchar(32) NOT NULL,
    `sale_tax_basis` decimal(15,4) NOT NULL,
    `sale_tax_amount` decimal(15,4) NOT NULL,
    `print_sequence` tinyint(2) NOT NULL DEFAULT 0,
    `name` varchar(255) NOT NULL,
    `tax_rate` decimal(15,4) NOT NULL,
    `sales_tax_code_id` int(11)  DEFAULT NULL,
    `rounding_code` tinyint(2) NOT NULL DEFAULT 0,
    PRIMARY KEY (`sales_taxes_id`),
    KEY `print_sequence` (`sale_id`,`print_sequence`,`tax_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `ospos_tax_jurisdictions` (
    `jurisdiction_id` int(11) NOT NULL AUTO_INCREMENT,
    `jurisdiction_name` varchar(255) DEFAULT NULL,
    `tax_group` varchar(32) NOT NULL,
    `tax_type` smallint(2) NOT NULL,
    `reporting_authority` varchar(255) DEFAULT NULL,
    `tax_group_sequence` tinyint(2) NOT NULL DEFAULT 0,
    `cascade_sequence` tinyint(2) NOT NULL DEFAULT 0,
    `deleted` int(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`jurisdiction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci AUTO_INCREMENT=1;

ALTER TABLE `ospos_suppliers`
    ADD COLUMN `tax_id` varchar(32) DEFAULT NULL AFTER `account_number`;

ALTER TABLE `ospos_tax_categories`
    ADD COLUMN `deleted` int(1) NOT NULL DEFAULT 0 AFTER `tax_group_sequence`;

RENAME TABLE `ospos_tax_code_rates` TO `ospos_tax_code_rates_backup`;

CREATE TABLE IF NOT EXISTS `ospos_tax_rates` (
    `tax_rate_id` int(11) NOT NULL AUTO_INCREMENT,
    `rate_tax_code_id` int(11) NOT NULL,
    `rate_tax_category_id` int(10) NOT NULL,
    `rate_jurisdiction_id` int(11) NOT NULL,
    `tax_rate` decimal(15,4) NOT NULL DEFAULT 0.0000,
    `tax_rounding_code` tinyint(2) NOT NULL DEFAULT 0,
    PRIMARY KEY (`tax_rate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Add support for sales tax report

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('reports_sales_taxes', 'reports');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`, `menu_group`) VALUES
('reports_sales_taxes', 1, 'home');

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_indiagst1.sql
-- -----------------------------------------------------------------------------

UPDATE `ospos_suppliers`
  SET `tax_id` = ''
  WHERE `tax_id` IS NULL;

ALTER TABLE `ospos_suppliers`
  CHANGE COLUMN `tax_id` `tax_id` varchar(32) NOT NULL DEFAULT '';

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_indiagst2.sql
-- -----------------------------------------------------------------------------

-- This is to cleanup any orphaned tax migration tables

DROP TABLE IF EXISTS `ospos_tax_codes_backup`;
DROP TABLE IF EXISTS `ospos_sales_taxes_backup`;
DROP TABLE IF EXISTS `ospos_tax_code_rates_backup`;

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_paymenttracking.sql
-- -----------------------------------------------------------------------------

-- Improve payment tracking

RENAME TABLE ospos_sales_payments TO ospos_sales_payments_backup;

CREATE TABLE `ospos_sales_payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(10) NOT NULL,
  `payment_type` varchar(40) NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `payment_user` int(11) NOT NULL DEFAULT 0,
  `payment_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_code` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`payment_id`),
  KEY `payment_sale` (`sale_id`, `payment_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO ospos_sales_payments (sale_id, payment_type, payment_amount, payment_user)
SELECT payments.sale_id, payments.payment_type, payments.payment_amount, sales.employee_id
FROM ospos_sales_payments_backup AS payments
JOIN ospos_sales AS sales ON payments.sale_id = sales.sale_id
ORDER BY payments.sale_id, payments.payment_type;

DROP TABLE IF EXISTS ospos_sales_payments_backup;

ALTER TABLE `ospos_sales_payments`
  ADD CONSTRAINT `ospos_sales_payments_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `ospos_sales` (`sale_id`);

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_refundtracking.sql
-- -----------------------------------------------------------------------------

ALTER TABLE `ospos_sales_payments`
    ADD COLUMN `cash_refund` decimal(15,2) NOT NULL DEFAULT 0 AFTER `payment_amount`,
    CHANGE `payment_user` `employee_id` int(11) DEFAULT NULL,
    CHANGE `payment_date` `payment_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- -----------------------------------------------------------------------------
-- Script: 3.3.0_dbfix.sql
-- -----------------------------------------------------------------------------

ALTER TABLE `ospos_sales_payments` ADD INDEX `employee_id` (`employee_id`);

ALTER TABLE `ospos_sales_payments`
  ADD CONSTRAINT `ospos_sales_payments_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `ospos_employees` (`person_id`);

ALTER TABLE `ospos_customers` ADD INDEX `sales_tax_code_id` (`sales_tax_code_id`);

ALTER TABLE `ospos_customers`
  ADD CONSTRAINT `ospos_customers_ibfk_3` FOREIGN KEY (`sales_tax_code_id`) REFERENCES `ospos_tax_codes` (`tax_code_id`);

ALTER TABLE `ospos_tax_rates` ADD INDEX `rate_tax_category_id` (`rate_tax_category_id`);

ALTER TABLE `ospos_tax_rates`
  ADD CONSTRAINT `ospos_tax_rates_ibfk_1` FOREIGN KEY (`rate_tax_category_id`) REFERENCES `ospos_tax_categories` (`tax_category_id`);

ALTER TABLE `ospos_tax_rates` ADD INDEX `rate_tax_code_id` (`rate_tax_code_id`);

ALTER TABLE `ospos_tax_rates`
  ADD CONSTRAINT `ospos_tax_rates_ibfk_2` FOREIGN KEY (`rate_tax_code_id`) REFERENCES `ospos_tax_codes` (`tax_code_id`);

ALTER TABLE `ospos_tax_rates` ADD INDEX `rate_jurisdiction_id` (`rate_jurisdiction_id`);

ALTER TABLE `ospos_tax_rates`
  ADD CONSTRAINT `ospos_tax_rates_ibfk_3` FOREIGN KEY (`rate_jurisdiction_id`) REFERENCES `ospos_tax_jurisdictions` (`jurisdiction_id`);

ALTER TABLE `ospos_receivings` ADD INDEX `receiving_time` (`receiving_time`);

ALTER TABLE `ospos_sales_payments` ADD INDEX `payment_time` (`payment_time`);

ALTER TABLE `ospos_inventory` ADD INDEX `trans_date` (`trans_date`);

ALTER TABLE `ospos_expenses` ADD INDEX `date` (`date`);

-- -----------------------------------------------------------------------------
-- Script: 3.3.2_modify_attr_links_constraint.sql
-- -----------------------------------------------------------------------------

ALTER TABLE `ospos_attribute_links`
DROP FOREIGN KEY `ospos_attribute_links_ibfk_4`;

ALTER TABLE `ospos_attribute_links`
ADD CONSTRAINT `ospos_attribute_links_ibfk_4`
FOREIGN KEY (`receiving_id`) REFERENCES `ospos_receivings`(`receiving_id`)
ON DELETE CASCADE
ON UPDATE RESTRICT;

-- -----------------------------------------------------------------------------
-- Script: 3.3.2_paymentdatefix.sql
-- -----------------------------------------------------------------------------

UPDATE `ospos_sales_payments`
  JOIN `ospos_sales` ON `ospos_sales`.`sale_id`=`ospos_sales_payments`.`sale_id`
  SET `ospos_sales_payments`.`payment_time`=`ospos_sales`.`sale_time`;

-- -----------------------------------------------------------------------------
-- Script: 3.3.2_saleschangeprice.sql
-- -----------------------------------------------------------------------------

INSERT INTO `ospos_permissions` (`permission_id`, `module_id`) VALUES
('sales_change_price', 'sales');

INSERT INTO `ospos_grants` (`permission_id`, `person_id`, `menu_group`) VALUES
('sales_change_price', 1, '--');

-- -----------------------------------------------------------------------------
-- Script: 3.3.3_add_kits_item_number.sql
-- -----------------------------------------------------------------------------

ALTER TABLE `ospos_item_kits`
ADD COLUMN `item_kit_number` VARCHAR(255) DEFAULT NULL AFTER `item_kit_id`,
ADD KEY `item_kit_number` (`item_kit_number`);

-- -----------------------------------------------------------------------------
-- Script: 3.3.4_modify_session_datatype.sql
-- -----------------------------------------------------------------------------

ALTER TABLE `ospos_sessions`
  MODIFY COLUMN `data` MEDIUMBLOB NOT NULL;

-- -----------------------------------------------------------------------------
-- Script: 3.4.0_attribute_links_unique_constraint.sql
-- -----------------------------------------------------------------------------

# Prevents duplicate attribute links with the same definition_id and item_id.
# This accounts for dropdown rows (null item_id) and rows associated with sales or receivings.
ALTER TABLE `ospos_attribute_links`
    ADD COLUMN `generated_unique_column` VARCHAR(255) GENERATED ALWAYS AS (
        CASE
            WHEN `sale_id` IS NULL AND `receiving_id` IS NULL AND `item_id` IS NOT NULL THEN CONCAT(`definition_id`, '-', `item_id`)
            ELSE NULL
        END
        ) STORED,
    ADD UNIQUE INDEX `attribute_links_uq3` (`generated_unique_column`);


-- -----------------------------------------------------------------------------
-- Script: 3.4.0_CI4Conversion.sql
-- -----------------------------------------------------------------------------


DROP TABLE `ospos_sessions`;

CREATE TABLE IF NOT EXISTS `ospos_sessions` (
    `id` varchar(128) NOT NULL,
    `ip_address` varchar(45) NOT NULL,
    `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    `data` blob NOT NULL,
    KEY `ospos_sessions_timestamp` (`timestamp`)
    );

ALTER TABLE ospos_sessions ADD PRIMARY KEY (id, ip_address);

UPDATE `ospos_app_config`
SET `value` = REPLACE(value, '|', ',')
WHERE `key` = 'image_allowed_types';

-- due to language rename, reset to english
UPDATE `ospos_app_config` SET `value` = 'en' WHERE `key` = 'language_code' ;
UPDATE `ospos_app_config` SET `value` = 'english' WHERE `key` = 'language' ;

-- -----------------------------------------------------------------------------
-- Script: 3.4.0_database_optimizations.sql
-- -----------------------------------------------------------------------------

#ospos_attribute_values table
ALTER TABLE `ospos_attribute_values` ADD UNIQUE(`attribute_date`);
ALTER TABLE `ospos_attribute_values` ADD UNIQUE(`attribute_decimal`);

#opsos_attribute_definitions table
ALTER TABLE `ospos_attribute_definitions` MODIFY `definition_flags` tinyint(1) NOT NULL;
ALTER TABLE `ospos_attribute_definitions` ADD INDEX(`definition_name`);
ALTER TABLE `ospos_attribute_definitions` ADD INDEX(`definition_type`);

#ospos_cash_up table
ALTER TABLE `ospos_cash_up` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_customers table
ALTER TABLE `ospos_customers` MODIFY `taxable` tinyint(1) DEFAULT 1 NOT NULL;
ALTER TABLE `ospos_customers` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_customers` MODIFY `discount_type` tinyint(1) DEFAULT 0 NOT NULL;


#ospos_customers_packages table
ALTER TABLE `ospos_customers_packages` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_dinner_tables table
ALTER TABLE `ospos_dinner_tables` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_dinner_tables` ADD INDEX(`status`);

#ospos_employees table
ALTER TABLE `ospos_employees` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_employees` MODIFY `hash_version` tinyint(1) DEFAULT 2 NOT NULL;


#ospos_expenses table
ALTER TABLE `ospos_expenses` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_expenses` ADD INDEX(`payment_type`);
ALTER TABLE `ospos_expenses` ADD INDEX(`amount`);

#ospos_expenses_categories table
ALTER TABLE `ospos_expense_categories` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_expense_categories` ADD INDEX(`category_description`);

#ospos_giftcards table
ALTER TABLE `ospos_giftcards` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_items table
ALTER TABLE `ospos_items` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_items` MODIFY `stock_type` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_items` MODIFY `item_type` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_items` ADD INDEX(`deleted`, `item_type`);
ALTER TABLE `ospos_items` ADD INDEX (`item_id`,`deleted`);
ALTER TABLE `ospos_items` ADD UNIQUE INDEX `items_uq1` (`supplier_id`, `item_id`, `deleted`, `item_type`);

#ospos_item_kits table
ALTER TABLE `ospos_item_kits` MODIFY `kit_discount_type` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_item_kits` MODIFY `price_option` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_item_kits` MODIFY `print_option` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_item_kits` ADD INDEX(`name`,`description`);

#ospos_people table
ALTER TABLE `ospos_people` ADD INDEX(`first_name`(191), `last_name`(191), `email`(191), `phone_number`(191));

#ospos_receivings_items
ALTER TABLE `ospos_receivings_items` MODIFY `discount_type` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_sales
ALTER TABLE `ospos_sales` MODIFY `sale_status` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_sales` MODIFY `sale_type` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_sales_items
ALTER TABLE `ospos_sales_items` MODIFY `discount_type` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_sales_items` MODIFY `print_option` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_sales_items_taxes
ALTER TABLE `ospos_sales_items_taxes` MODIFY `tax_type` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_sales_items_taxes` MODIFY `rounding_code` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_sales_items_taxes` MODIFY `cascade_sequence` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_sales_taxes
ALTER TABLE `ospos_sales_taxes` MODIFY `print_sequence` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_sales_taxes` MODIFY `rounding_code` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_sessions table
ALTER TABLE `ospos_sessions` ADD INDEX(`id`);
ALTER TABLE `ospos_sessions` ADD INDEX(`ip_address`);

#ospos_stock_locations table
ALTER TABLE `ospos_stock_locations` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_suppliers table
ALTER TABLE `ospos_suppliers` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_suppliers` MODIFY `category` tinyint(1) NOT NULL;
ALTER TABLE `ospos_suppliers` ADD INDEX(`category`);
ALTER TABLE `ospos_suppliers` ADD INDEX(`company_name`, `deleted`);


#ospos_tax_categories table
ALTER TABLE `ospos_tax_categories` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_tax_categories` MODIFY `tax_group_sequence` tinyint(1) NOT NULL;

#ospos_tax_jurisdictions table
ALTER TABLE `ospos_tax_jurisdictions` MODIFY `deleted` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_tax_jurisdictions` MODIFY `tax_group_sequence` tinyint(1) DEFAULT 0 NOT NULL;
ALTER TABLE `ospos_tax_jurisdictions` MODIFY `cascade_sequence` tinyint(1) DEFAULT 0 NOT NULL;

#ospos_tax_rates table
ALTER TABLE `ospos_tax_rates` MODIFY `tax_rounding_code` tinyint(1) DEFAULT 0 NOT NULL;

-- -----------------------------------------------------------------------------
-- Script: 3.4.1_attribute_links_unique_constraint.sql
-- -----------------------------------------------------------------------------

ALTER TABLE `ospos_attribute_links`
    DROP FOREIGN KEY `ospos_attribute_links_ibfk_1`,
    DROP FOREIGN KEY `ospos_attribute_links_ibfk_2`;
ALTER TABLE `ospos_attribute_links` ADD CONSTRAINT `ospos_attribute_links_ibfk_1` FOREIGN KEY (`definition_id`) REFERENCES `ospos_attribute_definitions` (`definition_id`) ON DELETE RESTRICT;
ALTER TABLE `ospos_attribute_links` ADD CONSTRAINT `ospos_attribute_links_ibfk_2` FOREIGN KEY (`attribute_id`) REFERENCES `ospos_attribute_values` (`attribute_id`) ON DELETE RESTRICT;

-- -----------------------------------------------------------------------------
-- Script: 3.4.1_migrate_sessions_table.sql
-- -----------------------------------------------------------------------------

DROP TABLE IF EXISTS `ospos_sessions`;
CREATE TABLE IF NOT EXISTS `ospos_sessions` (
    `id` varchar(128) NOT null,
    `ip_address` varchar(45) NOT null,
    `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP NOT null,
    `data` blob NOT null,
    KEY `ospos_sessions_timestamp` (`timestamp`)
);

ALTER TABLE ospos_sessions ADD PRIMARY KEY (id, ip_address);

-- -----------------------------------------------------------------------------
-- Script: 3.4.2_missing_config_keys.sql
-- -----------------------------------------------------------------------------

INSERT IGNORE INTO ospos_app_config (`key`, `value`)
VALUES
    ('msg_msg', ''),
    ('msg_pwd', ''),
    ('msg_uid', ''),
    ('msg_src', ''),
    ('smtp_timeout', 5000),
    ('smtp_crypto', 'tls'),
    ('smtp_port', 587),
    ('mailpath', '/usr/bin/sendmail'),
    ('protocol', 'sendmail');

-- -----------------------------------------------------------------------------
-- Script: 3.4.2_nullable_tax_category_id.sql
-- -----------------------------------------------------------------------------

-- Migration to make tax_category_id nullable in ospos_items
ALTER TABLE ospos_items
    MODIFY COLUMN tax_category_id INT NULL;

-- -----------------------------------------------------------------------------
-- Script: 3.4.3_mysql84_utf8mb4_conversion.sql
-- -----------------------------------------------------------------------------

-- Convert all tables to utf8mb4 for MySQL 8.4 compatibility
-- Foreign keys are dropped and recreated in the PHP migration to avoid collation mismatches
ALTER TABLE ospos_app_config CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_attribute_definitions CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_attribute_links CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_attribute_values CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_cash_up CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_customers CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_customers_packages CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_customers_points CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_dinner_tables CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_employees CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_expenses CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_expense_categories CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_giftcards CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_grants CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_inventory CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_items CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_items_taxes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_item_kits CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_item_kit_items CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_item_quantities CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_modules CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_people CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_permissions CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_receivings CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_receivings_items CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_sales CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_sales_items CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_sales_items_taxes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_sales_payments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_sales_reward_points CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_sales_taxes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_sessions CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_stock_locations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_suppliers CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_tax_categories CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_tax_codes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_tax_jurisdictions CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
ALTER TABLE ospos_tax_rates CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;

-- Restore suspended-sale tables used by the current application after the legacy migration.
CREATE TABLE `ospos_sales_suspended` (
    `sale_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `customer_id` int(10) DEFAULT NULL,
    `employee_id` int(10) NOT NULL DEFAULT '0',
    `comment` text NOT NULL,
    `invoice_number` varchar(32) DEFAULT NULL,
    `quote_number` varchar(32) DEFAULT NULL,
    `dinner_table_id` int(11) DEFAULT NULL,
    `sale_id` int(10) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`sale_id`),
    KEY `customer_id` (`customer_id`),
    KEY `employee_id` (`employee_id`),
    KEY `dinner_table_id` (`dinner_table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE `ospos_sales_suspended_items` (
    `sale_id` int(10) NOT NULL DEFAULT '0',
    `item_id` int(10) NOT NULL DEFAULT '0',
    `description` varchar(30) DEFAULT NULL,
    `serialnumber` varchar(30) DEFAULT NULL,
    `line` int(3) NOT NULL DEFAULT '0',
    `quantity_purchased` decimal(15,3) NOT NULL DEFAULT '0',
    `item_cost_price` decimal(15,2) NOT NULL,
    `item_unit_price` decimal(15,2) NOT NULL,
    `discount_percent` decimal(15,2) NOT NULL DEFAULT '0',
    `item_location` int(11) NOT NULL,
    `print_option` tinyint(2) NOT NULL DEFAULT '0',
    PRIMARY KEY (`sale_id`,`item_id`,`line`),
    KEY `sale_id` (`sale_id`),
    KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE `ospos_sales_suspended_items_taxes` (
    `sale_id` int(10) NOT NULL,
    `item_id` int(10) NOT NULL,
    `line` int(3) NOT NULL DEFAULT '0',
    `name` varchar(255) NOT NULL,
    `percent` decimal(15,3) NOT NULL,
    PRIMARY KEY (`sale_id`,`item_id`,`line`,`name`,`percent`),
    KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE `ospos_sales_suspended_payments` (
    `sale_id` int(10) NOT NULL,
    `payment_type` varchar(40) NOT NULL,
    `payment_amount` decimal(15,2) NOT NULL,
    PRIMARY KEY (`sale_id`,`payment_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Constraints for dumped tables
--

--
-- Constraints for table `ospos_customers`
--
ALTER TABLE `ospos_customers`
    ADD CONSTRAINT `ospos_customers_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `ospos_people` (`person_id`);

--
-- Constraints for table `ospos_employees`
--
ALTER TABLE `ospos_employees`
    ADD CONSTRAINT `ospos_employees_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `ospos_people` (`person_id`);

--
-- Constraints for table `ospos_inventory`
--
ALTER TABLE `ospos_inventory`
    ADD CONSTRAINT `ospos_inventory_ibfk_1` FOREIGN KEY (`trans_items`) REFERENCES `ospos_items` (`item_id`),
    ADD CONSTRAINT `ospos_inventory_ibfk_2` FOREIGN KEY (`trans_user`) REFERENCES `ospos_employees` (`person_id`),
    ADD CONSTRAINT `ospos_inventory_ibfk_3` FOREIGN KEY (`trans_location`) REFERENCES `ospos_stock_locations` (`location_id`);

--
-- Constraints for table `ospos_items`
--
ALTER TABLE `ospos_items`
    ADD CONSTRAINT `ospos_items_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `ospos_suppliers` (`person_id`);

--
-- Constraints for table `ospos_items_taxes`
--
ALTER TABLE `ospos_items_taxes`
    ADD CONSTRAINT `ospos_items_taxes_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`) ON DELETE CASCADE;

--
-- Constraints for table `ospos_item_kit_items`
--
ALTER TABLE `ospos_item_kit_items`
    ADD CONSTRAINT `ospos_item_kit_items_ibfk_1` FOREIGN KEY (`item_kit_id`) REFERENCES `ospos_item_kits` (`item_kit_id`) ON DELETE CASCADE,
    ADD CONSTRAINT `ospos_item_kit_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`)  ON DELETE CASCADE;

--
-- Constraints for table `ospos_permissions`
--
ALTER TABLE `ospos_permissions`
    ADD CONSTRAINT `ospos_permissions_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `ospos_modules` (`module_id`) ON DELETE CASCADE,
    ADD CONSTRAINT `ospos_permissions_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `ospos_stock_locations` (`location_id`) ON DELETE CASCADE;

--
-- Constraints for table `ospos_grants`
--
ALTER TABLE `ospos_grants`
    ADD CONSTRAINT `ospos_grants_ibfk_1` foreign key (`permission_id`) references `ospos_permissions` (`permission_id`) ON DELETE CASCADE,
    ADD CONSTRAINT `ospos_grants_ibfk_2` foreign key (`person_id`) references `ospos_employees` (`person_id`) ON DELETE CASCADE;

--
-- Constraints for table `ospos_receivings`
--
ALTER TABLE `ospos_receivings`
    ADD CONSTRAINT `ospos_receivings_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `ospos_employees` (`person_id`),
    ADD CONSTRAINT `ospos_receivings_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `ospos_suppliers` (`person_id`);

--
-- Constraints for table `ospos_receivings_items`
--
ALTER TABLE `ospos_receivings_items`
    ADD CONSTRAINT `ospos_receivings_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`),
    ADD CONSTRAINT `ospos_receivings_items_ibfk_2` FOREIGN KEY (`receiving_id`) REFERENCES `ospos_receivings` (`receiving_id`);

--
-- Constraints for table `ospos_sales`
--
ALTER TABLE `ospos_sales`
    ADD CONSTRAINT `ospos_sales_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `ospos_employees` (`person_id`),
    ADD CONSTRAINT `ospos_sales_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `ospos_customers` (`person_id`);

--
-- Constraints for table `ospos_sales_items`
--
ALTER TABLE `ospos_sales_items`
    ADD CONSTRAINT `ospos_sales_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`),
    ADD CONSTRAINT `ospos_sales_items_ibfk_2` FOREIGN KEY (`sale_id`) REFERENCES `ospos_sales` (`sale_id`),
    ADD CONSTRAINT `ospos_sales_items_ibfk_3` FOREIGN KEY (`item_location`) REFERENCES `ospos_stock_locations` (`location_id`);

--
-- Constraints for table `ospos_sales_items_taxes`
--
ALTER TABLE `ospos_sales_items_taxes`
    ADD CONSTRAINT `ospos_sales_items_taxes_ibfk_1` FOREIGN KEY (`sale_id`,`item_id`,`line`) REFERENCES `ospos_sales_items` (`sale_id`,`item_id`,`line`),
    ADD CONSTRAINT `ospos_sales_items_taxes_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`);

--
-- Constraints for table `ospos_sales_payments`
--

--
-- Constraints for table `ospos_sales_suspended`
--
ALTER TABLE `ospos_sales_suspended`
    ADD CONSTRAINT `ospos_sales_suspended_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `ospos_employees` (`person_id`),
    ADD CONSTRAINT `ospos_sales_suspended_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `ospos_customers` (`person_id`);

--
-- Constraints for table `ospos_sales_suspended_items`
--
ALTER TABLE `ospos_sales_suspended_items`
    ADD CONSTRAINT `ospos_sales_suspended_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`),
    ADD CONSTRAINT `ospos_sales_suspended_items_ibfk_2` FOREIGN KEY (`sale_id`) REFERENCES `ospos_sales_suspended` (`sale_id`),
    ADD CONSTRAINT `ospos_sales_suspended_items_ibfk_3` FOREIGN KEY (`item_location`) REFERENCES `ospos_stock_locations` (`location_id`);

--
-- Constraints for table `ospos_sales_suspended_items_taxes`
--
ALTER TABLE `ospos_sales_suspended_items_taxes`
    ADD CONSTRAINT `ospos_sales_suspended_items_taxes_ibfk_1` FOREIGN KEY (`sale_id`,`item_id`,`line`) REFERENCES `ospos_sales_suspended_items` (`sale_id`,`item_id`,`line`),
    ADD CONSTRAINT `ospos_sales_suspended_items_taxes_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`);

--
-- Constraints for table `ospos_sales_suspended_payments`
--
ALTER TABLE `ospos_sales_suspended_payments`
    ADD CONSTRAINT `ospos_sales_suspended_payments_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `ospos_sales_suspended` (`sale_id`);

--
-- Constraints for table `ospos_item_quantities`
--
ALTER TABLE `ospos_item_quantities`
    ADD CONSTRAINT `ospos_item_quantities_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `ospos_items` (`item_id`),
    ADD CONSTRAINT `ospos_item_quantities_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `ospos_stock_locations` (`location_id`);

--
-- Constraints for table `ospos_suppliers`
--
ALTER TABLE `ospos_suppliers`
    ADD CONSTRAINT `ospos_suppliers_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `ospos_people` (`person_id`);

--
-- Constraints for table `ospos_giftcards`
--
ALTER TABLE `ospos_giftcards`
    ADD CONSTRAINT `ospos_giftcards_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `ospos_people` (`person_id`);

