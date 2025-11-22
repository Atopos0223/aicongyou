# 爱从游系统数据库设计说明

## 设计概述

本数据库设计基于现有 `aicongyou.sql` 文件进行了全面优化和重新设计，在保留原有数据的基础上，完善了表结构，修正了错误，并新增了必要的功能支持。新设计支持学生课程学习、任务管理、团队协作、能力维度评估、AI讨论等核心功能。

## 基于现有SQL的改进

### 保留的内容
- ✅ 保留了所有原有课程数据（7门课程）
- ✅ 保留了所有原有任务数据（37个任务）
- ✅ 保留了原有任务的热度指数和提交统计
- ✅ 保留了优秀作业数据
- ✅ 保留了用户课程进度数据

### 修正的问题
- ✅ **修正表名拼写错误**：`task_submisson` → `task_submission`
- ✅ **优化deadline字段**：从 `date` 改为 `datetime`，支持精确到秒的截止时间
- ✅ **移除冗余字段**：`task` 表中移除了 `submit_total` 和 `submitted_students`（这些数据应该从 `task_submission` 表动态计算）

## 主要改进点

### 1. 用户管理模块
- **新增 `user` 表**：统一管理学生、教师和管理员
  - 支持角色区分（student/teacher/admin）
  - 完整的用户信息字段（学号、姓名、头像、班级等）
  - 支持账号状态管理

### 2. 课程管理模块
- **优化 `course` 表**：
  - 增加教师关联（teacher_id）
  - 增加课程状态管理
  - 保留原有封面颜色等字段

- **新增 `student_course` 表**：学生选课关联表
  - 支持学生选课/退课
  - 记录选课时间

### 3. 任务管理模块
- **优化 `task` 表**：
  - 增加任务状态字段（未开始/进行中/已结束）
  - 优化截止日期为datetime类型
  - 保留热度指数等字段

### 4. 团队管理模块
- **新增 `team` 表**：团队信息表
  - ✅ 支持团队创建和管理
  - ✅ 记录队长信息（`leader_id`）
  - ✅ 支持最大成员数限制
  - ✅ 记录当前成员数

- **新增 `team_member` 表**：团队成员表
  - ✅ 记录团队成员及角色（leader/member）
  - ✅ 支持贡献度统计（`contribution_rate`）
  - ✅ 支持成员加入/退出（通过status字段）

### 5. 作业提交模块
- **优化 `task_submission` 表**（原 `task_submisson`）：
  - ✅ 修正表名拼写错误：`task_submisson` → `task_submission`
  - ✅ 增加学生ID关联（`student_id`），替代原来的 `submitter_name`
  - ✅ 增加团队ID关联（`team_id`），替代原来的 `team_name` 字符串
  - ✅ 增加评分相关字段（`score`, `status`, `teacher_comment`, `graded_at`）
  - ✅ 保留原有提交数据，通过 `student_id` 和 `team_id` 关联

### 6. 优秀作业模块
- **优化 `excellent_work` 表**：
  - 关联提交记录ID（submission_id）
  - 增加浏览次数、点赞数统计
  - 增加精选标识
  - 支持个人和团队作业

- **新增 `excellent_work_interaction` 表**：优秀作业互动表
  - 支持点赞和收藏功能
  - 记录学生互动行为

### 7. 能力维度评估模块（新增）
- **新增 `ability_dimension` 表**：能力维度定义表
  - 支持工程认证相关的能力维度
  - 包含6个标准维度：
    1. 问题分析能力
    2. 设计开发能力
    3. 研究能力
    4. 使用现代工具能力
    5. 工程与社会
    6. 环境和可持续发展

- **新增 `task_ability_dimension` 表**：任务能力维度关联表
  - 每个任务可以关联多个能力维度
  - 支持权重设置

- **新增 `student_ability_achievement` 表**：学生能力维度达成度表
  - 记录学生在每个课程中各个能力维度的达成度
  - 支持总得分和满分记录
  - 用于数据看板展示

### 8. 数据看板模块
- **优化 `student_course_statistics` 表**（原 `user_course_progress`）：
  - ✅ 重命名表：`user_course_progress` → `student_course_statistics`
  - ✅ 增加 `total_score` 字段：记录课程总得分（汇总所有任务得分）
  - ✅ 增加 `ranking` 字段：记录课程内排名
  - ✅ 保留原有进度数据（`completed_tasks`, `total_tasks`, `progress_rate`）
  - ✅ 支持数据看板的核心功能

### 9. AI讨论模块
- **新增 `ai_discussion` 表**：AI讨论记录表
  - 记录学生与AI的对话历史
  - 支持按任务和学生查询
  - 支持消息类型区分（user/ai）

## 数据库表关系图

