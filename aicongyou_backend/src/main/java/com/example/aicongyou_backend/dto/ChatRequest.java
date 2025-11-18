package com.example.aicongyou_backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class ChatRequest {
    private List<ChatMessage> messages;
    private String model;
    private Double temperature;

    @JsonProperty("max_tokens")
    private Integer maxTokens;

    public List<ChatMessage> getMessages() {
        return messages;
    }

    public void setMessages(List<ChatMessage> messages) {
        this.messages = messages;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
    }

    public Integer getMaxTokens() {
        return maxTokens;
    }

    public void setMaxTokens(Integer maxTokens) {
        this.maxTokens = maxTokens;
    }
}


