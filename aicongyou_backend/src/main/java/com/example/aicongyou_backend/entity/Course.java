package com.example.aicongyou_backend.entity;


import java.time.LocalDateTime;

public class Course {
    private Integer id;
    private String title;
    private String term;
    private String description;
    private String coverColor;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // 扩展字段（用于前端显示进度）
    private Integer totalTasks;
    private Integer completedTasks;
    private Double progress;

    // getters and setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getTerm() { return term; }
    public void setTerm(String term) { this.term = term; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCoverColor() { return coverColor; }
    public void setCoverColor(String coverColor) { this.coverColor = coverColor; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    public LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(LocalDateTime updateTime) { this.updateTime = updateTime; }
    public Integer getTotalTasks() { return totalTasks; }
    public void setTotalTasks(Integer totalTasks) { this.totalTasks = totalTasks; }
    public Integer getCompletedTasks() { return completedTasks; }
    public void setCompletedTasks(Integer completedTasks) { this.completedTasks = completedTasks; }
    public Double getProgress() { return progress; }
    public void setProgress(Double progress) { this.progress = progress; }
}


