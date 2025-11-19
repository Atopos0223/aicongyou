package com.example.aicongyou_backend.service;


import com.example.aicongyou_backend.entity.StudentTask;
import com.example.aicongyou_backend.mapper.StudentTaskMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class StudentTaskService {

    @Autowired
    private StudentTaskMapper studentTaskMapper;

    @Transactional
    public boolean updateTaskStatus(Integer userId, Integer taskId, String status, Double score) {
        try {
            StudentTask studentTask = new StudentTask();
            studentTask.setUserId(userId);
            studentTask.setTaskId(taskId);
            studentTask.setStatus(status);
            studentTask.setScore(score);

            if ("completed".equals(status)) {
                studentTask.setCompletedTime(LocalDateTime.now());
            } else {
                studentTask.setCompletedTime(null);
            }

            int result = studentTaskMapper.upsertStudentTask(studentTask);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Integer getTotalCompletedTasks(Integer userId) {
        return studentTaskMapper.countCompletedTasksByUser(userId);
    }

    public Integer getCompletedTasksByCourse(Integer userId, Integer courseId) {
        return studentTaskMapper.countCompletedTasksByCourse(userId, courseId);
    }
}
