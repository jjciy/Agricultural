package com.example.agriculture.model;

import lombok.Data;

@Data
public class Product {
    private int id;
    private String name;
    private int farmer_id;
    private String status;
    private String image_url;
    private String qrcode_url;

    public Product() {
    }

    public Product(String name, int farmer_id, String status, String image_url) {
        this.name = name;
        this.farmer_id = farmer_id;
        this.status = status;
        this.image_url = image_url;
    }

    public Product(int id, String name, int farmer_id, String status, String image_url) {
        this.id = id;
        this.name = name;
        this.farmer_id = farmer_id;
        this.status = status;
        this.image_url = image_url;
    }

}
