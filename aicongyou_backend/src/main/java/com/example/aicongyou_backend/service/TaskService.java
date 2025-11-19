package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.Task;
import com.example.aicongyou_backend.mapper.TaskMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TaskService {

    @Autowired
    private TaskMapper taskMapper;

    public List<Task> getTasksByCourse(Integer courseId, Integer userId) {
        return taskMapper.findTasksWithUserStatus(courseId, userId);
    }

    public Integer getTotalTasksByCourse(Integer courseId) {
        return taskMapper.countByCourseId(courseId);
    }

    public Task getTaskById(Integer taskId) {
        return taskMapper.findById(taskId);
    }
}