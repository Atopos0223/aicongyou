package com.example.aicongyou_backend.controller;


import com.example.aicongyou_backend.entity.Task;
import com.example.aicongyou_backend.entity.TaskItem;
import com.example.aicongyou_backend.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tasks")
@CrossOrigin
public class TaskController {

    @Autowired
    private TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @GetMapping
    public List<TaskItem> listTasks(@RequestParam(value = "taskType", required = false) String taskType) {
        return taskService.getTasks(taskType);
    }

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

    @GetMapping("/personal")
    public List<Map<String, Object>> getPersonalTasks(@RequestParam(required = false) Integer courseId) {
        return taskService.getPersonalTasksByCourse(courseId);
    }
}