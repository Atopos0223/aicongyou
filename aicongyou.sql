/*
 Navicat Premium Dump SQL (merged)

 Source Server         : WebFinal
 Source Server Type    : MySQL
 Source Server Version : 8.0.39
 Source Host           : localhost:3306
 Source Schema         : aicongyou

 Target Server Type    : MySQL
 Target Server Version : 8.0.39
 File Encoding         : 65001

 Date: 19/11/2025 21:30:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for test
-- ----------------------------
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test`  (
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of test
-- ----------------------------
INSERT INTO `test` VALUES ('testwords');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程标题',
  `term` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学期，如：2024年秋季',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程描述',
  `cover_color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#1989fa' COMMENT '封面颜色（渐变起始色）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_term`(`term`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '物联网设计基础', '2024年秋季', '通过动手实践学习物联网核心技术', '#1989fa', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (2, 'AI应用开发', '2024年秋季', '深入了解AI模型在实际项目中的应用', '#7232dd', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (3, 'Web前端开发', '2024年春季', '学习现代Web前端开发技术', '#07c160', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (4, '大数据分析基础', '2025年春季', '学习大数据处理与分析的基础方法与工具', '#ff976a', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (5, '智能硬件创新实践', '2025年秋季', '围绕智能硬件完成从创意到原型的项目实践', '#ee0a24', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (6, 'Python程序设计', '2023年春季', '掌握Python语言基础与常用库的应用', '#ffd01e', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (7, '计算机网络原理', '2023年秋季', '系统学习计算机网络体系结构与核心协议', '#00c6ff', '2025-11-17 21:04:40', '2025-11-17 21:04:40');

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL COMMENT '所属课程ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务描述',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '个人任务' COMMENT '任务类型',
  `deadline` date NULL DEFAULT NULL COMMENT '截止日期',
  `heat_index` int NOT NULL DEFAULT 70 COMMENT '热度指数（0-100）',
  `submit_total` int NOT NULL DEFAULT 24 COMMENT '需要提交的总人数',
  `submitted_students` int NOT NULL DEFAULT 0 COMMENT '已提交人数',
  `task_score` decimal(6, 2) NULL DEFAULT 100.00 COMMENT '任务得分（默认100分）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of task
-- ----------------------------
-- 课程1（物联网设计基础）的任务 - 共12个任务
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (1, 1, '数据处理与分析', '对采集的数据进行处理和分析', '个人任务', '2024-12-22', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (2, 1, '系统设计与实现', '完成系统的整体设计和核心功能实现', '个人任务', '2024-12-25', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (3, 1, '项目文档编写', '编写完整的项目开发文档和使用说明', '个人任务', '2024-12-20', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (4, 1, '传感器数据采集', '学习并实现传感器数据的采集', '个人任务', '2024-12-18', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (5, 1, '通信协议实现', '实现物联网设备间的通信协议', '个人任务', '2024-12-23', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (6, 1, '数据存储设计', '设计并实现数据存储方案', '个人任务', '2024-12-24', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (7, 1, '设备管理模块', '开发设备管理功能模块', '个人任务', '2024-12-26', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (8, 1, '用户界面设计', '设计友好的用户交互界面', '个人任务', '2024-12-27', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (9, 1, '系统测试', '进行系统功能测试', '个人任务', '2024-12-28', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (10, 1, '性能优化', '优化系统性能', '个人任务', '2024-12-29', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (11, 1, '安全防护', '实现系统安全防护机制', '个人任务', '2024-12-30', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (12, 1, '项目总结', '完成项目总结报告', '个人任务', '2024-12-31', '2025-11-17 21:04:40', '2025-11-17 21:04:40');

-- 课程2（AI应用开发）的任务 - 共15个任务
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (13, 2, 'AI模型训练', '训练和优化AI模型', '个人任务', '2024-12-28', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (14, 2, '模型部署', '将训练好的模型部署到生产环境', '个人任务', '2024-12-30', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (15, 2, '数据预处理', '对训练数据进行预处理', '个人任务', '2024-12-15', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (16, 2, '特征工程', '进行特征提取和特征工程', '个人任务', '2024-12-18', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (17, 2, '模型选择', '选择合适的AI模型架构', '个人任务', '2024-12-20', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (18, 2, '超参数调优', '调整模型超参数', '个人任务', '2024-12-22', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (19, 2, '模型评估', '评估模型性能指标', '个人任务', '2024-12-24', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (20, 2, 'API接口开发', '开发模型调用API接口', '个人任务', '2024-12-26', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (21, 2, '前端集成', '将AI功能集成到前端应用', '个人任务', '2024-12-27', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (22, 2, '性能监控', '实现模型性能监控', '个人任务', '2024-12-29', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (23, 2, '模型版本管理', '实现模型版本管理功能', '个人任务', '2024-12-31', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (24, 2, '用户反馈收集', '收集用户使用反馈', '个人任务', '2025-01-02', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (25, 2, '模型迭代优化', '基于反馈优化模型', '个人任务', '2025-01-05', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (26, 2, '文档编写', '编写AI应用开发文档', '个人任务', '2025-01-08', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (27, 2, '项目演示', '准备项目演示', '个人任务', '2025-01-10', '2025-11-17 21:04:40', '2025-11-17 21:04:40');

-- 课程3（Web前端开发）的任务 - 共10个任务
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (28, 3, 'HTML基础', '学习HTML基础语法', '个人任务', '2024-11-15', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (29, 3, 'CSS样式设计', '学习CSS样式设计', '个人任务', '2024-11-20', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (30, 3, 'JavaScript基础', '学习JavaScript编程基础', '个人任务', '2024-11-25', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (31, 3, '响应式布局', '实现响应式网页布局', '个人任务', '2024-11-30', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (32, 3, '前端框架学习', '学习Vue或React框架', '个人任务', '2024-12-05', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (33, 3, '组件开发', '开发可复用组件', '个人任务', '2024-12-10', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (34, 3, '状态管理', '学习前端状态管理', '个人任务', '2024-12-15', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (35, 3, '路由配置', '团队任务', '团队路由与权限调度设计', '2024-12-20', '2025-11-17 21:04:40', '2025-11-17 21:05:44');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (36, 3, 'API对接', '团队任务', '对接后端API接口', '2024-12-25', '2025-11-17 21:04:40', '2025-11-17 21:05:44');
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `create_time`, `update_time`) VALUES (37, 3, '项目实战', '团队任务', '完成前端项目实战', '2024-12-30', '2025-11-17 21:04:40', '2025-11-17 21:05:44');

-- 任务扩展指标：为每个任务给出热度指数和提交总人数
UPDATE task
SET
    heat_index = CASE id
        WHEN 1 THEN 96
        WHEN 2 THEN 93
        WHEN 3 THEN 89
        WHEN 4 THEN 85
        WHEN 5 THEN 82
        WHEN 6 THEN 80
        WHEN 7 THEN 78
        WHEN 8 THEN 77
        WHEN 9 THEN 75
        WHEN 10 THEN 72
        WHEN 11 THEN 70
        WHEN 12 THEN 68
        WHEN 13 THEN 98
        WHEN 14 THEN 97
        WHEN 15 THEN 95
        WHEN 16 THEN 94
        WHEN 17 THEN 92
        WHEN 18 THEN 91
        WHEN 19 THEN 90
        WHEN 20 THEN 89
        WHEN 21 THEN 88
        WHEN 22 THEN 86
        WHEN 23 THEN 85
        WHEN 24 THEN 84
        WHEN 25 THEN 83
        WHEN 26 THEN 82
        WHEN 27 THEN 81
        WHEN 28 THEN 87
        WHEN 29 THEN 86
        WHEN 30 THEN 85
        WHEN 31 THEN 83
        WHEN 32 THEN 82
        WHEN 33 THEN 80
        WHEN 34 THEN 79
        WHEN 35 THEN 78
        WHEN 36 THEN 76
        WHEN 37 THEN 75
        ELSE heat_index
    END,
    submit_total = CASE id
        WHEN 1 THEN 32
        WHEN 2 THEN 32
        WHEN 3 THEN 28
        WHEN 4 THEN 30
        WHEN 5 THEN 31
        WHEN 6 THEN 29
        WHEN 7 THEN 27
        WHEN 8 THEN 28
        WHEN 9 THEN 30
        WHEN 10 THEN 26
        WHEN 11 THEN 25
        WHEN 12 THEN 24
        WHEN 13 THEN 34
        WHEN 14 THEN 34
        WHEN 15 THEN 33
        WHEN 16 THEN 33
        WHEN 17 THEN 32
        WHEN 18 THEN 31
        WHEN 19 THEN 31
        WHEN 20 THEN 30
        WHEN 21 THEN 30
        WHEN 22 THEN 29
        WHEN 23 THEN 29
        WHEN 24 THEN 28
        WHEN 25 THEN 28
        WHEN 26 THEN 27
        WHEN 27 THEN 27
        WHEN 28 THEN 26
        WHEN 29 THEN 26
        WHEN 30 THEN 25
        WHEN 31 THEN 25
        WHEN 32 THEN 24
        WHEN 33 THEN 24
        WHEN 34 THEN 23
        WHEN 35 THEN 23
        WHEN 36 THEN 22
        WHEN 37 THEN 22
        ELSE submit_total
    END,
    submitted_students = CASE id
        WHEN 1 THEN 26
        WHEN 2 THEN 25
        WHEN 3 THEN 18
        WHEN 4 THEN 21
        WHEN 5 THEN 20
        WHEN 6 THEN 17
        WHEN 7 THEN 15
        WHEN 8 THEN 14
        WHEN 9 THEN 19
        WHEN 10 THEN 12
        WHEN 11 THEN 11
        WHEN 12 THEN 10
        WHEN 13 THEN 30
        WHEN 14 THEN 29
        WHEN 15 THEN 28
        WHEN 16 THEN 26
        WHEN 17 THEN 24
        WHEN 18 THEN 23
        WHEN 19 THEN 22
        WHEN 20 THEN 21
        WHEN 21 THEN 20
        WHEN 22 THEN 18
        WHEN 23 THEN 17
        WHEN 24 THEN 16
        WHEN 25 THEN 15
        WHEN 26 THEN 14
        WHEN 27 THEN 13
        WHEN 28 THEN 12
        WHEN 29 THEN 12
        WHEN 30 THEN 11
        WHEN 31 THEN 11
        WHEN 32 THEN 10
        WHEN 33 THEN 9
        WHEN 34 THEN 9
        WHEN 35 THEN 8
        WHEN 36 THEN 8
        WHEN 37 THEN 7
        ELSE submitted_students
    END;

-- ----------------------------
-- Table structure for team_task_board
-- ----------------------------
DROP TABLE IF EXISTS `team_task_board`;
CREATE TABLE `team_task_board`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` int NOT NULL COMMENT '关联的任务ID',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '团队名称',
  `team_score` decimal(6, 2) NOT NULL DEFAULT 0.00 COMMENT '团队得分',
  `team_rank` int NOT NULL COMMENT '团队排名（越小越靠前）',
  `individual_contribution` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '当前用户贡献度百分比',
  `submitted_members` int NULL DEFAULT 0 COMMENT '已提交成员数',
  `total_members` int NULL DEFAULT 0 COMMENT '团队总成员数',
  `popularity_index` int NULL DEFAULT 0 COMMENT '热度指数',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_task_id`(`task_id`) USING BTREE,
  CONSTRAINT `fk_team_task_board_task` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_task_board
-- ----------------------------
INSERT INTO `team_task_board` VALUES (1, 1, '核心研发组', 96.50, 1, 88.00, 5, 6, 82, NOW());
INSERT INTO `team_task_board` VALUES (2, 2, '系统工程组', 92.30, 2, 84.50, 5, 6, 77, NOW());
INSERT INTO `team_task_board` VALUES (3, 3, '交互体验组', 90.10, 3, 81.20, 4, 6, 73, NOW());
INSERT INTO `team_task_board` VALUES (4, 4, '数据智能组', 88.40, 4, 79.50, 4, 6, 69, NOW());
INSERT INTO `team_task_board` VALUES (5, 5, '通信协议组', 87.60, 5, 78.10, 3, 6, 71, NOW());
INSERT INTO `team_task_board` VALUES (6, 6, '基础平台组', 85.20, 6, 75.80, 3, 6, 65, NOW());

-- ----------------------------
-- Table structure for task_submisson
-- ----------------------------
DROP TABLE IF EXISTS `task_submisson`;
CREATE TABLE `task_submisson`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '关联的任务ID',
  `task_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务类型：个人任务/团队任务',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '团队名称（个人任务可为空）',
  `submitter_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提交人名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交说明',
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件存储路径',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '原始文件名',
  `file_size` bigint NULL DEFAULT 0 COMMENT '文件大小（字节）',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_submisson_task`(`task_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of task_submisson
-- ----------------------------
INSERT INTO `task_submisson` VALUES (1, 35, '团队任务', '团队01', '团队成员', '111', '/uploads/team-submissions/80b89bf9-13fc-44d8-9981-722908ea60b9.docx', 'QU2BZZMe8Com3068d97c66689a077c5f823b5718449f.docx', 94665, '2025-11-19 19:53:57');
INSERT INTO `task_submisson` VALUES (2, 35, '团队任务', '团队01', '团队成员', '222', '/uploads/team-submissions/0e902f2d-72be-4f6f-8d82-4b4a1db44d9a.docx', 'H0xgDcioqVSGe4a22a6b047614d96ba85deba2c1ee09.docx', 26014, '2025-11-19 20:12:00');
INSERT INTO `task_submisson` VALUES (3, 37, '团队任务', '团队03', '团队成员', '333', '/uploads/team-submissions/7b81a449-1f9e-4b11-ab47-70e250e8a54d.docx', 'yapZTf0vFHE84d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-19 20:12:16');
INSERT INTO `task_submisson` VALUES (4, 36, '团队任务', '团队02', '团队成员', '123', '/uploads/team-submissions/5af34318-4710-49b1-91bb-655a521e31cf.docx', '8qg9ZAhFlJO9a3f46d66dfb50c99134cf31e1fd2bef6.docx', 80749, '2025-11-19 20:15:52');
INSERT INTO `task_submisson` VALUES (5, 28, '个人任务', '', '团队成员', '111', '/uploads/team-submissions/b67deb90-8d97-4580-9c5c-a7601b209a2a.docx', 'oElxr7Mbo85e4d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-19 20:40:50');
INSERT INTO `task_submisson` VALUES (6, 9, '个人任务', '', '团队成员', '34', '/uploads/team-submissions/2b487784-d882-46bb-ac3f-ff87057766c0.docx', 'Gyz4TTmEwrHdb41b47fb8f8497dbfad8ecb73fc2dcb9.docx', 24910, '2025-11-21 16:30:21');
INSERT INTO `task_submisson` VALUES (7, 29, '个人任务', '', '团队成员', '345', '/uploads/team-submissions/5da4538e-8a79-43a7-87f6-820497d764b7.docx', 'mAmRysxYr1uua3f46d66dfb50c99134cf31e1fd2bef6.docx', 80749, '2025-11-21 16:35:30');
INSERT INTO `task_submisson` VALUES (8, 30, '个人任务', '', '团队成员', '2323', '/uploads/team-submissions/4fed32a8-dc70-4c56-9ff9-3f1be5343318.docx', 'CgD9e4T8MvWD4d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-21 16:43:03');
INSERT INTO `task_submisson` VALUES (9, 32, '个人任务', '', '团队成员', '34343', '/uploads/team-submissions/86341065-5117-40fd-95fa-96e9c4902104.docx', 'caXHupIewZJ84d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-21 16:43:33');
INSERT INTO `task_submisson` VALUES (10, 36, '团队任务', '团队02', '团队成员', '34343', '/uploads/team-submissions/e38a2cca-94f0-4813-ab42-a18ddeda9109.doc', 'nn4FqWCDKHdza41cba0826fc3e11b885a8c10dc3ae6b.doc', 342067, '2025-11-21 16:49:48');

-- ----------------------------
-- Table structure for excellent_work
-- ----------------------------
DROP TABLE IF EXISTS `excellent_work`;
CREATE TABLE `excellent_work` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '关联任务ID',
  `course_id` int NOT NULL COMMENT '关联课程ID',
  `work_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作品标题',
  `student_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交学生',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '团队名称',
  `score` decimal(5,2) NULL DEFAULT NULL COMMENT '教师评分',
  `summary` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作品摘要',
  `teacher_comment` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '教师评语',
  `preview_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预览封面图',
  `attachment_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件链接',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_excellent_work_task`(`task_id`) USING BTREE,
  INDEX `idx_excellent_work_course`(`course_id`) USING BTREE,
  CONSTRAINT `fk_excellent_task` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_excellent_course` FOREIGN KEY (`course_id`) REFERENCES `course`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of excellent_work
-- ----------------------------
INSERT INTO `excellent_work` (`id`, `task_id`, `course_id`, `work_title`, `student_name`, `team_name`, `score`, `summary`, `teacher_comment`, `preview_image`, `attachment_url`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '智能温室监控系统', '李浩', '核心研发组', 96.50, '利用多传感器融合实现温室环境的实时调控，并完成AI预测模型。', '逻辑清晰、数据扎实，代码结构优良，值得全班同学学习。', NULL, '/uploads/team-submissions/0e902f2d-72be-4f6f-8d82-4b4a1db44d9a.docx', '2025-11-21 17:34:27', '2025-11-21 17:37:45'),
(2, 2, 1, '物联网通信协议优化方案', '赵敏', '系统工程组', 94.30, '通过分析协议瓶颈，提出轻量化通信方案并验证延迟降低20%。', '问题分析深入，实验设计扎实，对性能优化有明显效果。', NULL, '/uploads/team-submissions/protocol.zip', '2025-11-21 17:34:27', '2025-11-21 17:34:27'),
(3, 13, 2, 'AI模型可解释性可视化', '王凯', NULL, 95.80, '为分类模型构建可解释性面板，直观展示特征贡献。', '创新性强，界面体验好，代码规范。', NULL, '/uploads/team-submissions/explainable-ai.pdf', '2025-11-21 17:34:27', '2025-11-21 17:34:27');

-- ----------------------------
-- Table structure for user_course_progress
-- ----------------------------
DROP TABLE IF EXISTS `user_course_progress`;
CREATE TABLE `user_course_progress`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID（暂时用固定值，后续可扩展）',
  `course_id` int NOT NULL COMMENT '课程ID',
  `completed_tasks` int NULL DEFAULT 0 COMMENT '已完成任务数',
  `total_tasks` int NULL DEFAULT 0 COMMENT '总任务数',
  `progress` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '学习进度百分比',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_course`(`user_id`, `course_id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_course_progress
-- ----------------------------
INSERT INTO `user_course_progress` VALUES (1, 1, 1, 8, 12, 66.67, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (2, 1, 2, 6, 15, 40.00, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (3, 1, 3, 0, 10, 0.00, '2025-11-17 21:04:41', '2025-11-17 21:04:41');

SET FOREIGN_KEY_CHECKS = 1;

