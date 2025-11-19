package com.example.aicongyou_backend.controller;



import com.example.aicongyou_backend.entity.Task;
import com.example.aicongyou_backend.service.TaskService;
import com.example.aicongyou_backend.service.StudentTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/task")
@CrossOrigin(origins = "*")
public class TaskController {

    @Autowired
    private TaskService taskService;

    @Autowired
    private StudentTaskService studentTaskService;

    @GetMapping("/list")
    public Map<String, Object> getCourseTasks(@RequestParam Integer courseId,
                                              @RequestParam(defaultValue = "1") Integer userId) {
        Map<String, Object> result = new HashMap<>();

        try {
            List<Task> tasks = taskService.getTasksByCourse(courseId, userId);
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", tasks);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }

        return result;
    }

    @PostMapping("/update-status")
    public Map<String, Object> updateTaskStatus(@RequestBody Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();

        try {
            Integer taskId = (Integer) params.get("taskId");
            Integer userId = (Integer) params.get("userId");
            String status = (String) params.get("status");
            Double score = params.get("score") != null ? Double.valueOf(params.get("score").toString()) : null;

            boolean success = studentTaskService.updateTaskStatus(userId, taskId, status, score);

            if (success) {
                result.put("code", 200);
                result.put("message", "任务状态更新成功");
            } else {
                result.put("code", 500);
                result.put("message", "任务状态更新失败");
            }
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }

        return result;
    }
}