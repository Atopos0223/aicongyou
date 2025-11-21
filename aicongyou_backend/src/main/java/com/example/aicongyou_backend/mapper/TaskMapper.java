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
                <if test="courseId != null">
                    AND t.course_id = #{courseId}
                </if>
            </where>
            ORDER BY t.deadline IS NULL, t.deadline ASC, t.id ASC
            </script>
            """)
    List<TaskItem> queryTasks(@Param("taskType") String taskType,
                              @Param("courseId") Integer courseId);

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
                t.submitted_students AS submittedCount,
                t.submitted_students AS submitted,
                t.submit_total AS submitTotal,
                t.submit_total AS total,
                CASE
                    WHEN t.submit_total > 0 THEN
                        ROUND(t.submitted_students * 100.0 / t.submit_total, 0)
                    ELSE 0
                END AS submitRate,
                COALESCE(t.heat_index, 70) AS heatIndex,
                COALESCE(t.heat_index, 70) AS popularity
            FROM task t
            WHERE t.type = '个人任务'
            <if test="courseId != null">
                AND t.course_id = #{courseId}
            </if>
            ORDER BY COALESCE(t.heat_index, 70) DESC, t.deadline IS NULL, t.deadline ASC, t.id ASC
            </script>
            """)
    List<Map<String, Object>> queryPersonalTasksWithStats(@Param("courseId") Integer courseId);
}
