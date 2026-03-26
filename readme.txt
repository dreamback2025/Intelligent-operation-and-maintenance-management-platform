电力/光伏运维管理平台项目说明

一、项目整体概述
本项目基于若依（RuoYi）3.8.6 体系做了行业化扩展，定位为“光伏发电 + 电力运维”管理平台。整体采用前后端分离架构：
1. 后端是 Java + Spring Boot 2.5.15 的 Maven 多模块工程。
2. 前端是 Vue3 + Element Plus + Vite 的单页应用工程。
3. 数据层同时使用 MySQL（业务主数据）和 InfluxDB（时序数据），并配合 Redis 做缓存。
4. 配套包含初始化 SQL、模拟数据脚本、Docker 依赖环境、Windows/Linux 启停脚本，适合本地开发与测试演示。

从业务内容看，项目不仅保留了若依原生的系统管理能力（用户、角色、菜单、日志、监控、定时任务、代码生成等），还增加了光伏电站、电气设备、实时数据、告警、峰值与统计分析、微信小程序相关能力。

二、技术与模块关系（简版）
1. 聚合工程：根目录 pom.xml 管理依赖版本、统一编译参数和子模块。
2. 启动入口：ruoyi-admin 模块，打包后产出 ruoyi-admin.jar。
3. 核心框架：ruoyi-framework 负责安全、拦截器、AOP、配置装配等。
4. 业务域：ruoyi-system 同时承载“系统管理域”和“光伏电力业务域（pvadmin）”。
5. 通用能力：ruoyi-common 提供工具类、基础实体、通用注解、异常体系。
6. 增强模块：ruoyi-quartz（定时任务）与 ruoyi-generator（代码生成）。
7. 前端工程：ruoyi-vue 提供全部管理后台页面与接口调用。

三、根目录及主要文件夹说明

1) .git/
Git 仓库元数据目录，保存提交历史、分支、对象等版本信息。

2) .github/
仓库自动化与工程治理相关目录。
- appmod/: 与代码现代化/迁移相关的记录。
- appmod/code-migration/summary.md: 一次依赖升级与漏洞修复的总结文档。

3) .vscode/
工作区级 VS Code 配置。
- settings.json: Java 构建配置更新策略等编辑器行为。

4) bin/
根目录批处理脚本，面向 Maven 项目构建流程。
- clean.bat: 清理各模块 target。
- package.bat: 执行 Maven 打包（默认跳过测试）。
- run.bat: 进入 ruoyi-admin/target 后启动 jar。

5) doc/
项目文档目录。
- 若依环境使用手册.docx: 环境准备与使用说明文档。

6) mock-data/
模拟与初始化数据目录。
- generate_data.py / generate_large_data.py: 生成测试数据脚本。
- init_*.sql: 业务菜单、实时配置、告警与大数据量测试等初始化脚本。

7) readme/
说明图片资源目录。
- img/: 文档配图。
- logo-chinese.png: 项目标识图。

8) ruoyi-admin/
后端启动模块（Web 服务入口）。
- pom.xml: 声明为 web 入口，依赖 framework/quartz/generator。
- src/main/java/: Spring Boot 启动类、控制器与对外接口。
  - com/ruoyi/RuoYiApplication.java: 后端主启动类。
  - com/ruoyi/web/: 管理后台与业务接口控制层（含微信相关接口）。
- src/main/resources/: 运行配置与 MyBatis 基础配置。
  - application.yml: 通用配置与默认 profile。
  - application-dev.yml: 开发环境配置（MySQL、Redis、InfluxDB、微信参数等）。
  - application-prod.yml: 生产环境配置模板。
  - mybatis/: MyBatis 全局配置。
  - i18n/: 国际化资源。
  - logback.xml: 日志配置。
- target/: 编译与打包产物目录（classes、jar、日志等）。

9) ruoyi-common/
通用基础模块，供其他模块复用。
- src/main/java/com/ruoyi/common/
  - annotation/: 通用注解（日志、限流、数据权限等）。
  - config/: 通用配置（如 InfluxDB 配置、全局配置）。
  - constant/: 常量定义。
  - core/: 基础实体、分页模型、统一返回对象等。
  - enums/: 枚举定义。
  - exception/: 全局与业务异常体系。
  - filter/: XSS 与重复读取请求体等过滤器。
  - utils/: 大量工具类（日期、文件、Excel、网络、安全、反射等）。
  - xss/: XSS 校验注解与验证器。
- target/: 模块编译输出目录。

10) ruoyi-framework/
框架核心模块，偏“横切能力”。
- src/main/java/com/ruoyi/framework/
  - config/: 安全、Redis、Druid、MyBatis、线程池等配置装配。
  - security/: 鉴权过滤器、认证上下文、登录退出处理。
  - aspectj/: 日志、限流、数据权限、数据源切换等切面。
  - interceptor/: 防重复提交等拦截器。
  - manager/: 异步任务与生命周期管理。
  - web/: 登录、权限、Token、全局异常等 Web 服务层能力。
