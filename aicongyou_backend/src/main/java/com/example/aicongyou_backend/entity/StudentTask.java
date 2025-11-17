package com.example.aicongyou_backend.entity;


import lombok.Data;
import java.time.LocalDateTime;

@Data
public class StudentTask {
    private Long id;
    private Long studentId;
    private Long taskId;
    private Integer status; // 0-未完成 1-已完成 2-已提交
    private Integer score;
    private LocalDateTime submitTime;
    private LocalDateTime updateTime;
}