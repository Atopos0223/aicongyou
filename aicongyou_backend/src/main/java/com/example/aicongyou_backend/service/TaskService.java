package com.example.aicongyou_backend.service;


import com.example.aicongyou_backend.entity.Task;
import com.example.aicongyou_backend.mapper.TaskMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class TaskService {

    @Autowired
    private TaskMapper taskMapper;

    public List<Task> getActiveTasks() {
        return taskMapper.findActiveTasks();
    }

    public List<Map<String, Object>> getTasksWithStudentStatus(Long studentId) {
        return taskMapper.findTasksWithStudentStatus(studentId);
    }

    public Map<String, Object> getStudentDashboard(Long studentId) {
        Integer completedTasks = taskMapper.countCompletedTasks(studentId);
        Integer totalTasks = taskMapper.countTotalTasks(studentId);
        Double averageScore = taskMapper.getAverageScore(studentId);

        Map<String, Object> dashboard = Map.of(
                "completedTasks", completedTasks,
                "totalTasks", totalTasks,
                "averageScore", averageScore,
                "completionRate", totalTasks > 0 ? (completedTasks * 100.0 / totalTasks) : 0
        );

        return dashboard;
    }
}