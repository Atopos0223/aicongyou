package com.example.aicongyou_backend.mapper;


import com.example.aicongyou_backend.entity.Course;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CourseMapper {

    @Select("SELECT * FROM course WHERE id = #{id}")
    Course findById(Integer id);

    @Select("<script>" +
            "SELECT c.*, " +
            "       (SELECT COUNT(*) FROM task WHERE course_id = c.id) as totalTasks, " +
            "       COALESCE(ucp.completed_tasks, 0) as completedTasks, " +
            "       COALESCE(ucp.progress, 0) as progress " +
            "FROM course c " +
            "LEFT JOIN user_course_progress ucp ON c.id = ucp.course_id AND ucp.user_id = #{userId} " +
            "WHERE 1=1 " +
            "<if test='term != null and term != \"\"'> AND c.term = #{term} </if>" +
            "<if test='keyword != null and keyword != \"\"'> " +
            "   AND (c.title LIKE CONCAT('%', #{keyword}, '%') OR c.description LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "ORDER BY c.term DESC, c.id DESC" +
            "</script>")
    List<Course> findCoursesWithProgress(@Param("userId") Integer userId,
                                         @Param("term") String term,
                                         @Param("keyword") String keyword);
}
