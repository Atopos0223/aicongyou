package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.Course;
import com.example.aicongyou_backend.mapper.CourseMapper;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@Service
public class CourseService {

    private static final Comparator<Course> TERM_DESC_COMPARATOR = Comparator
            .comparingInt(CourseService::extractYear).reversed()
            .thenComparingInt(CourseService::extractSeasonOrder).reversed()
            .thenComparing(Course::getTitle, Comparator.nullsLast(String::compareTo));

    private final CourseMapper courseMapper;

    public CourseService(CourseMapper courseMapper) {
        this.courseMapper = courseMapper;
    }

    public List<Course> listCourses(Long userId, String term, String keyword) {
        List<Course> courses = courseMapper.findCourses(userId, term, keyword);
        if (CollectionUtils.isEmpty(courses)) {
            return courses;
        }

        courses.forEach(this::enrichProgress);
        courses.sort(TERM_DESC_COMPARATOR);
        return courses;
    }

    private void enrichProgress(Course course) {
        int totalTasks = defaultInt(course.getTotalTasks());
        int completedTasks = defaultInt(course.getCompletedTasks());
        int completionRate = totalTasks > 0 ? (int) Math.round(completedTasks * 100.0 / totalTasks) : 0;
        course.setCompletionRate(Math.min(100, Math.max(0, completionRate)));
        if (course.getProgress() == null || course.getProgress() == 0) {
            course.setProgress(course.getCompletionRate());
        } else {
            course.setProgress(Math.min(100, Math.max(0, course.getProgress())));
        }
    }

    private static int defaultInt(Integer value) {
        return value == null ? 0 : value;
    }

    private static int extractYear(Course course) {
        if (course == null || course.getTerm() == null || course.getTerm().length() < 4) {
            return 0;
        }
        try {
            return Integer.parseInt(course.getTerm().substring(0, 4));
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    private static int extractSeasonOrder(Course course) {
        if (course == null || course.getTerm() == null || course.getTerm().length() < 6) {
            return 0;
        }
        String season = course.getTerm().substring(5);
        return switch (season) {
            case "春季" -> 1;
            case "夏季" -> 2;
            case "秋季" -> 3;
            case "冬季" -> 4;
            default -> 0;
        };
    }
}

