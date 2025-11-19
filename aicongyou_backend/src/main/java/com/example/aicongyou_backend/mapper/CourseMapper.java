package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.Course;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CourseMapper {

    @Select("<script>" +
            "SELECT c.id, c.title, c.term, c.description, c.cover_color as coverColor, " +
            "COALESCE(task_count.total_tasks, 0) as totalTasks, " +
            "COALESCE(ucp.completed_tasks, 0) as completedTasks, " +
            "COALESCE(ucp.progress, 0) as progress, " +
            "CASE WHEN COALESCE(task_count.total_tasks, 0) > 0 " +
            "THEN ROUND(COALESCE(ucp.completed_tasks, 0) * 100.0 / task_count.total_tasks) " +
            "ELSE 0 END as completionRate " +
            "FROM course c " +
            "LEFT JOIN (SELECT course_id, COUNT(*) as total_tasks FROM task GROUP BY course_id) task_count ON c.id = task_count.course_id " +
            "LEFT JOIN user_course_progress ucp ON c.id = ucp.course_id AND ucp.user_id = #{userId} " +
            "WHERE 1=1 " +
            "<if test='term != null and term != \"\"'>" +
            "AND c.term = #{term} " +
            "</if>" +
            "<if test='keyword != null and keyword != \"\"'>" +
            "AND (c.title LIKE CONCAT('%', #{keyword}, '%') OR c.description LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "ORDER BY c.create_time DESC" +
            "</script>")
    List<Course> getCourses(@Param("userId") Integer userId, 
                           @Param("term") String term, 
                           @Param("keyword") String keyword);
}

