package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.TeamTaskBoardItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface TeamTaskBoardMapper {

    @Select("""
            <script>
            SELECT
                t.id AS taskId,
                t.course_id AS courseId,
                c.title AS courseTitle,
                t.name AS taskName,
                t.description,
                t.type AS taskType,
                t.deadline,
                CONCAT('团队', LPAD((t.id % 5) + 1, 2, '0')) AS teamName,
                COALESCE(t.task_score, 0) AS teamScore,
                ROW_NUMBER() OVER (ORDER BY COALESCE(t.deadline, CURRENT_DATE)) AS teamRank,
                ROUND(60 + (t.course_id % 5) * 5 + (t.id % 4) * 2, 2) AS individualContribution,
                COALESCE(ucp.completed_tasks, 0) AS submittedMembers,
                COALESCE(ucp.total_tasks, 0) AS totalMembers,
                CASE
                    WHEN COALESCE(ucp.total_tasks, 0) > 0 THEN ROUND(ucp.completed_tasks / ucp.total_tasks * 100, 2)
                    ELSE 0
                END AS submitRate,
                ROUND(60 + (CHAR_LENGTH(t.description) % 40), 0) AS popularityIndex
            FROM task t
            LEFT JOIN course c ON t.course_id = c.id
            LEFT JOIN user_course_progress ucp ON ucp.course_id = t.course_id AND ucp.user_id = 1
            <where>
                1 = 1
                <if test="courseId != null">
                    AND t.course_id = #{courseId}
                </if>
                AND t.type = '团队任务'
            </where>
            ORDER BY teamRank ASC
            </script>
            """)
    List<TeamTaskBoardItem> queryTeamBoard(@Param("courseId") Integer courseId);
}

