package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.entity.TaskItem;
import com.example.aicongyou_backend.service.TaskService;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
@CrossOrigin
public class TaskController {

    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @GetMapping
    public List<TaskItem> listTasks(@RequestParam(value = "taskType", required = false) String taskType) {
        return taskService.getTasks(taskType);
    }
}


