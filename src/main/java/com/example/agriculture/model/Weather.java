package com.example.agriculture.model;

import lombok.Data;

import java.sql.Date;

@Data
public class Weather {
    private Integer farmer_id;
    private String cityId;
    private Date date;
    private String wea_day;
    private String wea_night;
    private String tem_day;
    private String tem_night;
    private String humidity;
    private String visibility;
    private String pressure;
    private String win;
    private String win_speed;
    private String win_meter;
    private String air;
    private String pm25;
    private String pm10;
    private String o3;
    private String no2;
    private String so2;
    private String co;
    private String sunrise;
    private String sunset;
    private String moonrise;
    private String moonset;
    private String uv;
    private String cloud_pct;
    private String precipPct;
}
