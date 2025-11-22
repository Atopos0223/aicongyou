package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.entity.Course;
import com.example.aicongyou_backend.service.CourseService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.List;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class CourseControllerTest {

    @Mock
    private CourseService courseService;

    @InjectMocks
    private CourseController courseController;

    private MockMvc mockMvc;

    @BeforeEach
    void setup() {
        mockMvc = MockMvcBuilders.standaloneSetup(courseController).build();
    }

    @Test
    @DisplayName("按学期筛选课程时返回过滤后的列表")
    void shouldFilterCoursesByTerm() throws Exception {
        Course course = new Course();
        course.setId(1L);
        course.setTitle("大数据分析基础");
        course.setTerm("2025年春季");
        course.setDescription("desc");
        course.setCoverColor("#ffffff");
        course.setTotalTasks(10);
        course.setCompletedTasks(5);
        course.setProgress(50);
        course.setCompletionRate(50);

        when(courseService.listCourses(1L, "2025年春季", "数据"))
                .thenReturn(List.of(course));

        mockMvc.perform(get("/api/course/list")
                        .param("term", "2025年春季")
                        .param("keyword", "数据")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data[0].title").value("大数据分析基础"))
                .andExpect(jsonPath("$.data[0].term").value("2025年春季"));

        verify(courseService).listCourses(1L, "2025年春季", "数据");
    }

    @Test
    @DisplayName("未提供学期参数时默认按全部课程返回")
    void shouldReturnAllCoursesWhenNoTermProvided() throws Exception {
        when(courseService.listCourses(1L, null, null)).thenReturn(List.of());

        mockMvc.perform(get("/api/course/list"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data").isArray());

        verify(courseService).listCourses(1L, null, null);
    }
}

