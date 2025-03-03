package com.example.agriculture.model;

import lombok.Data;

@Data
public
class Messag {
    private String content;

    public Messag(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
