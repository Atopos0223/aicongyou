package com.example.aicongyou_backend.dto;

public class ChatResponse {
    private String content;
    private String model;
    private long created;

    public ChatResponse() {
    }

    public ChatResponse(String content, String model, long created) {
        this.content = content;
        this.model = model;
        this.created = created;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public long getCreated() {
        return created;
    }

    public void setCreated(long created) {
        this.created = created;
    }
}


