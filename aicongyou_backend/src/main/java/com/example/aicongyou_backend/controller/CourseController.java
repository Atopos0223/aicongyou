package com.example.aicongyou_backend.controller;


import com.example.aicongyou_backend.entity.Course;
import com.example.aicongyou_backend.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/course")
@CrossOrigin(origins = "*")
public class CourseController {

    @Autowired
    private CourseService courseService;

    @GetMapping("/list")
    public Map<String, Object> getCourseList(@RequestParam(defaultValue = "1") Integer userId,
                                             @RequestParam(required = false) String term,
                                             @RequestParam(required = false) String keyword) {
        Map<String, Object> result = new HashMap<>();

        try {
            List<Course> courses = courseService.findCoursesWithProgress(userId, term, keyword);
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", courses);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }

        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getCourseDetail(@PathVariable Integer id) {
        Map<String, Object> result = new HashMap<>();

        try {
            Course course = courseService.findById(id);
            if (course != null) {
                result.put("code", 200);
                result.put("message", "success");
                result.put("data", course);
            } else {
                result.put("code", 404);
                result.put("message", "课程不存在");
            }
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }

        return result;
    }
}


