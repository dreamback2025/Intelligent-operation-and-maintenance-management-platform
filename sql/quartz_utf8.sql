DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- ----------------------------
-- 1銆佸瓨鍌ㄦ瘡涓€涓凡閰嶇疆鐨?jobDetail 鐨勮缁嗕俊鎭?-- ----------------------------
create table QRTZ_JOB_DETAILS
(
    sched_name        varchar(120) not null comment '璋冨害鍚嶇О',
    job_name          varchar(200) not null comment '浠诲姟鍚嶇О',
    job_group         varchar(200) not null comment '浠诲姟缁勫悕',
    description       varchar(250) null comment '鐩稿叧浠嬬粛',
    job_class_name    varchar(250) not null comment '鎵ц浠诲姟绫诲悕绉?,
    is_durable        varchar(1)   not null comment '鏄惁鎸佷箙鍖?,
    is_nonconcurrent  varchar(1)   not null comment '鏄惁骞跺彂',
    is_update_data    varchar(1)   not null comment '鏄惁鏇存柊鏁版嵁',
    requests_recovery varchar(1)   not null comment '鏄惁鎺ュ彈鎭㈠鎵ц',
    job_data          blob null comment '瀛樻斁鎸佷箙鍖杍ob瀵硅薄',
    primary key (sched_name, job_name, job_group)
) engine=innodb comment = '浠诲姟璇︾粏淇℃伅琛?;

-- ----------------------------
-- 2銆?瀛樺偍宸查厤缃殑 Trigger 鐨勪俊鎭?-- ----------------------------
create table QRTZ_TRIGGERS
(
    sched_name     varchar(120) not null comment '璋冨害鍚嶇О',
    trigger_name   varchar(200) not null comment '瑙﹀彂鍣ㄧ殑鍚嶅瓧',
    trigger_group  varchar(200) not null comment '瑙﹀彂鍣ㄦ墍灞炵粍鐨勫悕瀛?,
    job_name       varchar(200) not null comment 'qrtz_job_details琛╦ob_name鐨勫閿?,
    job_group      varchar(200) not null comment 'qrtz_job_details琛╦ob_group鐨勫閿?,
    description    varchar(250) null comment '鐩稿叧浠嬬粛',
    next_fire_time bigint(13) null comment '涓婁竴娆¤Е鍙戞椂闂达紙姣锛?,
    prev_fire_time bigint(13) null comment '涓嬩竴娆¤Е鍙戞椂闂达紙榛樿涓?1琛ㄧず涓嶈Е鍙戯級',
    priority       integer null comment '浼樺厛绾?,
    trigger_state  varchar(16)  not null comment '瑙﹀彂鍣ㄧ姸鎬?,
    trigger_type   varchar(8)   not null comment '瑙﹀彂鍣ㄧ殑绫诲瀷',
    start_time     bigint(13) not null comment '寮€濮嬫椂闂?,
    end_time       bigint(13) null comment '缁撴潫鏃堕棿',
    calendar_name  varchar(200) null comment '鏃ョ▼琛ㄥ悕绉?,
    misfire_instr  smallint(2) null comment '琛ュ伩鎵ц鐨勭瓥鐣?,
    job_data       blob null comment '瀛樻斁鎸佷箙鍖杍ob瀵硅薄',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS (sched_name, job_name, job_group)
) engine=innodb comment = '瑙﹀彂鍣ㄨ缁嗕俊鎭〃';

