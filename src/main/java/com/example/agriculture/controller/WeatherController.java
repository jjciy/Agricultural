package com.example.agriculture.controller;

import com.example.agriculture.model.User;
import com.example.agriculture.model.Weather;
import com.example.agriculture.service.WeatherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("weather")
public class WeatherController {

    @Autowired
    private WeatherService weatherService;

    @GetMapping("farmerInfo/{product_id}")
    public User getWeather(@PathVariable int product_id) {
        //根据product_id获取农户id
        int farmer_id = weatherService.selectFarmerIdByProductId(product_id);
        //根据农户id获取农户信息
        return weatherService.getFarmerInfo(farmer_id);
    }
    //获取最近十六天的空气湿度
    @GetMapping("/humidity/{product_id}")
    public List<Weather> selectHumidityByFarmerId(@PathVariable int product_id) {
        //根据product_id获取农户id
        int farmer_id = weatherService.selectFarmerIdByProductId(product_id);
        return weatherService.selectHumidityByFarmerId(farmer_id);
    }
    @GetMapping("/visibility/{product_id}")
    public List<Weather> selectVisibilityByFarmerId(@PathVariable int product_id) {
        //根据product_id获取农户id
        int farmer_id = weatherService.selectFarmerIdByProductId(product_id);
        return weatherService.selectPVisibilityByFarmerId(farmer_id);
    }


}