- target/: 模块编译输出目录。

11) ruoyi-generator/
代码生成模块。
- src/main/resources/
  - generator.yml: 代码生成器配置。
  - mapper/generator/: 代码生成相关 SQL 映射。
  - vm/: 模板目录（java、xml、vue、js、sql 模板）。
- src/main/java/com/ruoyi/generator/: 代码生成逻辑。
- target/: 模块编译输出目录。

12) ruoyi-quartz/
定时任务模块。
- src/main/java/com/ruoyi/quartz/: 任务调度、任务执行与管理逻辑。
- src/main/resources/mapper/quartz/: Quartz 相关映射文件。
- target/: 模块编译输出目录。

13) ruoyi-system/
核心业务模块，既包含若依系统管理域，也包含本项目的电力光伏业务域。
- src/main/java/com/ruoyi/system/
  - system/: 若依标准系统域（用户、角色、菜单、字典、日志、配置等）。
- src/main/java/com/ruoyi/pvadmin/
  - domain/entity/: 光伏业务实体（电站、设备、告警、备件等）。
  - domain/model/: 分析与查询模型。
  - mapper/: 业务 Mapper（Device、Alarm、PowerStation、ElectricityDataItem 等）。
  - service/: 业务服务接口与实现。
  - influxdb/: 时序数据访问封装。
- src/main/resources/mapper/
  - system/: 系统管理 SQL 映射。
  - pvadmin/: 光伏业务 SQL 映射。
- target/: 模块编译输出目录。

14) ruoyi-vue/
前端工程（Vue3 + Vite）。
- package.json: 前端依赖与脚本定义（dev/build/preview）。
- vite.config.js: Vite 构建与代理配置。
- bin/: 前端构建/运行脚本。
- public/: 静态公共资源。
- src/: 前端核心源码。
  - api/: 按业务域封装接口（system、alarm、analysis、manage、peaks 等）。
  - assets/: 图片、图标、样式资源。
  - components/: 通用组件（分页、上传、编辑器、地图、字典标签等）。
  - directive/: 自定义指令。
  - layout/: 页面框架布局。
  - plugins/: 插件封装（缓存、下载、弹窗、鉴权等）。
  - router/: 路由配置。
  - store/: 全局状态管理（Pinia）。
  - utils/: 请求封装、权限、加密、字典、校验等工具。
  - views/: 页面视图。
    - system/: 系统管理。
    - monitor/: 监控与日志。
    - tool/: 代码生成、接口文档等工具页。
    - realTime/: 实时数据展示。
    - alarm/: 告警列表。
    - electric/: 电力分析页面。
    - statistics/: 统计分析页面。
    - peaks/: 峰值分析与报表。
- html/: 兼容页（如 IE 提示页）。
- vite/plugins/: Vite 插件实现。
- node_modules/: 前端依赖安装目录。

15) sql/
数据库初始化脚本目录。
- ry_*.sql: 若依基础库脚本（不同编码/版本变体）。
- quartz*.sql: 定时任务模块库脚本。

16) 其他根文件
- pom.xml: Maven 聚合根与依赖管理中心。
- docker-compose.yml: 本地依赖服务（MySQL、Redis、InfluxDB）一键启动配置。
- ry.bat / ry.sh: jar 应用启停脚本（Windows/Linux）。
- start.txt: 最小启动说明（后端 jar + 前端 dev）。
- .gitignore: Git 忽略规则。

四、运行链路（理解目录关系的关键）
1. 先通过 docker-compose.yml 准备 MySQL、Redis、InfluxDB。
2. 用 sql/ 与 mock-data/ 的脚本初始化结构和测试数据。
3. 后端由 ruoyi-admin 启动，运行时依赖 ruoyi-framework、ruoyi-system、ruoyi-common、ruoyi-quartz、ruoyi-generator。
4. 前端 ruoyi-vue 通过 API 访问后端接口，页面按 system/monitor/tool 与光伏业务页面分区。

五、关于 target 与 node_modules 目录
1. 各模块 target/ 属于构建产物目录，可由构建命令重新生成。
2. ruoyi-vue/node_modules/ 属于前端依赖目录，可由 npm/yarn 安装重新生成。
3. 这两类目录通常不作为业务源码维护重点。

六、结论
从工程形态看，这是一个以若依为底座、叠加光伏电力业务能力的完整管理平台项目。目录划分整体清晰：
1. ruoyi-admin 负责启动与接口入口。
2. ruoyi-framework + ruoyi-common 提供基础框架能力。
3. ruoyi-system 承载核心业务与系统管理。
4. ruoyi-vue 承载全部前端交互与可视化。
5. sql、mock-data、bin、docker-compose.yml 共同支撑部署、联调和测试。