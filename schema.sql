-- ============================================
-- GapTrack — Database Schema
-- نظام سد الفجوات في تتبع الشحنات
-- ============================================

CREATE DATABASE IF NOT EXISTS gaptrack CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE gaptrack;

-- جدول الشحنات
CREATE TABLE shipments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    origin VARCHAR(150) NOT NULL,
    destination VARCHAR(150) NOT NULL,
    type ENUM('land','sea') DEFAULT 'land',
    status VARCHAR(30) DEFAULT 'in_transit',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- جدول مناطق ضعف التغطية المعروفة
CREATE TABLE coverage_gap_zones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zone_name VARCHAR(100) NOT NULL,
    lat_min DECIMAL(10,6) NOT NULL,
    lat_max DECIMAL(10,6) NOT NULL,
    lng_min DECIMAL(10,6) NOT NULL,
    lng_max DECIMAL(10,6) NOT NULL,
    expected_gap_minutes INT DEFAULT 30
);

-- جدول تحديثات تتبع الشحنة (GPS)
CREATE TABLE tracking_updates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shipment_id INT NOT NULL,
    lat DECIMAL(10,6) NOT NULL,
    lng DECIMAL(10,6) NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    connection_status ENUM('connected','gap_zone','abnormal_gap') DEFAULT 'connected',
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE
);

-- جدول التنبيهات
CREATE TABLE alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shipment_id INT NOT NULL,
    alert_type ENUM('gap_zone_entry','abnormal_gap','delivered') NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE
);

-- ============================================
-- بيانات تجريبية أولية (اختياري)
-- ============================================

-- منطقة ضعف تغطية تجريبية (الربع الخالي)
INSERT INTO coverage_gap_zones (zone_name, lat_min, lat_max, lng_min, lng_max, expected_gap_minutes)
VALUES ('الربع الخالي', 18.000000, 22.000000, 48.000000, 53.000000, 45);

-- شحنة تجريبية بين الرياض وجدة (بري)
INSERT INTO shipments (origin, destination, type, status)
VALUES ('الرياض', 'جدة', 'land', 'in_transit');

-- نقاط تتبع تجريبية لنفس الشحنة
INSERT INTO tracking_updates (shipment_id, lat, lng, timestamp, connection_status) VALUES
(1, 24.7136, 46.6753, '2026-07-26 08:00:00', 'connected'),
(1, 23.8859, 45.0792, '2026-07-26 09:30:00', 'connected'),
(1, 22.0000, 43.5000, '2026-07-26 11:00:00', 'connected'),
(1, 21.4858, 39.1925, '2026-07-26 13:00:00', 'connected'),
(1, 20.5000, 50.0000, '2026-07-26 15:00:00', 'gap_zone');
