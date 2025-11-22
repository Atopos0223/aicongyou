package com.example.aicongyou_backend.entity;

import lombok.Data;

@Data
public class Course {
    private Long id;
    private String title;
    private String term;
    private String description;
    private String coverColor;
    private Integer totalTasks;
    private Integer completedTasks;
    private Integer progress;
    private Integer completionRate;
}

