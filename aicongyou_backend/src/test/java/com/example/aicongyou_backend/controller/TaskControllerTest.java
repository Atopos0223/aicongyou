package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.entity.Task;
import com.example.aicongyou_backend.service.TaskService;
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
import java.util.Map;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class TaskControllerTest {

    @Mock
    private TaskService taskService;

    @InjectMocks
    private TaskController taskController;

    private MockMvc mockMvc;

    @BeforeEach
    void setup() {
        mockMvc = MockMvcBuilders.standaloneSetup(taskController).build();
    }

    @Test
    @DisplayName("主界面任务列表接口返回学生任务状态")
    void shouldReturnTaskListForStudent() throws Exception {
        when(taskService.getTasksWithStudentStatus(1L))
                .thenReturn(List.of(Map.of("id", 1, "name", "系统设计", "student_status", 1)));

        mockMvc.perform(get("/api/task/list")
                        .param("studentId", "1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data[0].name").value("系统设计"));

        verify(taskService).getTasksWithStudentStatus(1L);
    }

    @Test
    @DisplayName("任务面板接口返回激活任务")
    void shouldReturnActiveTasks() throws Exception {
        Task task = new Task();
        task.setId(2L);
        task.setName("AI模型训练");
        when(taskService.getActiveTasks()).thenReturn(List.of(task));

        mockMvc.perform(get("/api/task/active"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data[0].name").value("AI模型训练"));

        verify(taskService).getActiveTasks();
    }
}

