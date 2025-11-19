package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.TaskItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

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
}


