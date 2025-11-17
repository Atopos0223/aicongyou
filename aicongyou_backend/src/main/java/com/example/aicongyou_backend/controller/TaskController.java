package com.example.aicongyou_backend.controller;


import com.example.aicongyou_backend.entity.Task;
import com.example.aicongyou_backend.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/task")
@CrossOrigin(origins = "*")
public class TaskController {

    @Autowired
    private TaskService taskService;

    @GetMapping("/list")
    public List<Map<String, Object>> getTaskList(@RequestParam Long studentId) {
        return taskService.getTasksWithStudentStatus(studentId);
    }

    @GetMapping("/dashboard")
    public Map<String, Object> getDashboard(@RequestParam Long studentId) {
        return taskService.getStudentDashboard(studentId);
    }

    @GetMapping("/active")
    public List<Task> getActiveTasks() {
        return taskService.getActiveTasks();
    }
}
