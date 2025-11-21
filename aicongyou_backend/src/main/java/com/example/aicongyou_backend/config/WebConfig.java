package com.example.aicongyou_backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // 这里只到 uploads 这一层
    @Value("${submission.upload-dir:uploads}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path uploadPath = Paths.get(System.getProperty("user.dir"))
                .resolve("uploads"); // 注意这里只到 uploads

        String location = uploadPath.toUri().toString();
        if (!location.endsWith("/")) {
            location = location + "/";
        }

        System.out.println("Static resource location: " + location);

        Path file = Paths.get("D:/kaifa/wechat-project/aicongyou/aicongyou_backend/uploads/team-submissions/0e902f2d-72be-4f6f-8d82-4b4a1db44d9a.docx");
        System.out.println("File exists: " + Files.exists(file));


        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(location);
    }


    private Path resolveUploadPath() {
        Path configuredPath = Paths.get(uploadDir);
        if (configuredPath.isAbsolute()) {
            return configuredPath;
        }
        return Paths.get(System.getProperty("user.dir")).resolve(configuredPath);
    }
}

