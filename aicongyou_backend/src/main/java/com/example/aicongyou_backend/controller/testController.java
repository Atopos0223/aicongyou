package com.example.aicongyou_backend.controller;

import com.example.aicongyou_backend.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class testController {
    @Autowired
    private TestService testService;

	@GetMapping("/test")
    public String Get(){
        return testService.Get();
    }

}
