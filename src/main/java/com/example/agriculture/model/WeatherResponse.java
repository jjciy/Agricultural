package com.example.agriculture.model;

import lombok.Data;

import java.util.List;
@Data
public class WeatherResponse {
    private int nums;
    private String cityid;
    private int days;
    private String date_start;
    private String date_end;
    private List<Weather> list;
}

