package com.example.aicongyou_backend.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

public class TeamTaskBoardItem {
    private Integer taskId;
    private Integer courseId;
    private String courseTitle;
    private String taskName;
    private String description;
    private String taskType;
    private LocalDate deadline;
    private String teamName;
    private BigDecimal teamScore;
    private Integer teamRank;
    private BigDecimal individualContribution;
    private Integer submittedMembers;
    private Integer totalMembers;
    private BigDecimal submitRate;
    private Integer popularityIndex;

    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public LocalDate getDeadline() {
        return deadline;
    }

    public void setDeadline(LocalDate deadline) {
        this.deadline = deadline;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public BigDecimal getTeamScore() {
        return teamScore;
    }

    public void setTeamScore(BigDecimal teamScore) {
        this.teamScore = teamScore;
    }

    public Integer getTeamRank() {
        return teamRank;
    }

    public void setTeamRank(Integer teamRank) {
        this.teamRank = teamRank;
    }

    public BigDecimal getIndividualContribution() {
        return individualContribution;
    }

    public void setIndividualContribution(BigDecimal individualContribution) {
        this.individualContribution = individualContribution;
    }

    public Integer getSubmittedMembers() {
        return submittedMembers;
    }

    public void setSubmittedMembers(Integer submittedMembers) {
        this.submittedMembers = submittedMembers;
    }

    public Integer getTotalMembers() {
        return totalMembers;
    }

    public void setTotalMembers(Integer totalMembers) {
        this.totalMembers = totalMembers;
    }

    public BigDecimal getSubmitRate() {
        return submitRate;
    }

    public void setSubmitRate(BigDecimal submitRate) {
        this.submitRate = submitRate;
    }

    public Integer getPopularityIndex() {
        return popularityIndex;
    }

    public void setPopularityIndex(Integer popularityIndex) {
        this.popularityIndex = popularityIndex;
    }
}

