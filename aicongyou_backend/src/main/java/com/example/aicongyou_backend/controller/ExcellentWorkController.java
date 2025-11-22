package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.entity.ExcellentWorkItem;
import com.example.aicongyou_backend.service.ExcellentWorkService;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/excellent-work")
@CrossOrigin
public class ExcellentWorkController {

    private final ExcellentWorkService excellentWorkService;

    public ExcellentWorkController(ExcellentWorkService excellentWorkService) {
        this.excellentWorkService = excellentWorkService;
    }

    @GetMapping
    public List<ExcellentWorkItem> list(@RequestParam(value = "taskId", required = false) Integer taskId,
                                        @RequestParam(value = "courseId", required = false) Integer courseId) {
        return excellentWorkService.listByTask(taskId, courseId);
    }
}


