package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.entity.test;
import com.example.aicongyou_backend.mapper.testmapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TestService {
    @Autowired
    private testmapper testmapper;

    public String Get(){
        return testmapper.GetString();
    }
}
