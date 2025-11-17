package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.TeamTaskBoardItem;
import com.example.aicongyou_backend.mapper.TeamTaskBoardMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class TeamBoardService {

    private final TeamTaskBoardMapper teamTaskBoardMapper;

    public TeamBoardService(TeamTaskBoardMapper teamTaskBoardMapper) {
        this.teamTaskBoardMapper = teamTaskBoardMapper;
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
}

