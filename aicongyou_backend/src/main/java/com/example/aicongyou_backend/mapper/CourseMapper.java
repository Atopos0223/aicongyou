package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.Course;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CourseMapper {

    @Select({
            "<script>",
            "SELECT",
            "  c.id,",
            "  c.title,",
            "  c.term,",
            "  c.description,",
            "  c.cover_color AS coverColor,",
            "  COALESCE(ucp.total_tasks, 0) AS totalTasks,",
            "  COALESCE(ucp.completed_tasks, 0) AS completedTasks,",
            "  CAST(ROUND(COALESCE(ucp.progress, 0), 0) AS SIGNED) AS progress",
            "FROM course c",
            "LEFT JOIN user_course_progress ucp",
            "  ON c.id = ucp.course_id AND ucp.user_id = #{userId}",
            "<where>",
            "  1 = 1",
            "  <if test='term != null and term != \"\"'>",
            "    AND c.term = #{term}",
            "  </if>",
            "  <if test='keyword != null and keyword != \"\"'>",
            "    AND (c.title LIKE CONCAT('%', #{keyword}, '%')",
            "         OR c.description LIKE CONCAT('%', #{keyword}, '%'))",
            "  </if>",
            "</where>",
            "ORDER BY",
            "  CAST(SUBSTRING(c.term, 1, 4) AS UNSIGNED) DESC,",
            "  FIELD(SUBSTRING(c.term, 6), '春季','夏季','秋季','冬季') DESC",
            "</script>"
    })
    List<Course> findCourses(@Param("userId") Long userId,
                             @Param("term") String term,
                             @Param("keyword") String keyword);
}

