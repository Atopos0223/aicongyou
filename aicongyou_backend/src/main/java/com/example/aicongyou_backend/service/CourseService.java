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

    public Course findById(Integer id) {
        return courseMapper.findById(id);
    }

    public List<Course> findCoursesWithProgress(Integer userId, String term, String keyword) {
        return courseMapper.findCoursesWithProgress(userId, term, keyword);
    }
}


