package com.example.agriculture.service;

import com.example.agriculture.mapper.WeatherMapper;
import com.example.agriculture.model.User;
import com.example.agriculture.model.Weather;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WeatherService {
    @Autowired
    private WeatherMapper weatherMapper;
    public List<Weather> selectHumidityByFarmerId(int farmer_id){
        return weatherMapper.selectHumidityByFarmerId(farmer_id);
    }
    public List<Weather> selectPVisibilityByFarmerId(int product_id){
        return weatherMapper.selectPVisibilityByFarmerId(product_id);
    }
    //根据product_id获取农户id
    public int selectFarmerIdByProductId(int product_id){
        return weatherMapper.selectFarmerIdByProductId(product_id);
    }
    //根据农户id获取用户信息
    public User getFarmerInfo(int farmer_id){
        return weatherMapper.getUserInfo(farmer_id);
    }
}
