package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.TaskSubmisson;
import com.example.aicongyou_backend.entity.TeamTaskBoardItem;
import com.example.aicongyou_backend.mapper.TaskSubmissonMapper;
import com.example.aicongyou_backend.mapper.TeamTaskBoardMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

@Service
public class TeamBoardService {

    private final TeamTaskBoardMapper teamTaskBoardMapper;
    private final TaskSubmissonMapper taskSubmissonMapper;

    @Value("${submission.upload-dir:uploads/team-submissions}")
    private String submissionUploadDir;

    public TeamBoardService(TeamTaskBoardMapper teamTaskBoardMapper,
                            TaskSubmissonMapper taskSubmissonMapper) {
        this.teamTaskBoardMapper = teamTaskBoardMapper;
        this.taskSubmissonMapper = taskSubmissonMapper;
    }

    public Map<String, Object> getTeamBoard(Integer courseId) {
        List<TeamTaskBoardItem> boardItems = teamTaskBoardMapper.queryTeamBoard(courseId);

        BigDecimal totalScore = boardItems.stream()
                .map(TeamTaskBoardItem::getTeamScore)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal avgContribution = boardItems.isEmpty()
                ? BigDecimal.ZERO
                : boardItems.stream()
                .map(TeamTaskBoardItem::getIndividualContribution)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .divide(BigDecimal.valueOf(boardItems.size()), 2, RoundingMode.HALF_UP);

        String topTeamName = boardItems.stream()
                .filter(item -> item.getTeamRank() != null)
                .min(Comparator.comparing(TeamTaskBoardItem::getTeamRank)
                        .thenComparing(TeamTaskBoardItem::getTeamScore, Comparator.nullsLast(Comparator.reverseOrder())))
                .map(TeamTaskBoardItem::getTeamName)
                .orElse("");

        Map<String, Object> summary = new HashMap<>();
        summary.put("totalTeamScore", totalScore.setScale(2, RoundingMode.HALF_UP));
        summary.put("averageContribution", avgContribution.setScale(2, RoundingMode.HALF_UP));
        summary.put("totalTasks", boardItems.size());
        summary.put("topTeamName", topTeamName);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        summary.put("updatedAt", LocalDateTime.now().format(formatter));

        Map<String, Object> response = new HashMap<>();
        response.put("summary", summary);
        response.put("tasks", boardItems);

        return response;
    }

    public Map<String, Object> submitTask(Integer taskId,
                                          String taskType,
                                          String teamName,
                                          String submitterName,
                                          String description,
                                          MultipartFile file) {
        if (taskId == null) {
            throw new IllegalArgumentException("任务ID不能为空");
        }
        String normalizedTaskType = normalizeTaskType(taskType);
        if (normalizedTaskType == null) {
            throw new IllegalArgumentException("请选择任务类型");
        }
        boolean isTeamTask = "团队任务".equals(normalizedTaskType);
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("请上传提交附件");
        }
        if (description == null || description.isBlank()) {
            throw new IllegalArgumentException("请填写提交说明");
        }

        String resolvedTeamName;
        if (isTeamTask) {
            resolvedTeamName = (teamName == null || teamName.isBlank()) ? ("团队任务" + taskId) : teamName.trim();
        } else {
            resolvedTeamName = "";
        }
        String resolvedSubmitterName = (submitterName == null || submitterName.isBlank()) ? "团队成员" : submitterName.trim();

        String storedFileName = buildStoredFileName(file.getOriginalFilename());
        Path uploadPath = resolveUploadPath().resolve(storedFileName);
        try {
            Files.createDirectories(uploadPath.getParent());
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, uploadPath, StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException e) {
            throw new IllegalStateException("文件保存失败，请稍后再试", e);
        }

        TaskSubmisson submission = new TaskSubmisson();
        submission.setTaskId(taskId);
        submission.setTaskType(normalizedTaskType);
        submission.setTeamName(resolvedTeamName);
        submission.setSubmitterName(resolvedSubmitterName);
        submission.setDescription(description.trim());
        submission.setFileUrl(buildRelativeUrl(storedFileName));
        submission.setFileName(file.getOriginalFilename() != null ? file.getOriginalFilename() : storedFileName);
        submission.setFileSize(file.getSize());

        taskSubmissonMapper.insertSubmission(submission);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "提交成功");
        result.put("submissionId", submission.getId());
        result.put("fileUrl", submission.getFileUrl());
        return result;
    }

    private String normalizeTaskType(String taskType) {
        if (taskType == null || taskType.isBlank()) {
            return null;
        }
        String normalized = taskType.trim().toLowerCase();
        return switch (normalized) {
            case "team", "团队任务", "team_task" -> "团队任务";
            case "personal", "个人任务", "single_task" -> "个人任务";
            default -> null;
        };
    }

    private Path resolveUploadPath() {
        Path configuredPath = Paths.get(submissionUploadDir);
        if (configuredPath.isAbsolute()) {
            return configuredPath;
        }
        return Paths.get(System.getProperty("user.dir")).resolve(submissionUploadDir);
    }

    private String buildStoredFileName(String originalName) {
        String extension = "";
        if (originalName != null && originalName.lastIndexOf('.') >= 0) {
            extension = originalName.substring(originalName.lastIndexOf('.'));
        }
        return UUID.randomUUID() + extension;
    }

    private String buildRelativeUrl(String storedFileName) {
        String normalized = submissionUploadDir.replace("\\", "/");
        if (normalized.startsWith("./")) {
            normalized = normalized.substring(2);
        }
        if (!normalized.startsWith("/")) {
            normalized = "/" + normalized;
        }
        return normalized.endsWith("/")
                ? normalized + storedFileName
                : normalized + "/" + storedFileName;
    }
}

