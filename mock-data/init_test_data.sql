-- 插入电站数据
INSERT INTO `power_station` VALUES ('ps-test-01', NULL, 'PS001', '测试光伏电站A', 0.50, 100.0000, 380.00, 116.4074, 39.9042, NULL, NULL, NOW(), 'admin', NOW(), 'admin', 1, 103);
INSERT INTO `power_station` VALUES ('ps-test-02', NULL, 'PS002', '测试光伏电站B', 0.45, 80.0000, 380.00, 116.3074, 39.8042, NULL, NULL, NOW(), 'admin', NOW(), 'admin', 1, 103);

-- 插入逆变器设备数据 (假设设备类型ID为 '1'，您可能需要根据实际 device_type 表调整)
-- 确保 device_type 表有数据，这里先插入一条逆变器类型测试数据
INSERT INTO `device_type` VALUES ('dt-test-01', '逆变器', 'Inverter', '光伏逆变器', 'admin', NOW(), 'admin', NOW());

-- 插入设备：逆变器1 (关联电站A)
INSERT INTO `device` VALUES ('dev-inv-01', 'ps-test-01', 'INV001', '逆变器-A1', 'dt-test-01', 50.00, '华为', 50.00, '低压并网', NULL, 0, NULL, NOW(), 'admin', NOW(), 'admin', 1, 103);
-- 插入设备：逆变器2 (关联电站B)
INSERT INTO `device` VALUES ('dev-inv-02', 'ps-test-02', 'INV002', '逆变器-B1', 'dt-test-01', 40.00, '阳光电源', 40.00, '低压并网', NULL, 0, NULL, NOW(), 'admin', NOW(), 'admin', 1, 103);

-- 插入发电数据 (electricity_data_item)
-- 模拟过去10天的数据，每天产生 峰、平、谷 三种类型的数据
-- 模拟2026年数据（因为您之前的错误信息里查询的是2026年）

-- 电站A的逆变器1数据
INSERT INTO `electricity_data_item` (`device_id`, `data_time`, `type`, `begin_time`, `end_time`, `value`, `cost`, `price`, `remark`, `create_time`, `create_by`) VALUES 
('dev-inv-01', '2026-02-19 08:00:00', 'peak', '2026-02-19 08:00:00', '2026-02-19 11:00:00', 50.5, 25.25, 0.5, '模拟数据', NOW(), 'admin'),
('dev-inv-01', '2026-02-19 12:00:00', 'flat', '2026-02-19 12:00:00', '2026-02-19 16:00:00', 80.0, 32.0, 0.4, '模拟数据', NOW(), 'admin'),
('dev-inv-01', '2026-02-19 18:00:00', 'valley', '2026-02-19 18:00:00', '2026-02-19 22:00:00', 20.0, 6.0, 0.3, '模拟数据', NOW(), 'admin'),
('dev-inv-01', '2026-02-20 08:00:00', 'peak', '2026-02-20 08:00:00', '2026-02-20 11:00:00', 55.0, 27.5, 0.5, '模拟数据', NOW(), 'admin');

-- 电站B的逆变器2数据
INSERT INTO `electricity_data_item` (`device_id`, `data_time`, `type`, `begin_time`, `end_time`, `value`, `cost`, `price`, `remark`, `create_time`, `create_by`) VALUES 
('dev-inv-02', '2026-02-19 08:00:00', 'peak', '2026-02-19 08:00:00', '2026-02-19 11:00:00', 40.0, 20.0, 0.5, '模拟数据', NOW(), 'admin'),
('dev-inv-02', '2026-02-19 12:00:00', 'flat', '2026-02-19 12:00:00', '2026-02-19 16:00:00', 60.0, 24.0, 0.4, '模拟数据', NOW(), 'admin'),
('dev-inv-02', '2026-02-20 08:00:00', 'peak', '2026-02-20 08:00:00', '2026-02-20 11:00:00', 45.0, 22.5, 0.5, '模拟数据', NOW(), 'admin');
