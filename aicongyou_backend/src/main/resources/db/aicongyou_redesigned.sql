/*
 爱从游系统 - 重新设计的数据库
 基于现有 aicongyou.sql 优化改进
 设计日期: 2025-11-21
 数据库版本: MySQL 8.0+
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 用户表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `student_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学号（学生）或工号（教师）',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '班级名称（学生）',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'student' COMMENT '角色：student-学生，teacher-教师，admin-管理员',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码（加密存储）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_id`(`student_id`) USING BTREE,
  INDEX `idx_role`(`role`) USING BTREE,
  INDEX `idx_class_name`(`class_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 2. 课程表（优化）
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程标题',
  `term` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学期，如：2024年秋季',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程描述',
  `cover_color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#1989fa' COMMENT '封面颜色（渐变起始色）',
  `teacher_id` int NULL DEFAULT NULL COMMENT '授课教师ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-已结束，1-进行中，2-未开始',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_term`(`term`) USING BTREE,
  INDEX `idx_teacher_id`(`teacher_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  CONSTRAINT `fk_course_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `user`(`id`) ON DELETE SET NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 3. 学生课程关联表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `student_course`;
CREATE TABLE `student_course` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `student_id` int NOT NULL COMMENT '学生ID',
  `course_id` int NOT NULL COMMENT '课程ID',
  `enroll_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '选课时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-已退课，1-在读',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_course`(`student_id`, `course_id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE,
  CONSTRAINT `fk_student_course_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_student_course_course` FOREIGN KEY (`course_id`) REFERENCES `course`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生课程关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 4. 任务表（优化）
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `course_id` int NOT NULL COMMENT '所属课程ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务描述',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '个人任务' COMMENT '任务类型：个人任务/团队任务',
  `deadline` datetime NULL DEFAULT NULL COMMENT '截止日期',
  `task_score` decimal(6, 2) NOT NULL DEFAULT 100.00 COMMENT '任务满分',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-已结束，1-进行中，2-未开始',
  `heat_index` int NOT NULL DEFAULT 70 COMMENT '热度指数（0-100）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_deadline`(`deadline`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  CONSTRAINT `fk_task_course` FOREIGN KEY (`course_id`) REFERENCES `course`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 5. 团队表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `team`;
CREATE TABLE `team` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '团队ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '团队名称',
  `course_id` int NOT NULL COMMENT '所属课程ID',
  `leader_id` int NULL DEFAULT NULL COMMENT '队长ID',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '团队描述',
  `max_members` int NOT NULL DEFAULT 6 COMMENT '最大成员数',
  `current_members` int NOT NULL DEFAULT 0 COMMENT '当前成员数',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-已解散，1-正常',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE,
  INDEX `idx_leader_id`(`leader_id`) USING BTREE,
  CONSTRAINT `fk_team_course` FOREIGN KEY (`course_id`) REFERENCES `course`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_team_leader` FOREIGN KEY (`leader_id`) REFERENCES `user`(`id`) ON DELETE SET NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '团队表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 6. 团队成员表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `team_member`;
CREATE TABLE `team_member` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `team_id` int NOT NULL COMMENT '团队ID',
  `student_id` int NOT NULL COMMENT '学生ID',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'member' COMMENT '角色：leader-队长，member-成员',
  `contribution_rate` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '贡献度百分比',
  `join_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-已退出，1-正常',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_team_student`(`team_id`, `student_id`) USING BTREE,
  INDEX `idx_student_id`(`student_id`) USING BTREE,
  CONSTRAINT `fk_team_member_team` FOREIGN KEY (`team_id`) REFERENCES `team`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_team_member_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '团队成员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 7. 任务提交表（修正拼写错误，优化结构）
-- ----------------------------
DROP TABLE IF EXISTS `task_submission`;
DROP TABLE IF EXISTS `task_submisson`; -- 删除旧表
CREATE TABLE `task_submission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '关联的任务ID',
  `student_id` int NOT NULL COMMENT '提交学生ID',
  `team_id` int NULL DEFAULT NULL COMMENT '团队ID（团队任务时使用）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交说明',
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件存储路径',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '原始文件名',
  `file_size` bigint NULL DEFAULT 0 COMMENT '文件大小（字节）',
  `score` decimal(6, 2) NULL DEFAULT NULL COMMENT '得分（教师评分）',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0-待评分，1-已评分，2-已退回',
  `teacher_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '教师评语',
  `submitted_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `graded_at` datetime NULL DEFAULT NULL COMMENT '评分时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_id`(`task_id`) USING BTREE,
  INDEX `idx_student_id`(`student_id`) USING BTREE,
  INDEX `idx_team_id`(`team_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  CONSTRAINT `fk_submission_task` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_submission_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_submission_team` FOREIGN KEY (`team_id`) REFERENCES `team`(`id`) ON DELETE SET NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务提交表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 8. 优秀作业表（优化）
-- ----------------------------
DROP TABLE IF EXISTS `excellent_work`;
CREATE TABLE `excellent_work` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '关联任务ID',
  `course_id` int NOT NULL COMMENT '关联课程ID',
  `submission_id` bigint NULL DEFAULT NULL COMMENT '关联提交记录ID',
  `work_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作品标题',
  `student_id` int NULL DEFAULT NULL COMMENT '提交学生ID（个人任务）',
  `team_id` int NULL DEFAULT NULL COMMENT '团队ID（团队任务）',
  `score` decimal(5,2) NOT NULL COMMENT '教师评分',
  `summary` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作品摘要',
  `teacher_comment` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '教师评语',
  `preview_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预览封面图',
  `attachment_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件链接',
  `is_featured` tinyint NOT NULL DEFAULT 0 COMMENT '是否精选：0-否，1-是',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '浏览次数',
  `like_count` int NOT NULL DEFAULT 0 COMMENT '点赞数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_excellent_work_task`(`task_id`) USING BTREE,
  INDEX `idx_excellent_work_course`(`course_id`) USING BTREE,
  INDEX `idx_submission_id`(`submission_id`) USING BTREE,
  INDEX `idx_is_featured`(`is_featured`) USING BTREE,
  CONSTRAINT `fk_excellent_task` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_excellent_course` FOREIGN KEY (`course_id`) REFERENCES `course`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_excellent_submission` FOREIGN KEY (`submission_id`) REFERENCES `task_submission`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_excellent_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_excellent_team` FOREIGN KEY (`team_id`) REFERENCES `team`(`id`) ON DELETE SET NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优秀作业表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 9. 能力维度表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `ability_dimension`;
CREATE TABLE `ability_dimension` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '维度ID',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '维度编码',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '维度名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '维度描述',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#1989fa' COMMENT '显示颜色',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序顺序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '能力维度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 10. 任务能力维度关联表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `task_ability_dimension`;
CREATE TABLE `task_ability_dimension` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '任务ID',
  `dimension_id` int NOT NULL COMMENT '能力维度ID',
  `weight` decimal(5, 2) NOT NULL DEFAULT 1.00 COMMENT '权重（0-1之间）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_task_dimension`(`task_id`, `dimension_id`) USING BTREE,
  INDEX `idx_dimension_id`(`dimension_id`) USING BTREE,
  CONSTRAINT `fk_task_dimension_task` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_task_dimension_dimension` FOREIGN KEY (`dimension_id`) REFERENCES `ability_dimension`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务能力维度关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 11. 学生能力维度达成度表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `student_ability_achievement`;
CREATE TABLE `student_ability_achievement` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `student_id` int NOT NULL COMMENT '学生ID',
  `course_id` int NOT NULL COMMENT '课程ID',
  `dimension_id` int NOT NULL COMMENT '能力维度ID',
  `achievement_rate` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '达成度百分比（0-100）',
  `total_score` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '总得分',
  `max_score` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '满分',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_course_dimension`(`student_id`, `course_id`, `dimension_id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE,
  INDEX `idx_dimension_id`(`dimension_id`) USING BTREE,
  CONSTRAINT `fk_achievement_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_achievement_course` FOREIGN KEY (`course_id`) REFERENCES `course`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_achievement_dimension` FOREIGN KEY (`dimension_id`) REFERENCES `ability_dimension`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生能力维度达成度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 12. 学生课程统计表（优化原user_course_progress）
-- ----------------------------
DROP TABLE IF EXISTS `student_course_statistics`;
DROP TABLE IF EXISTS `user_course_progress`; -- 删除旧表
CREATE TABLE `student_course_statistics` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `student_id` int NOT NULL COMMENT '学生ID',
  `course_id` int NOT NULL COMMENT '课程ID',
  `total_score` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '课程总得分（汇总所有任务得分）',
  `completed_tasks` int NOT NULL DEFAULT 0 COMMENT '已完成任务数',
  `total_tasks` int NOT NULL DEFAULT 0 COMMENT '总任务数',
  `progress_rate` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '学习进度百分比',
  `ranking` int NULL DEFAULT NULL COMMENT '课程内排名',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_course`(`student_id`, `course_id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE,
  INDEX `idx_ranking`(`course_id`, `ranking`) USING BTREE,
  CONSTRAINT `fk_statistics_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_statistics_course` FOREIGN KEY (`course_id`) REFERENCES `course`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生课程统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 13. AI讨论记录表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `ai_discussion`;
CREATE TABLE `ai_discussion` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '关联任务ID',
  `student_id` int NOT NULL COMMENT '学生ID',
  `message_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息类型：user-用户，ai-AI',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_student`(`task_id`, `student_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  CONSTRAINT `fk_discussion_task` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_discussion_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI讨论记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 14. 优秀作业互动表（新增）
-- ----------------------------
DROP TABLE IF EXISTS `excellent_work_interaction`;
CREATE TABLE `excellent_work_interaction` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `work_id` int NOT NULL COMMENT '优秀作业ID',
  `student_id` int NOT NULL COMMENT '学生ID',
  `action_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型：like-点赞，favorite-收藏',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_work_student_action`(`work_id`, `student_id`, `action_type`) USING BTREE,
  INDEX `idx_student_id`(`student_id`) USING BTREE,
  CONSTRAINT `fk_interaction_work` FOREIGN KEY (`work_id`) REFERENCES `excellent_work`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_interaction_student` FOREIGN KEY (`student_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优秀作业互动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 15. 团队任务看板表（保留，但优化）
-- ----------------------------
DROP TABLE IF EXISTS `team_task_board`;
CREATE TABLE `team_task_board` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` int NOT NULL COMMENT '关联的任务ID',
  `team_id` int NULL DEFAULT NULL COMMENT '团队ID（新增）',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '团队名称（保留兼容）',
  `team_score` decimal(6, 2) NOT NULL DEFAULT 0.00 COMMENT '团队得分',
  `team_rank` int NOT NULL COMMENT '团队排名（越小越靠前）',
  `individual_contribution` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '当前用户贡献度百分比',
  `submitted_members` int NULL DEFAULT 0 COMMENT '已提交成员数',
  `total_members` int NULL DEFAULT 0 COMMENT '团队总成员数',
  `popularity_index` int NULL DEFAULT 0 COMMENT '热度指数',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_id`(`task_id`) USING BTREE,
  INDEX `idx_team_id`(`team_id`) USING BTREE,
  CONSTRAINT `fk_team_task_board_task` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_team_task_board_team` FOREIGN KEY (`team_id`) REFERENCES `team`(`id`) ON DELETE SET NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '团队任务看板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 初始化数据
-- ----------------------------

-- 插入默认用户
INSERT INTO `user` (`id`, `student_id`, `name`, `avatar`, `class_name`, `role`, `status`) VALUES
(1, '202401001', '张三', '/images/avatar.png', '物联网工程1班', 'student', 1),
(2, '202401002', '李四', NULL, '物联网工程1班', 'student', 1),
(3, '202401003', '王五', NULL, '物联网工程1班', 'student', 1),
(4, 'T001', '张教授', NULL, NULL, 'teacher', 1),
(5, 'T002', '李教授', NULL, NULL, 'teacher', 1);

-- 插入能力维度数据
INSERT INTO `ability_dimension` (`id`, `code`, `name`, `description`, `color`, `sort_order`) VALUES
(1, 'PROBLEM_ANALYSIS', '问题分析能力', '能够识别和定义复杂工程问题', '#1989fa', 1),
(2, 'DESIGN_DEVELOPMENT', '设计开发能力', '能够设计满足特定需求的系统或组件', '#7232dd', 2),
(3, 'RESEARCH', '研究能力', '能够运用研究方法进行工程问题研究', '#07c160', 3),
(4, 'MODERN_TOOLS', '使用现代工具能力', '能够选择和使用现代工程工具', '#ff976a', 4),
(5, 'ENGINEERING_SOCIETY', '工程与社会', '能够理解工程对社会的影响', '#ffb300', 5),
(6, 'ENVIRONMENT_SUSTAINABILITY', '环境和可持续发展', '能够理解工程对环境的影响', '#667eea', 6);

-- 插入课程数据（保留原有数据）
INSERT INTO `course` (`id`, `title`, `term`, `description`, `cover_color`, `teacher_id`, `status`) VALUES
(1, '物联网设计基础', '2024年秋季', '通过动手实践学习物联网核心技术', '#1989fa', 4, 1),
(2, 'AI应用开发', '2024年秋季', '深入了解AI模型在实际项目中的应用', '#7232dd', 4, 1),
(3, 'Web前端开发', '2024年春季', '学习现代Web前端开发技术', '#07c160', 5, 1),
(4, '大数据分析基础', '2025年春季', '学习大数据处理与分析的基础方法与工具', '#ff976a', 4, 1),
(5, '智能硬件创新实践', '2025年秋季', '围绕智能硬件完成从创意到原型的项目实践', '#ee0a24', 5, 1),
(6, 'Python程序设计', '2023年春季', '掌握Python语言基础与常用库的应用', '#ffd01e', 4, 0),
(7, '计算机网络原理', '2023年秋季', '系统学习计算机网络体系结构与核心协议', '#00c6ff', 5, 0);

-- 插入学生选课数据
INSERT INTO `student_course` (`student_id`, `course_id`, `status`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(2, 1, 1),
(2, 2, 1),
(3, 1, 1);

-- 插入任务数据（保留原有数据，但优化deadline为datetime）
INSERT INTO `task` (`id`, `course_id`, `name`, `description`, `type`, `deadline`, `task_score`, `status`, `heat_index`) VALUES
-- 课程1（物联网设计基础）的任务 - 共12个任务
(1, 1, '数据处理与分析', '对采集的数据进行处理和分析', '个人任务', '2024-12-22 23:59:59', 100.00, 1, 96),
(2, 1, '系统设计与实现', '完成系统的整体设计和核心功能实现', '个人任务', '2024-12-25 23:59:59', 100.00, 1, 93),
(3, 1, '项目文档编写', '编写完整的项目开发文档和使用说明', '个人任务', '2024-12-20 23:59:59', 100.00, 1, 89),
(4, 1, '传感器数据采集', '学习并实现传感器数据的采集', '个人任务', '2024-12-18 23:59:59', 100.00, 1, 85),
(5, 1, '通信协议实现', '实现物联网设备间的通信协议', '个人任务', '2024-12-23 23:59:59', 100.00, 1, 82),
(6, 1, '数据存储设计', '设计并实现数据存储方案', '个人任务', '2024-12-24 23:59:59', 100.00, 1, 80),
(7, 1, '设备管理模块', '开发设备管理功能模块', '个人任务', '2024-12-26 23:59:59', 100.00, 1, 78),
(8, 1, '用户界面设计', '设计友好的用户交互界面', '个人任务', '2024-12-27 23:59:59', 100.00, 1, 77),
(9, 1, '系统测试', '进行系统功能测试', '个人任务', '2024-12-28 23:59:59', 100.00, 1, 75),
(10, 1, '性能优化', '优化系统性能', '个人任务', '2024-12-29 23:59:59', 100.00, 1, 72),
(11, 1, '安全防护', '实现系统安全防护机制', '个人任务', '2024-12-30 23:59:59', 100.00, 1, 70),
(12, 1, '项目总结', '完成项目总结报告', '个人任务', '2024-12-31 23:59:59', 100.00, 1, 68),
-- 课程2（AI应用开发）的任务 - 共15个任务
(13, 2, 'AI模型训练', '训练和优化AI模型', '个人任务', '2024-12-28 23:59:59', 100.00, 1, 98),
(14, 2, '模型部署', '将训练好的模型部署到生产环境', '个人任务', '2024-12-30 23:59:59', 100.00, 1, 97),
(15, 2, '数据预处理', '对训练数据进行预处理', '个人任务', '2024-12-15 23:59:59', 100.00, 1, 95),
(16, 2, '特征工程', '进行特征提取和特征工程', '个人任务', '2024-12-18 23:59:59', 100.00, 1, 94),
(17, 2, '模型选择', '选择合适的AI模型架构', '个人任务', '2024-12-20 23:59:59', 100.00, 1, 92),
(18, 2, '超参数调优', '调整模型超参数', '个人任务', '2024-12-22 23:59:59', 100.00, 1, 91),
(19, 2, '模型评估', '评估模型性能指标', '个人任务', '2024-12-24 23:59:59', 100.00, 1, 90),
(20, 2, 'API接口开发', '开发模型调用API接口', '个人任务', '2024-12-26 23:59:59', 100.00, 1, 89),
(21, 2, '前端集成', '将AI功能集成到前端应用', '个人任务', '2024-12-27 23:59:59', 100.00, 1, 88),
(22, 2, '性能监控', '实现模型性能监控', '个人任务', '2024-12-29 23:59:59', 100.00, 1, 86),
(23, 2, '模型版本管理', '实现模型版本管理功能', '个人任务', '2024-12-31 23:59:59', 100.00, 1, 85),
(24, 2, '用户反馈收集', '收集用户使用反馈', '个人任务', '2025-01-02 23:59:59', 100.00, 1, 84),
(25, 2, '模型迭代优化', '基于反馈优化模型', '个人任务', '2025-01-05 23:59:59', 100.00, 1, 83),
(26, 2, '文档编写', '编写AI应用开发文档', '个人任务', '2025-01-08 23:59:59', 100.00, 1, 82),
(27, 2, '项目演示', '准备项目演示', '个人任务', '2025-01-10 23:59:59', 100.00, 1, 81),
-- 课程3（Web前端开发）的任务 - 共10个任务
(28, 3, 'HTML基础', '学习HTML基础语法', '个人任务', '2024-11-15 23:59:59', 100.00, 0, 87),
(29, 3, 'CSS样式设计', '学习CSS样式设计', '个人任务', '2024-11-20 23:59:59', 100.00, 0, 86),
(30, 3, 'JavaScript基础', '学习JavaScript编程基础', '个人任务', '2024-11-25 23:59:59', 100.00, 0, 85),
(31, 3, '响应式布局', '实现响应式网页布局', '个人任务', '2024-11-30 23:59:59', 100.00, 0, 83),
(32, 3, '前端框架学习', '学习Vue或React框架', '个人任务', '2024-12-05 23:59:59', 100.00, 0, 82),
(33, 3, '组件开发', '开发可复用组件', '个人任务', '2024-12-10 23:59:59', 100.00, 0, 80),
(34, 3, '状态管理', '学习前端状态管理', '个人任务', '2024-12-15 23:59:59', 100.00, 0, 79),
(35, 3, '路由配置', '团队路由与权限调度设计', '团队任务', '2024-12-20 23:59:59', 100.00, 1, 78),
(36, 3, 'API对接', '对接后端API接口', '团队任务', '2024-12-25 23:59:59', 100.00, 1, 76),
(37, 3, '项目实战', '完成前端项目实战', '团队任务', '2024-12-30 23:59:59', 100.00, 1, 75);

-- 插入任务能力维度关联数据（示例）
INSERT INTO `task_ability_dimension` (`task_id`, `dimension_id`, `weight`) VALUES
(1, 1, 0.3), (1, 4, 0.7),  -- 数据处理与分析
(2, 2, 0.5), (2, 1, 0.3), (2, 4, 0.2),  -- 系统设计与实现
(3, 2, 0.4), (3, 5, 0.3), (3, 6, 0.3),  -- 项目文档编写
(4, 4, 0.6), (4, 1, 0.4),  -- 传感器数据采集
(5, 2, 0.5), (5, 4, 0.5),  -- 通信协议实现
(13, 3, 0.4), (13, 4, 0.6),  -- AI模型训练
(14, 2, 0.5), (14, 4, 0.5),  -- 模型部署
(15, 1, 0.4), (15, 4, 0.6),  -- 数据预处理
(28, 2, 0.6), (28, 4, 0.4),  -- HTML基础
(29, 2, 0.7), (29, 4, 0.3),  -- CSS样式设计
(30, 2, 0.6), (30, 4, 0.4),  -- JavaScript基础
(35, 2, 0.5), (35, 1, 0.3), (35, 4, 0.2);  -- 路由配置

-- 插入学生课程统计数据（从原user_course_progress迁移）
INSERT INTO `student_course_statistics` (`student_id`, `course_id`, `total_score`, `completed_tasks`, `total_tasks`, `progress_rate`, `ranking`) VALUES
(1, 1, 1630.00, 8, 12, 66.67, 15),
(1, 2, 850.00, 6, 15, 40.00, 20),
(1, 3, 0.00, 0, 10, 0.00, NULL);

-- 插入学生能力维度达成度数据（示例）
INSERT INTO `student_ability_achievement` (`student_id`, `course_id`, `dimension_id`, `achievement_rate`, `total_score`, `max_score`) VALUES
(1, 1, 1, 85.00, 85.00, 100.00),
(1, 1, 2, 78.00, 78.00, 100.00),
(1, 1, 3, 82.00, 82.00, 100.00),
(1, 1, 4, 90.00, 90.00, 100.00),
(1, 1, 5, 75.00, 75.00, 100.00),
(1, 1, 6, 80.00, 80.00, 100.00),
(1, 2, 1, 80.00, 80.00, 100.00),
(1, 2, 2, 75.00, 75.00, 100.00),
(1, 2, 3, 88.00, 88.00, 100.00),
(1, 2, 4, 92.00, 92.00, 100.00);

-- 插入团队数据（示例）
INSERT INTO `team` (`id`, `name`, `course_id`, `leader_id`, `max_members`, `current_members`, `status`) VALUES
(1, '核心研发组', 1, 1, 6, 5, 1),
(2, '系统工程组', 1, 2, 6, 5, 1),
(3, '交互体验组', 1, 3, 6, 4, 1),
(4, '团队01', 3, 1, 6, 3, 1),
(5, '团队02', 3, 2, 6, 3, 1),
(6, '团队03', 3, 3, 6, 2, 1);

-- 插入团队成员数据（示例）
INSERT INTO `team_member` (`team_id`, `student_id`, `role`, `contribution_rate`, `status`) VALUES
(1, 1, 'leader', 88.00, 1),
(1, 2, 'member', 75.00, 1),
(2, 2, 'leader', 84.50, 1),
(2, 1, 'member', 80.00, 1),
(4, 1, 'leader', 85.00, 1),
(5, 2, 'leader', 82.00, 1);

-- 插入团队任务看板数据（保留原有数据，但关联team_id）
INSERT INTO `team_task_board` (`id`, `task_id`, `team_id`, `team_name`, `team_score`, `team_rank`, `individual_contribution`, `submitted_members`, `total_members`, `popularity_index`) VALUES
(1, 1, 1, '核心研发组', 96.50, 1, 88.00, 5, 6, 82),
(2, 2, 2, '系统工程组', 92.30, 2, 84.50, 5, 6, 77),
(3, 3, 3, '交互体验组', 90.10, 3, 81.20, 4, 6, 73),
(4, 4, NULL, '数据智能组', 88.40, 4, 79.50, 4, 6, 69),
(5, 5, NULL, '通信协议组', 87.60, 5, 78.10, 3, 6, 71),
(6, 6, NULL, '基础平台组', 85.20, 6, 75.80, 3, 6, 65);

-- 插入任务提交数据（从原task_submisson迁移，需要关联student_id）
-- 注意：这里需要根据实际情况调整student_id
INSERT INTO `task_submission` (`id`, `task_id`, `student_id`, `team_id`, `description`, `file_url`, `file_name`, `file_size`, `submitted_at`) VALUES
(1, 35, 1, 4, '111', '/uploads/team-submissions/80b89bf9-13fc-44d8-9981-722908ea60b9.docx', 'QU2BZZMe8Com3068d97c66689a077c5f823b5718449f.docx', 94665, '2025-11-19 19:53:57'),
(2, 35, 1, 4, '222', '/uploads/team-submissions/0e902f2d-72be-4f6f-8d82-4b4a1db44d9a.docx', 'H0xgDcioqVSGe4a22a6b047614d96ba85deba2c1ee09.docx', 26014, '2025-11-19 20:12:00'),
(3, 37, 3, 6, '333', '/uploads/team-submissions/7b81a449-1f9e-4b11-ab47-70e250e8a54d.docx', 'yapZTf0vFHE84d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-19 20:12:16'),
(4, 36, 2, 5, '123', '/uploads/team-submissions/5af34318-4710-49b1-91bb-655a521e31cf.docx', '8qg9ZAhFlJO9a3f46d66dfb50c99134cf31e1fd2bef6.docx', 80749, '2025-11-19 20:15:52'),
(5, 28, 1, NULL, '111', '/uploads/team-submissions/b67deb90-8d97-4580-9c5c-a7601b209a2a.docx', 'oElxr7Mbo85e4d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-19 20:40:50'),
(6, 9, 1, NULL, '34', '/uploads/team-submissions/2b487784-d882-46bb-ac3f-ff87057766c0.docx', 'Gyz4TTmEwrHdb41b47fb8f8497dbfad8ecb73fc2dcb9.docx', 24910, '2025-11-21 16:30:21'),
(7, 29, 1, NULL, '345', '/uploads/team-submissions/5da4538e-8a79-43a7-87f6-820497d764b7.docx', 'mAmRysxYr1uua3f46d66dfb50c99134cf31e1fd2bef6.docx', 80749, '2025-11-21 16:35:30'),
(8, 30, 1, NULL, '2323', '/uploads/team-submissions/4fed32a8-dc70-4c56-9ff9-3f1be5343318.docx', 'CgD9e4T8MvWD4d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-21 16:43:03'),
(9, 32, 1, NULL, '34343', '/uploads/team-submissions/86341065-5117-40fd-95fa-96e9c4902104.docx', 'caXHupIewZJ84d91a15339a1708c2defbc907e3e9aac.docx', 155574, '2025-11-21 16:43:33'),
(10, 36, 2, 5, '34343', '/uploads/team-submissions/e38a2cca-94f0-4813-ab42-a18ddeda9109.doc', 'nn4FqWCDKHdza41cba0826fc3e11b885a8c10dc3ae6b.doc', 342067, '2025-11-21 16:49:48');

-- 插入优秀作业数据（优化，关联submission_id和student_id/team_id）
INSERT INTO `excellent_work` (`id`, `task_id`, `course_id`, `submission_id`, `work_title`, `student_id`, `team_id`, `score`, `summary`, `teacher_comment`, `attachment_url`, `is_featured`) VALUES
(1, 1, 1, NULL, '智能温室监控系统', NULL, 1, 96.50, '利用多传感器融合实现温室环境的实时调控，并完成AI预测模型。', '逻辑清晰、数据扎实，代码结构优良，值得全班同学学习。', '/uploads/team-submissions/0e902f2d-72be-4f6f-8d82-4b4a1db44d9a.docx', 1),
(2, 2, 1, NULL, '物联网通信协议优化方案', NULL, 2, 94.30, '通过分析协议瓶颈，提出轻量化通信方案并验证延迟降低20%。', '问题分析深入，实验设计扎实，对性能优化有明显效果。', '/uploads/team-submissions/protocol.zip', 1),
(3, 13, 2, NULL, 'AI模型可解释性可视化', 1, NULL, 95.80, '为分类模型构建可解释性面板，直观展示特征贡献。', '创新性强，界面体验好，代码规范。', '/uploads/team-submissions/explainable-ai.pdf', 1);

SET FOREIGN_KEY_CHECKS = 1;

