<?php
// جلب بيانات الاتصال من البيئة (تصلح للاستضافة) أو وضع القيم الافتراضية محلياً
$host     = getenv('DB_HOST')     ?: 'localhost';
$user     = getenv('DB_USER')     ?: 'root';
$pass     = getenv('DB_PASS')     ?: '';
$dbname   = getenv('DB_NAME')     ?: 'gaptrack_db';
$port     = getenv('DB_PORT')     ?: 3306;

$conn = new mysqli($host, $user, $pass, $dbname, $port);

if ($conn->connect_error) {
    die("خطأ في الاتصال بقاعدة البيانات: " . $conn->connect_error);
}

$conn->set_charset("utf8mb4");
?>
