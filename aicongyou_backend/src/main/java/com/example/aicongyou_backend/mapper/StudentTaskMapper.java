package com.example.aicongyou_backend.mapper;


import com.example.aicongyou_backend.entity.StudentTask;
import org.apache.ibatis.annotations.*;

@Mapper
public interface StudentTaskMapper {

    @Insert("INSERT INTO student_task (user_id, task_id, status, completed_time, score) " +
            "VALUES (#{userId}, #{taskId}, #{status}, #{completedTime}, #{score}) " +
            "ON DUPLICATE KEY UPDATE status = VALUES(status), " +
            "completed_time = VALUES(completed_time), score = VALUES(score), update_time = NOW()")
    int upsertStudentTask(StudentTask studentTask);

    @Select("SELECT * FROM student_task WHERE user_id = #{userId} AND task_id = #{taskId}")
    StudentTask findByUserAndTask(@Param("userId") Integer userId, @Param("taskId") Integer taskId);

    @Select("SELECT COUNT(*) FROM student_task WHERE user_id = #{userId} AND status = 'completed'")
    Integer countCompletedTasksByUser(Integer userId);

    @Select("SELECT COUNT(*) FROM student_task st " +
            "JOIN task t ON st.task_id = t.id " +
            "WHERE st.user_id = #{userId} AND st.status = 'completed' AND t.course_id = #{courseId}")
    Integer countCompletedTasksByCourse(@Param("userId") Integer userId, @Param("courseId") Integer courseId);
}