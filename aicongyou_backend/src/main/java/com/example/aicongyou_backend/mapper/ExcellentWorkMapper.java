package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.ExcellentWorkItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ExcellentWorkMapper {

    @Select("""
            <script>
            SELECT
                ew.id,
                ew.task_id AS taskId,
                ew.course_id AS courseId,
                c.title AS courseTitle,
                t.name AS taskName,
                ew.work_title AS workTitle,
                ew.student_name AS studentName,
                ew.team_name AS teamName,
                ew.score,
                ew.summary,
                ew.teacher_comment AS teacherComment,
                ew.attachment_url AS attachmentUrl,
                ew.created_at AS createdAt
            FROM excellent_work ew
            LEFT JOIN task t ON ew.task_id = t.id
            LEFT JOIN course c ON ew.course_id = c.id
            <where>
                1 = 1
                <if test="taskId != null">
                    AND ew.task_id = #{taskId}
                </if>
                <if test="courseId != null">
                    AND ew.course_id = #{courseId}
                </if>
            </where>
            ORDER BY ew.score DESC, ew.created_at DESC
            </script>
            """)
    List<ExcellentWorkItem> listExcellentWorks(@Param("taskId") Integer taskId,
                                               @Param("courseId") Integer courseId);
}


