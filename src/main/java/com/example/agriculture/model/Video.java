package com.example.agriculture.model;

import lombok.Data;

import java.util.Date;
@Data
public class Video {
    private int id;

    private int product_id;

    private String video_url;
    private String period;
    private Date uploaded_date;

    public Video() {
    }

    public Video(int id, int product_id, String video_url, String period, Date uploaded_date) {
        this.id = id;
        this.product_id = product_id;
        this.video_url = video_url;
        this.period = period;
        this.uploaded_date = uploaded_date;
    }
}
