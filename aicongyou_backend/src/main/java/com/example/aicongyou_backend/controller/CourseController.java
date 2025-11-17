package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.entity.Course;
import com.example.aicongyou_backend.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
@RequestMapping("/api/course")
public class CourseController {
    @Autowired
    private CourseService courseService;

    @GetMapping("/list")
    public Map<String, Object> getCourseList(
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) String term,
            @RequestParam(required = false) String keyword) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Course> courses = courseService.getCourses(userId, term, keyword);
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", courses);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", e.getMessage());
            result.put("data", null);
        }
        return result;
    }
}


