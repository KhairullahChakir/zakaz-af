<?php
try {
    $pdo = new PDO('mysql:host=127.0.0.1;port=3307;dbname=zakaz_af', 'root', '');
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connected successfully\n";
    
    // 1. Check conversations
    $stmt = $pdo->query("SHOW TABLES LIKE 'conversations'");
    if ($stmt->rowCount() > 0) {
        echo "Table conversations exists\n";
    } else {
        echo "Table conversations MISSING. Creating...\n";
        $sql = "
        CREATE TABLE IF NOT EXISTS `conversations` (
          `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
          `customer_id` bigint(20) unsigned NOT NULL,
          `shop_id` bigint(20) unsigned NOT NULL,
          `product_id` bigint(20) unsigned DEFAULT NULL,
          `last_message_at` timestamp NULL DEFAULT NULL,
          `created_at` timestamp NULL DEFAULT NULL,
          `updated_at` timestamp NULL DEFAULT NULL,
          PRIMARY KEY (`id`),
          UNIQUE KEY `conversations_customer_id_shop_id_unique` (`customer_id`,`shop_id`),
          KEY `conversations_shop_id_foreign` (`shop_id`),
          KEY `conversations_product_id_foreign` (`product_id`),
          CONSTRAINT `conversations_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
          CONSTRAINT `conversations_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
          CONSTRAINT `conversations_shop_id_foreign` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        ";
        $pdo->exec($sql);
        echo "Table conversations created.\n";
    }

    // 2. Check messages
    $stmt2 = $pdo->query("SHOW TABLES LIKE 'messages'");
    if ($stmt2->rowCount() > 0) {
        echo "Table messages exists\n";
    } else {
        echo "Table messages MISSING. Creating...\n";
        $sql2 = "
        CREATE TABLE IF NOT EXISTS `messages` (
          `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
          `conversation_id` bigint(20) unsigned NOT NULL,
          `sender_id` bigint(20) unsigned NOT NULL,
          `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
          `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
          `is_read` tinyint(1) NOT NULL DEFAULT 0,
          `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
          `created_at` timestamp NULL DEFAULT NULL,
          `updated_at` timestamp NULL DEFAULT NULL,
          PRIMARY KEY (`id`),
          KEY `messages_conversation_id_foreign` (`conversation_id`),
          KEY `messages_sender_id_foreign` (`sender_id`),
          CONSTRAINT `messages_conversation_id_foreign` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
          CONSTRAINT `messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        ";
        $pdo->exec($sql2);
        echo "Table messages created.\n";
    }
    
    file_put_contents('db_success.txt', "Script finished.\n");
    
} catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    file_put_contents('db_error.txt', $e->getMessage());
}