```
user (用户)
  ├── course (课程) [teacher_id]
  ├── student_course (学生选课) [student_id]
  ├── team (团队) [leader_id]
  ├── team_member (团队成员) [student_id]
  ├── task_submission (任务提交) [student_id]
  ├── student_course_statistics (课程统计) [student_id]
  ├── student_ability_achievement (能力达成度) [student_id]
  └── ai_discussion (AI讨论) [student_id]

course (课程)
  ├── task (任务) [course_id]
  ├── student_course (学生选课) [course_id]
  ├── team (团队) [course_id]
  ├── excellent_work (优秀作业) [course_id]
  └── student_course_statistics (课程统计) [course_id]

task (任务)
  ├── task_submission (任务提交) [task_id]
  ├── excellent_work (优秀作业) [task_id]
  ├── task_ability_dimension (任务能力维度) [task_id]
  └── ai_discussion (AI讨论) [task_id]

team (团队)
  ├── team_member (团队成员) [team_id]
  ├── task_submission (任务提交) [team_id]
  └── excellent_work (优秀作业) [team_id]

ability_dimension (能力维度)
  ├── task_ability_dimension (任务能力维度) [dimension_id]
  └── student_ability_achievement (能力达成度) [dimension_id]

excellent_work (优秀作业)
  └── excellent_work_interaction (互动记录) [work_id]
```

## 核心功能支持

### 1. 个人数据看板
- **课程总得分**：通过 `student_course_statistics.total_score` 获取
- **总排名**：通过 `student_course_statistics.ranking` 获取
- **能力维度达成度分析**：通过 `student_ability_achievement` 表查询
- **已完成任务列表**：通过 `task_submission` 表查询已提交的任务
- **待完成任务提醒**：通过 `task` 表和 `task_submission` 表对比获取

### 2. 任务管理
- 支持个人任务和团队任务
- 支持任务状态管理
- 支持热度指数统计
- 支持提交率统计

### 3. 团队协作
- 支持团队创建和管理
- 支持成员贡献度统计
- 支持团队任务提交

### 4. 能力评估
- 支持多维度能力评估
- 支持任务与能力维度关联
- 支持达成度自动计算

### 5. AI讨论
- 支持按任务查询讨论历史
- 支持消息类型区分

## 数据完整性

- 所有外键关系都设置了适当的约束
- 支持级联删除（CASCADE）和置空（SET NULL）
- 关键字段设置了唯一索引
- 支持软删除（通过status字段）

## 性能优化

- 关键查询字段都建立了索引
- 复合索引支持多条件查询
- 统计表支持快速查询数据看板信息

## 数据迁移说明

### 从现有数据库迁移

如果要从现有的 `aicongyou.sql` 迁移到新设计，需要执行以下步骤：

1. **用户数据迁移**：
   ```sql
   -- 需要根据现有数据创建用户记录
   -- 建议根据 task_submisson 表中的 submitter_name 创建用户
   ```

2. **任务提交数据迁移**：
   ```sql
   -- 从 task_submisson 迁移到 task_submission
   -- 需要将 submitter_name 映射到 student_id
   -- 需要将 team_name 映射到 team_id
   ```

3. **团队数据迁移**：
   ```sql
   -- 从 team_task_board 和 task_submisson 中提取团队信息
   -- 创建 team 和 team_member 记录
   ```

4. **优秀作业数据迁移**：
   ```sql
   -- 将 student_name 和 team_name 映射到 student_id 和 team_id
   -- 关联 submission_id（如果可能）
   ```

## 使用建议

1. **数据维护**：
   - 定期更新 `student_course_statistics` 表（可通过触发器或定时任务）
   - 定期计算 `student_ability_achievement` 表（基于任务得分和能力维度权重）
   - 定期更新排名信息（按课程分组计算）

2. **性能优化**：
   - 关键查询字段已建立索引
   - 统计表支持快速查询数据看板信息
   - 建议对大数据量表进行分区

3. **扩展性**：
   - 能力维度可以根据需要扩展（修改 `ability_dimension` 表）
   - 用户角色可以扩展（修改 `user.role` 字段）
   - 任务类型可以扩展（修改 `task.type` 字段）

## 注意事项

1. **表名修正**：`task_submisson` → `task_submission`（注意拼写）
2. **字段类型**：
   - 所有时间字段统一使用 `datetime` 类型
   - 金额和百分比统一使用 `decimal` 类型保证精度
   - 所有表都包含 `create_time` 和 `update_time` 字段
3. **外键约束**：所有外键都设置了适当的级联操作
4. **数据完整性**：关键字段设置了唯一索引和NOT NULL约束
5. **向后兼容**：保留了 `team_task_board.team_name` 字段以兼容现有代码

