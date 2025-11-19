package com.example.aicongyou_backend.mapper;



import com.example.aicongyou_backend.entity.Task;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface TaskMapper {

    @Select("SELECT t.*, " +
            "       CASE WHEN st.status = 'completed' THEN true ELSE false END as isCompleted, " +
            "       st.completed_time as completedTime, " +
            "       st.score " +
            "FROM task t " +
            "LEFT JOIN student_task st ON t.id = st.task_id AND st.user_id = #{userId} " +
            "WHERE t.course_id = #{courseId} " +
            "ORDER BY t.deadline ASC, t.id ASC")
    List<Task> findTasksWithUserStatus(@Param("courseId") Integer courseId,
                                       @Param("userId") Integer userId);

    @Select("SELECT COUNT(*) FROM task WHERE course_id = #{courseId}")
    Integer countByCourseId(Integer courseId);

    @Select("SELECT * FROM task WHERE id = #{id}")
    Task findById(Integer id);
}