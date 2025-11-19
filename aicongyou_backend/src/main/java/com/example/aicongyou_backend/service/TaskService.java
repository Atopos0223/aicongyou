package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.TaskItem;
import com.example.aicongyou_backend.mapper.TaskMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TaskService {

    private final TaskMapper taskMapper;

    public TaskService(TaskMapper taskMapper) {
        this.taskMapper = taskMapper;
    }

    public List<TaskItem> getTasks(String category) {
        String normalized = normalizeCategory(category);
        return taskMapper.queryTasks(normalized);
    }

    private String normalizeCategory(String category) {
        if (category == null || category.isBlank()) {
            return null;
        }
        return switch (category.trim().toLowerCase()) {
            case "team", "团队任务" -> "团队任务";
            case "personal", "个人任务" -> "个人任务";
            default -> null;
        };
    }
}


