package com.example.aicongyou_backend.service;

import com.example.aicongyou_backend.dto.ChatRequest;
import com.example.aicongyou_backend.dto.ChatResponse;
import com.example.aicongyou_backend.dto.DeepSeekResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DeepSeekService {

    private final RestTemplate restTemplate;
    private final String apiUrl;
    private final String apiKey;

    public DeepSeekService(RestTemplateBuilder restTemplateBuilder,
                           @Value("${deepseek.api.url}") String apiUrl,
                           @Value("${deepseek.api.key}") String apiKey) {
        this.restTemplate = restTemplateBuilder
                .setConnectTimeout(Duration.ofSeconds(10))
                .setReadTimeout(Duration.ofSeconds(60))
                .build();
        this.apiUrl = apiUrl;
        this.apiKey = apiKey;
    }

    public ChatResponse createChatCompletion(ChatRequest request) {
        if (request == null || request.getMessages() == null || request.getMessages().isEmpty()) {
            throw new IllegalArgumentException("messages不能为空");
        }
        if (!StringUtils.hasText(apiKey)) {
            throw new IllegalStateException("DeepSeek API密钥未配置");
        }

        Map<String, Object> payload = buildPayload(request);
        HttpHeaders headers = buildHeaders();
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(payload, headers);
        try {
            ResponseEntity<DeepSeekResponse> response = restTemplate.postForEntity(apiUrl, entity, DeepSeekResponse.class);
            if (response.getStatusCode() != HttpStatus.OK || response.getBody() == null) {
                throw new IllegalStateException("DeepSeek服务返回异常");
            }
            String content = extractContent(response.getBody());
            return new ChatResponse(content, response.getBody().getModel(), response.getBody().getCreated());
        } catch (RestClientException ex) {
            throw new IllegalStateException("调用DeepSeek服务失败: " + ex.getMessage(), ex);
        }
    }

    private Map<String, Object> buildPayload(ChatRequest request) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("model", StringUtils.hasText(request.getModel()) ? request.getModel() : "deepseek-chat");
        payload.put("messages", request.getMessages());
        payload.put("temperature", request.getTemperature() != null ? request.getTemperature() : 0.7);
        payload.put("max_tokens", request.getMaxTokens() != null ? request.getMaxTokens() : 2000);
        payload.put("stream", false);
        return payload;
    }

    private HttpHeaders buildHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);
        return headers;
    }

    private String extractContent(DeepSeekResponse deepSeekResponse) {
        List<DeepSeekResponse.Choice> choices = deepSeekResponse.getChoices();
        if (choices == null || choices.isEmpty()) {
            throw new IllegalStateException("DeepSeek服务未返回任何回复");
        }
        DeepSeekResponse.Message message = choices.get(0).getMessage();
        if (message == null || !StringUtils.hasText(message.getContent())) {
            throw new IllegalStateException("DeepSeek回复内容为空");
        }
        return message.getContent();
    }
}


