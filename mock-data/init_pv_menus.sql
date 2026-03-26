SET NAMES utf8mb4;

-- Top-level menus
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '实时监测',0,2,'realTime',NULL,NULL,1,0,'M','0','0',NULL,'monitor','admin',NOW(),'PV模块菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE path='realTime' AND menu_type='M');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '统计分析',0,3,'statistics',NULL,NULL,1,0,'M','0','0',NULL,'chart','admin',NOW(),'PV模块菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE path='statistics' AND menu_type='M');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '尖峰平台',0,4,'peaks',NULL,NULL,1,0,'M','0','0',NULL,'dashboard','admin',NOW(),'PV模块菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE path='peaks' AND menu_type='M');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '电能质量分析',0,5,'electric',NULL,NULL,1,0,'M','0','0',NULL,'guide','admin',NOW(),'PV模块菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE path='electric' AND menu_type='M');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '智能报警',0,6,'alarm',NULL,NULL,1,0,'M','0','0',NULL,'message','admin',NOW(),'PV模块菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE path='alarm' AND menu_type='M');

-- Children: 实时监测
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '实时数据', p.menu_id, 1, 'realData', 'realTime/realData', NULL, 1, 0, 'C','0','0', 'realTime:realData:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='realTime' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='realTime/realData');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '电站监测', p.menu_id, 2, 'site', 'realTime/site', NULL, 1, 0, 'C','0','0', 'realTime:site:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='realTime' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='realTime/site');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '设备监测', p.menu_id, 3, 'device', 'realTime/device', NULL, 1, 0, 'C','0','0', 'realTime:device:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='realTime' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='realTime/device');

-- Children: 统计分析
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '电站统计', p.menu_id, 1, 'siteSum', 'statistics/siteSum', NULL, 1, 0, 'C','0','0', 'statistics:siteSum:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='statistics' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='statistics/siteSum');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '设备统计', p.menu_id, 2, 'deviceSum', 'statistics/deviceSum', NULL, 1, 0, 'C','0','0', 'statistics:deviceSum:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='statistics' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='statistics/deviceSum');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '同比分析', p.menu_id, 3, 'sameAnalysis', 'statistics/sameAnalysis', NULL, 1, 0, 'C','0','0', 'statistics:sameAnalysis:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='statistics' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='statistics/sameAnalysis');

-- Children: 尖峰平台
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '尖峰占比', p.menu_id, 1, 'charts', 'peaks/charts', NULL, 1, 0, 'C','0','0', 'peaks:charts:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='peaks' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='peaks/charts');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '尖峰报表', p.menu_id, 2, 'report', 'peaks/report', NULL, 1, 0, 'C','0','0', 'peaks:report:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='peaks' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='peaks/report');

-- Children: 电能质量分析
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '负荷分析', p.menu_id, 1, 'loadAnalysis', 'electric/loadAnalysis', NULL, 1, 0, 'C','0','0', 'electric:loadAnalysis:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='electric' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='electric/loadAnalysis');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '功率因数分析', p.menu_id, 2, 'powerFactorAnalysis', 'electric/powerFactorAnalysis', NULL, 1, 0, 'C','0','0', 'electric:powerFactorAnalysis:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='electric' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='electric/powerFactorAnalysis');

INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '三相不平衡分析', p.menu_id, 3, 'threePhaseUnbalanceAnalysis', 'electric/threePhaseUnbalanceAnalysis', NULL, 1, 0, 'C','0','0', 'electric:threePhaseUnbalanceAnalysis:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='electric' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='electric/threePhaseUnbalanceAnalysis');

-- Children: 智能报警
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,query,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,remark)
SELECT '报警列表', p.menu_id, 1, 'alarmList', 'alarm/alarmList', NULL, 1, 0, 'C','0','0', 'alarm:alarmList:list', '#', 'admin', NOW(), 'PV模块菜单'
FROM sys_menu p WHERE p.path='alarm' AND p.menu_type='M'
AND NOT EXISTS (SELECT 1 FROM sys_menu WHERE component='alarm/alarmList');
