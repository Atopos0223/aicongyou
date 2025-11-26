/*
 Navicat Premium Dump SQL

 Source Server         : WebFinal
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : aicongyou

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 26/11/2025 14:33:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
  INDEX `idx_term`(`term` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '物联网设计基础', '2024年秋季', '通过动手实践学习物联网核心技术，包括传感器应用、数据采集、通信协议等', '#1989fa', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (2, 'AI应用开发', '2024年秋季', '深入了解AI模型在实际项目中的应用，包括模型训练、部署和优化', '#7232dd', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (3, 'Web前端开发', '2024年春季', '学习现代Web前端开发技术，包括HTML、CSS、JavaScript和主流框架', '#07c160', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (4, '大数据分析基础', '2025年春季', '学习大数据处理与分析的基础方法与工具，包括数据清洗、分析和可视化', '#ff976a', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (5, '智能硬件创新实践', '2025年秋季', '围绕智能硬件完成从创意到原型的项目实践，培养创新思维', '#ee0a24', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (6, 'Python程序设计', '2023年春季', '掌握Python语言基础与常用库的应用，包括数据处理、Web开发等', '#ffd01e', '2025-11-17 21:04:40', '2025-11-17 21:04:40');
INSERT INTO `course` VALUES (7, '计算机网络原理', '2023年秋季', '系统学习计算机网络体系结构与核心协议，理解网络通信机制', '#00c6ff', '2025-11-17 21:04:40', '2025-11-17 21:04:40');

-- ----------------------------
-- Table structure for excellent_work
-- ----------------------------
DROP TABLE IF EXISTS `excellent_work`;
CREATE TABLE `excellent_work`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '关联任务ID',
  `course_id` int NOT NULL COMMENT '关联课程ID',
  `work_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作品标题',
  `student_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交学生',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '团队名称',
  `score` decimal(5, 2) NULL DEFAULT NULL COMMENT '教师评分',
  `summary` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作品摘要',
  `teacher_comment` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '教师评语',
  `preview_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预览封面图',
  `attachment_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件链接',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_excellent_work_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_excellent_work_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `fk_excellent_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_excellent_task` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of excellent_work
-- ----------------------------
INSERT INTO `excellent_work` VALUES (1, 2, 1, '智能数据处理系统', '李浩', '核心研发组', 96.50, '利用多传感器融合实现数据的智能处理和分析，并完成可视化展示。', '逻辑清晰、数据扎实，代码结构优良，值得全班同学学习。', NULL, '/uploads/team-submissions/data-process.docx', '2025-11-21 18:26:42', '2025-11-21 21:27:18');
INSERT INTO `excellent_work` VALUES (2, 5, 2, 'AI模型可解释性可视化', '王凯', NULL, 95.80, '为分类模型构建可解释性面板，直观展示特征贡献。', '创新性强，界面体验好，代码规范。', NULL, '/uploads/team-submissions/explainable-ai.pdf', '2025-11-21 18:26:42', '2025-11-21 18:26:42');
INSERT INTO `excellent_work` VALUES (3, 7, 3, '响应式电商网站设计', '张伟', NULL, 92.80, '使用现代前端技术栈构建了完整的响应式电商网站，支持多设备适配。', 'UI设计美观，交互流畅，代码结构清晰。', NULL, '/uploads/team-submissions/ecommerce-site.zip', '2025-11-22 14:30:45', '2025-11-22 14:30:45');
INSERT INTO `excellent_work` VALUES (4, 11, 4, '大数据分析可视化平台', '陈明', '数据智能组', 93.20, '构建了完整的大数据分析可视化平台，支持多种数据源和图表类型。', '架构设计合理，可视化效果出色，交互体验好。', NULL, '/uploads/team-submissions/data-viz.zip', '2025-11-22 10:15:30', '2025-11-22 10:15:30');
INSERT INTO `excellent_work` VALUES (5, 14, 5, '智能硬件原型', '刘芳', NULL, 94.50, '完成了智能硬件的完整原型设计，包括硬件电路和软件控制。', '设计合理，实现完整，文档详细。', NULL, '/uploads/team-submissions/hardware-prototype.zip', '2025-11-22 11:20:15', '2025-11-22 11:20:15');

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
  INDEX `idx_course_id`(`course_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES (1, 1, '传感器数据采集', '学习并实现传感器数据的采集', '个人任务', '2024-12-18', 85, 30, 22, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (2, 1, '数据处理与分析', '对采集的数据进行处理和分析', '个人任务', '2024-12-22', 88, 30, 24, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (3, 1, '系统设计与实现', '完成系统的整体设计和核心功能实现', '团队任务', '2024-12-25', 90, 30, 20, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (4, 2, '数据预处理', '对训练数据进行预处理', '个人任务', '2024-12-15', 92, 28, 25, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (5, 2, 'AI模型训练', '训练和优化AI模型', '个人任务', '2024-12-28', 95, 28, 23, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (6, 2, '模型部署', '将训练好的模型部署到生产环境', '团队任务', '2024-12-30', 93, 28, 21, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (7, 3, 'HTML与CSS基础', '学习HTML和CSS基础语法', '个人任务', '2024-11-20', 85, 26, 20, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (8, 3, 'JavaScript编程', '学习JavaScript编程基础', '个人任务', '2024-11-25', 83, 26, 18, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (9, 3, '前端项目实战', '完成前端项目实战', '团队任务', '2024-12-30', 80, 26, 15, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (10, 4, '数据清洗', '学习并实现数据清洗技术', '个人任务', '2025-03-15', 88, 25, 20, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (11, 4, '数据分析', '进行数据分析和挖掘', '个人任务', '2025-03-25', 86, 25, 18, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (12, 4, '数据可视化', '实现数据可视化展示', '团队任务', '2025-04-05', 84, 25, 16, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (13, 5, '硬件原型设计', '完成智能硬件原型设计', '个人任务', '2025-10-15', 90, 24, 19, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (14, 5, '硬件开发', '实现硬件核心功能', '个人任务', '2025-10-30', 88, 24, 17, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (15, 5, '项目展示', '完成项目展示和演示', '团队任务', '2025-11-15', 85, 24, 15, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (16, 6, 'Python基础语法', '掌握Python基础语法和数据类型', '个人任务', '2023-04-10', 82, 22, 18, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (17, 6, 'Python库应用', '学习常用Python库的使用', '个人任务', '2023-04-25', 80, 22, 16, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (18, 6, 'Python项目实践', '完成Python综合项目', '团队任务', '2023-05-10', 78, 22, 14, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (19, 7, '网络协议分析', '分析常见网络协议的工作原理', '个人任务', '2023-10-15', 85, 20, 16, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (20, 7, '网络编程实践', '实现网络通信程序', '个人任务', '2023-10-30', 83, 20, 14, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');
INSERT INTO `task` VALUES (21, 7, '网络系统设计', '设计并实现网络系统', '团队任务', '2023-11-15', 81, 20, 12, 100.00, '2025-11-17 21:04:40', '2025-11-21 18:26:41');

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
  INDEX `idx_task_submisson_task`(`task_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of task_submisson
-- ----------------------------
INSERT INTO `task_submisson` VALUES (1, 1, '个人任务', NULL, '张三', '完成了传感器数据采集实验', '/uploads/submissions/sensor-data-001.docx', 'sensor-data-001.docx', 94665, '2025-11-19 19:53:57');
INSERT INTO `task_submisson` VALUES (2, 2, '个人任务', NULL, '李四', '数据处理与分析报告', '/uploads/submissions/data-analysis-002.docx', 'data-analysis-002.docx', 26014, '2025-11-19 20:12:00');
INSERT INTO `task_submisson` VALUES (3, 3, '团队任务', '核心研发组', '王五', '系统设计与实现', '/uploads/submissions/system-design-003.docx', 'system-design-003.docx', 155574, '2025-11-19 20:12:16');
INSERT INTO `task_submisson` VALUES (4, 4, '个人任务', NULL, '赵六', '数据预处理实验', '/uploads/submissions/preprocess-004.py', 'preprocess-004.py', 80749, '2025-11-19 20:15:52');
INSERT INTO `task_submisson` VALUES (5, 5, '个人任务', NULL, '钱七', 'AI模型训练报告', '/uploads/submissions/model-train-005.pdf', 'model-train-005.pdf', 120000, '2025-11-20 10:30:00');
INSERT INTO `task_submisson` VALUES (6, 9, '团队任务', '前端团队', '孙八', '前端项目实战', '/uploads/submissions/frontend-project-006.zip', 'frontend-project-006.zip', 342067, '2025-11-21 16:49:48');

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
  UNIQUE INDEX `uk_task_id`(`task_id` ASC) USING BTREE,
  CONSTRAINT `fk_team_task_board_task` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of team_task_board
-- ----------------------------
INSERT INTO `team_task_board` VALUES (1, 3, '核心研发组', 96.50, 1, 88.00, 5, 6, 85, '2025-11-21 18:26:41');
INSERT INTO `team_task_board` VALUES (2, 6, 'AI开发组', 94.20, 1, 86.00, 4, 5, 82, '2025-11-21 18:26:41');
INSERT INTO `team_task_board` VALUES (3, 9, '前端团队', 89.80, 1, 80.00, 3, 4, 75, '2025-11-21 18:26:41');
INSERT INTO `team_task_board` VALUES (4, 12, '数据可视化组', 87.60, 1, 78.50, 4, 5, 72, '2025-11-21 18:26:41');
INSERT INTO `team_task_board` VALUES (5, 15, '智能硬件组', 92.30, 1, 84.50, 4, 5, 80, '2025-11-21 18:26:41');
INSERT INTO `team_task_board` VALUES (6, 18, 'Python项目组', 88.40, 1, 82.30, 3, 4, 78, '2025-11-21 18:26:41');

-- ----------------------------
-- Table structure for test
-- ----------------------------
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test`  (
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of test
-- ----------------------------
INSERT INTO `test` VALUES ('testwords');

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
  UNIQUE INDEX `uk_user_course`(`user_id` ASC, `course_id` ASC) USING BTREE,
  INDEX `idx_course_id`(`course_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_course_progress
-- ----------------------------
INSERT INTO `user_course_progress` VALUES (1, 1, 1, 2, 3, 66.67, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (2, 1, 2, 2, 3, 66.67, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (3, 1, 3, 1, 3, 33.33, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (4, 2, 1, 3, 3, 100.00, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (5, 2, 2, 1, 3, 33.33, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (6, 2, 4, 2, 3, 66.67, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (7, 3, 5, 0, 3, 0.00, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (8, 3, 6, 1, 3, 33.33, '2025-11-17 21:04:41', '2025-11-17 21:04:41');
INSERT INTO `user_course_progress` VALUES (9, 3, 7, 2, 3, 66.67, '2025-11-17 21:04:41', '2025-11-17 21:04:41');

SET FOREIGN_KEY_CHECKS = 1;
