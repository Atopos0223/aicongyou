package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.service.TeamBoardService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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

    @PostMapping(value = "/submit", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> submitTeamTask(@RequestParam("taskId") Integer taskId,
                                                              @RequestParam("taskType") String taskType,
                                                              @RequestParam(value = "teamName", required = false) String teamName,
                                                              @RequestParam(value = "submitterName", required = false) String submitterName,
                                                              @RequestParam(value = "description", required = false) String description,
                                                              @RequestPart("file") MultipartFile file) {
        try {
            Map<String, Object> response = teamBoardService.submitTask(taskId, taskType, teamName, submitterName, description, file);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "提交失败，请稍后再试"));
        }
    }
}

