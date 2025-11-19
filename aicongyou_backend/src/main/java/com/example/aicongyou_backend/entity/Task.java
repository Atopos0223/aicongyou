package com.example.aicongyou_backend.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Task {
    private Integer id;
    private Integer courseId;
    private String name;
    private String description;
    private String type;
    private LocalDate deadline;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // 扩展字段（用于前端显示用户完成状态）
    private Boolean isCompleted;
    private LocalDateTime completedTime;
    private Double score;

    // getters and setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getCourseId() { return courseId; }
    public void setCourseId(Integer courseId) { this.courseId = courseId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public LocalDate getDeadline() { return deadline; }
    public void setDeadline(LocalDate deadline) { this.deadline = deadline; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    public LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(LocalDateTime updateTime) { this.updateTime = updateTime; }
    public Boolean getIsCompleted() { return isCompleted; }
    public void setIsCompleted(Boolean completed) { isCompleted = completed; }
    public LocalDateTime getCompletedTime() { return completedTime; }
    public void setCompletedTime(LocalDateTime completedTime) { this.completedTime = completedTime; }
    public Double getScore() { return score; }
    public void setScore(Double score) { this.score = score; }
}
