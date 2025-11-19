package com.example.aicongyou_backend.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private Long id;
    private String studentId;
    private String name;
    private String avatar;
    private String className;
    private LocalDateTime createTime;
}