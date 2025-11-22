package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.ExcellentWorkItem;
import com.example.aicongyou_backend.mapper.ExcellentWorkMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ExcellentWorkService {

    private final ExcellentWorkMapper excellentWorkMapper;

    public ExcellentWorkService(ExcellentWorkMapper excellentWorkMapper) {
        this.excellentWorkMapper = excellentWorkMapper;
    }

    public List<ExcellentWorkItem> listByTask(Integer taskId, Integer courseId) {
        return excellentWorkMapper.listExcellentWorks(taskId, courseId);
    }
}


