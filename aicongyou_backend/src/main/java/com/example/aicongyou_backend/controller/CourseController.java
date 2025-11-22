package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.dto.ApiResponse;
import com.example.aicongyou_backend.entity.Course;
import com.example.aicongyou_backend.service.CourseService;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/course")
@CrossOrigin(origins = "*")
public class CourseController {

    private final CourseService courseService;

    public CourseController(CourseService courseService) {
        this.courseService = courseService;
    }

    @GetMapping("/list")
    public ApiResponse<List<Course>> listCourses(
            @RequestParam(value = "userId", required = false) Long userId,
            @RequestParam(value = "term", required = false) String term,
            @RequestParam(value = "keyword", required = false) String keyword
    ) {
        Long resolvedUserId = userId != null ? userId : 1L;
        List<Course> courses = courseService.listCourses(resolvedUserId, term, keyword);
        return ApiResponse.success(courses);
    }
}

