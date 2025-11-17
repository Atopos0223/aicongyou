package com.example.aicongyou_backend.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Task {
    private Long id;
    private String name;
    private String description;
    private String type; // 个人任务/小组任务
    private LocalDateTime deadline;
    private Integer totalStudents;
    private Integer submittedStudents;
    private Integer popularity;
    private Integer status; // 0-未开始 1-进行中 2-已结束
    private LocalDateTime createTime;
}
