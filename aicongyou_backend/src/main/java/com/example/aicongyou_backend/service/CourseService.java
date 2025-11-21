package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.Course;
import com.example.aicongyou_backend.mapper.CourseMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseService {
    @Autowired
    private CourseMapper courseMapper;

    public List<Course> getCourses(Integer userId, String term, String keyword) {
        // 暂时使用固定用户ID 1，后续可以从登录信息中获取
        if (userId == null) {
            userId = 1;
        }
        return courseMapper.getCourses(userId, term, keyword);
    }
}


