package com.example.agriculture.model;

import lombok.Data;

import java.util.Date;
@Data
public class ProductAndVideo {
    private String name;
    private int farmer_id;
    private int product_id;
    private String video_url;
    private Date uploaded_date;
    private String status;
    private String period;

    public ProductAndVideo(String name, int farmer_id, int product_id, String video_url, Date uploaded_date, String status, String period) {
        this.name = name;
        this.farmer_id = farmer_id;
        this.product_id = product_id;
        this.video_url = video_url;
        this.uploaded_date = uploaded_date;
        this.status = status;
        this.period = period;
    }

    public ProductAndVideo() {
    }
}
