package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.service.TeamBoardService;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/team-board")
@CrossOrigin
public class TeamBoardController {

    private final TeamBoardService teamBoardService;

    public TeamBoardController(TeamBoardService teamBoardService) {
        this.teamBoardService = teamBoardService;
    }

    @GetMapping
    public Map<String, Object> getTeamBoard(@RequestParam(value = "courseId", required = false) Integer courseId) {
        return teamBoardService.getTeamBoard(courseId);
    }
}