-- ----------------------------
-- 3銆?瀛樺偍绠€鍗曠殑 Trigger锛屽寘鎷噸澶嶆鏁帮紝闂撮殧锛屼互鍙婂凡瑙﹀彂鐨勬鏁?-- ----------------------------
create table QRTZ_SIMPLE_TRIGGERS
(
    sched_name      varchar(120) not null comment '璋冨害鍚嶇О',
    trigger_name    varchar(200) not null comment 'qrtz_triggers琛╰rigger_name鐨勫閿?,
    trigger_group   varchar(200) not null comment 'qrtz_triggers琛╰rigger_group鐨勫閿?,
    repeat_count    bigint(7) not null comment '閲嶅鐨勬鏁扮粺璁?,
    repeat_interval bigint(12) not null comment '閲嶅鐨勯棿闅旀椂闂?,
    times_triggered bigint(10) not null comment '宸茬粡瑙﹀彂鐨勬鏁?,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) engine=innodb comment = '绠€鍗曡Е鍙戝櫒鐨勪俊鎭〃';

-- ----------------------------
-- 4銆?瀛樺偍 Cron Trigger锛屽寘鎷?Cron 琛ㄨ揪寮忓拰鏃跺尯淇℃伅
-- ---------------------------- 
create table QRTZ_CRON_TRIGGERS
(
    sched_name      varchar(120) not null comment '璋冨害鍚嶇О',
    trigger_name    varchar(200) not null comment 'qrtz_triggers琛╰rigger_name鐨勫閿?,
    trigger_group   varchar(200) not null comment 'qrtz_triggers琛╰rigger_group鐨勫閿?,
    cron_expression varchar(200) not null comment 'cron琛ㄨ揪寮?,
    time_zone_id    varchar(80) comment '鏃跺尯',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Cron绫诲瀷鐨勮Е鍙戝櫒琛?;

-- ----------------------------
-- 5銆?Trigger 浣滀负 Blob 绫诲瀷瀛樺偍(鐢ㄤ簬 Quartz 鐢ㄦ埛鐢?JDBC 鍒涘缓浠栦滑鑷繁瀹氬埗鐨?Trigger 绫诲瀷锛孞obStore 骞朵笉鐭ラ亾濡備綍瀛樺偍瀹炰緥鐨勬椂鍊?
-- ---------------------------- 
create table QRTZ_BLOB_TRIGGERS
(
    sched_name    varchar(120) not null comment '璋冨害鍚嶇О',
    trigger_name  varchar(200) not null comment 'qrtz_triggers琛╰rigger_name鐨勫閿?,
    trigger_group varchar(200) not null comment 'qrtz_triggers琛╰rigger_group鐨勫閿?,
    blob_data     blob null comment '瀛樻斁鎸佷箙鍖朤rigger瀵硅薄',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Blob绫诲瀷鐨勮Е鍙戝櫒琛?;

-- ----------------------------
-- 6銆?浠?Blob 绫诲瀷瀛樺偍瀛樻斁鏃ュ巻淇℃伅锛?quartz鍙厤缃竴涓棩鍘嗘潵鎸囧畾涓€涓椂闂磋寖鍥?-- ---------------------------- 
create table QRTZ_CALENDARS
(
    sched_name    varchar(120) not null comment '璋冨害鍚嶇О',
    calendar_name varchar(200) not null comment '鏃ュ巻鍚嶇О',
    calendar      blob         not null comment '瀛樻斁鎸佷箙鍖朿alendar瀵硅薄',
    primary key (sched_name, calendar_name)
) engine=innodb comment = '鏃ュ巻淇℃伅琛?;

-- ----------------------------
-- 7銆?瀛樺偍宸叉殏鍋滅殑 Trigger 缁勭殑淇℃伅
-- ---------------------------- 
create table QRTZ_PAUSED_TRIGGER_GRPS
(
    sched_name    varchar(120) not null comment '璋冨害鍚嶇О',
    trigger_group varchar(200) not null comment 'qrtz_triggers琛╰rigger_group鐨勫閿?,
    primary key (sched_name, trigger_group)
) engine=innodb comment = '鏆傚仠鐨勮Е鍙戝櫒琛?;

-- ----------------------------
-- 8銆?瀛樺偍涓庡凡瑙﹀彂鐨?Trigger 鐩稿叧鐨勭姸鎬佷俊鎭紝浠ュ強鐩歌仈 Job 鐨勬墽琛屼俊鎭?-- ---------------------------- 
create table QRTZ_FIRED_TRIGGERS
(
    sched_name        varchar(120) not null comment '璋冨害鍚嶇О',
    entry_id          varchar(95)  not null comment '璋冨害鍣ㄥ疄渚媔d',
    trigger_name      varchar(200) not null comment 'qrtz_triggers琛╰rigger_name鐨勫閿?,
    trigger_group     varchar(200) not null comment 'qrtz_triggers琛╰rigger_group鐨勫閿?,
    instance_name     varchar(200) not null comment '璋冨害鍣ㄥ疄渚嬪悕',
    fired_time        bigint(13) not null comment '瑙﹀彂鐨勬椂闂?,
    sched_time        bigint(13) not null comment '瀹氭椂鍣ㄥ埗瀹氱殑鏃堕棿',
    priority          integer      not null comment '浼樺厛绾?,
    state             varchar(16)  not null comment '鐘舵€?,
    job_name          varchar(200) null comment '浠诲姟鍚嶇О',
    job_group         varchar(200) null comment '浠诲姟缁勫悕',
    is_nonconcurrent  varchar(1) null comment '鏄惁骞跺彂',
    requests_recovery varchar(1) null comment '鏄惁鎺ュ彈鎭㈠鎵ц',
    primary key (sched_name, entry_id)
) engine=innodb comment = '宸茶Е鍙戠殑瑙﹀彂鍣ㄨ〃';

-- ----------------------------
-- 9銆?瀛樺偍灏戦噺鐨勬湁鍏?Scheduler 鐨勭姸鎬佷俊鎭紝鍋囧鏄敤浜庨泦缇や腑锛屽彲浠ョ湅鍒板叾浠栫殑 Scheduler 瀹炰緥
-- ---------------------------- 
create table QRTZ_SCHEDULER_STATE
(
    sched_name        varchar(120) not null comment '璋冨害鍚嶇О',
    instance_name     varchar(200) not null comment '瀹炰緥鍚嶇О',
    last_checkin_time bigint(13) not null comment '涓婃妫€鏌ユ椂闂?,
    checkin_interval  bigint(13) not null comment '妫€鏌ラ棿闅旀椂闂?,
    primary key (sched_name, instance_name)
) engine=innodb comment = '璋冨害鍣ㄧ姸鎬佽〃';

-- ----------------------------
-- 10銆?瀛樺偍绋嬪簭鐨勬偛瑙傞攣鐨勪俊鎭?鍋囧浣跨敤浜嗘偛瑙傞攣)
-- ---------------------------- 
create table QRTZ_LOCKS
(
    sched_name varchar(120) not null comment '璋冨害鍚嶇О',
    lock_name  varchar(40)  not null comment '鎮茶閿佸悕绉?,
    primary key (sched_name, lock_name)
) engine=innodb comment = '瀛樺偍鐨勬偛瑙傞攣淇℃伅琛?;

-- ----------------------------
-- 11銆?Quartz闆嗙兢瀹炵幇鍚屾鏈哄埗鐨勮閿佽〃
-- ---------------------------- 
create table QRTZ_SIMPROP_TRIGGERS
(
    sched_name    varchar(120) not null comment '璋冨害鍚嶇О',
    trigger_name  varchar(200) not null comment 'qrtz_triggers琛╰rigger_name鐨勫閿?,
    trigger_group varchar(200) not null comment 'qrtz_triggers琛╰rigger_group鐨勫閿?,
    str_prop_1    varchar(512) null comment 'String绫诲瀷鐨則rigger鐨勭涓€涓弬鏁?,
    str_prop_2    varchar(512) null comment 'String绫诲瀷鐨則rigger鐨勭浜屼釜鍙傛暟',
    str_prop_3    varchar(512) null comment 'String绫诲瀷鐨則rigger鐨勭涓変釜鍙傛暟',
    int_prop_1    int null comment 'int绫诲瀷鐨則rigger鐨勭涓€涓弬鏁?,
    int_prop_2    int null comment 'int绫诲瀷鐨則rigger鐨勭浜屼釜鍙傛暟',
    long_prop_1   bigint null comment 'long绫诲瀷鐨則rigger鐨勭涓€涓弬鏁?,
    long_prop_2   bigint null comment 'long绫诲瀷鐨則rigger鐨勭浜屼釜鍙傛暟',
    dec_prop_1    numeric(13, 4) null comment 'decimal绫诲瀷鐨則rigger鐨勭涓€涓弬鏁?,
    dec_prop_2    numeric(13, 4) null comment 'decimal绫诲瀷鐨則rigger鐨勭浜屼釜鍙傛暟',
    bool_prop_1   varchar(1) null comment 'Boolean绫诲瀷鐨則rigger鐨勭涓€涓弬鏁?,
    bool_prop_2   varchar(1) null comment 'Boolean绫诲瀷鐨則rigger鐨勭浜屼釜鍙傛暟',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) engine=innodb comment = '鍚屾鏈哄埗鐨勮閿佽〃';

commit;