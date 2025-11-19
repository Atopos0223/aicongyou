package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.Course;
import com.example.aicongyou_backend.mapper.CourseMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CourseServiceTest {

    @Mock
    private CourseMapper courseMapper;

    @InjectMocks
    private CourseService courseService;

    @Test
    void shouldSortCoursesByTermAndCalculateCompletionRate() {
        Course c2023 = buildCourse("2023年秋季", 10, 4, 0);
        Course c2025Spring = buildCourse("2025年春季", 15, 9, 60);
        Course c2025Autumn = buildCourse("2025年秋季", 16, 12, null);

        when(courseMapper.findCourses(eq(1L), eq(null), eq(null)))
                .thenReturn(Arrays.asList(c2023, c2025Spring, c2025Autumn));

        List<Course> result = courseService.listCourses(1L, null, null);

        assertThat(result).hasSize(3);
        assertThat(result.get(0).getTerm()).isEqualTo("2025年秋季");
        assertThat(result.get(0).getCompletionRate()).isEqualTo(75);
        assertThat(result.get(0).getProgress()).isEqualTo(75);

        assertThat(result.get(1).getTerm()).isEqualTo("2025年春季");
        assertThat(result.get(1).getCompletionRate()).isEqualTo(60);
        assertThat(result.get(1).getProgress()).isEqualTo(60);

        assertThat(result.get(2).getTerm()).isEqualTo("2023年秋季");
        assertThat(result.get(2).getCompletionRate()).isEqualTo(40);
    }

    @Test
    void shouldRespectTermAndKeywordFilters() {
        Course springCourse = buildCourse("2025年春季", 12, 6, null);

        when(courseMapper.findCourses(eq(1L), eq("2025年春季"), eq("Python")))
                .thenReturn(List.of(springCourse));

        List<Course> result = courseService.listCourses(1L, "2025年春季", "Python");

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getTerm()).isEqualTo("2025年春季");
    }

    private Course buildCourse(String term, Integer totalTasks, Integer completedTasks, Integer progress) {
        Course course = new Course();
        course.setId(1L);
        course.setTitle("测试课程-" + term);
        course.setTerm(term);
        course.setDescription("desc");
        course.setCoverColor("#ffffff");
        course.setTotalTasks(totalTasks);
        course.setCompletedTasks(completedTasks);
        course.setProgress(progress);
        return course;
    }
}

