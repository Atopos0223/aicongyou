package com.example.aicongyou_backend.mapper;

import com.example.aicongyou_backend.entity.TaskSubmisson;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;

@Mapper
public interface TaskSubmissonMapper {

    @Insert("""
            INSERT INTO task_submisson
            (task_id, task_type, team_name, submitter_name, description, file_url, file_name, file_size, created_at)
            VALUES
            (#{taskId}, #{taskType}, #{teamName}, #{submitterName}, #{description}, #{fileUrl}, #{fileName}, #{fileSize}, NOW())
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void insertSubmission(TaskSubmisson submission);
}


