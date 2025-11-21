package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.TaskItem;

import com.example.aicongyou_backend.entity.Task;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface TaskMapper {

    @Select("""
            <script>
            SELECT
                t.id AS taskId,
                t.course_id AS courseId,
                t.name AS taskName,
                t.description,
                t.type,
                t.deadline
            FROM task t
            <where>
                1 = 1
                <if test="taskType != null and taskType != ''">
                    AND t.type = #{taskType}
                </if>
            </where>
            ORDER BY t.deadline IS NULL, t.deadline ASC, t.id ASC
            </script>
            """)
    List<TaskItem> queryTasks(@Param("taskType") String taskType);

    @Select("SELECT * FROM task WHERE status = 1 ORDER BY create_time DESC")
    List<Task> findActiveTasks();

    @Select("SELECT t.*, st.status as student_status, st.score " +
            "FROM task t LEFT JOIN student_task st ON t.id = st.task_id AND st.student_id = #{studentId} " +
            "WHERE t.status = 1 ORDER BY t.create_time DESC")
    List<Map<String, Object>> findTasksWithStudentStatus(@Param("studentId") Long studentId);

    @Select("SELECT COUNT(*) FROM student_task WHERE student_id = #{studentId} AND status = 2")
    Integer countCompletedTasks(@Param("studentId") Long studentId);

    @Select("SELECT COUNT(*) FROM student_task WHERE student_id = #{studentId}")
    Integer countTotalTasks(@Param("studentId") Long studentId);

    @Select("SELECT COALESCE(AVG(score), 0) FROM student_task WHERE student_id = #{studentId} AND score IS NOT NULL")
    Double getAverageScore(@Param("studentId") Long studentId);

    @Select("""
            <script>
            SELECT
                t.id AS taskId,
                t.course_id AS courseId,
                t.name AS taskName,
                t.description,
                t.type,
                t.deadline,
                COALESCE(COUNT(DISTINCT ts.id), 0) AS submitted,
                COALESCE((
                    SELECT COUNT(DISTINCT ucp.user_id)
                    FROM user_course_progress ucp
                    WHERE ucp.course_id = t.course_id
                ), 24) AS total,
                CASE
                    WHEN COALESCE((
                        SELECT COUNT(DISTINCT ucp.user_id)
                        FROM user_course_progress ucp
                        WHERE ucp.course_id = t.course_id
                    ), 24) > 0 THEN
                        ROUND(COALESCE(COUNT(DISTINCT ts.id), 0) * 100.0 / COALESCE((
                            SELECT COUNT(DISTINCT ucp.user_id)
                            FROM user_course_progress ucp
                            WHERE ucp.course_id = t.course_id
                        ), 24), 0)
                    ELSE 0
                END AS submitRate,
                ROUND(60 + (COALESCE(COUNT(DISTINCT ts.id), 0) * 2) + (CHAR_LENGTH(t.description) % 20), 0) AS popularity
            FROM task t
            LEFT JOIN task_submisson ts ON t.id = ts.task_id AND ts.task_type = '个人任务'
            <where>
                1 = 1
                <if test="courseId != null">
                    AND t.course_id = #{courseId}
                </if>
                AND t.type = '个人任务'
            </where>
            GROUP BY t.id, t.course_id, t.name, t.description, t.type, t.deadline
            ORDER BY t.deadline IS NULL, t.deadline ASC, t.id ASC
            </script>
            """)
    List<Map<String, Object>> queryPersonalTasksWithStats(@Param("courseId") Integer courseId);
}
