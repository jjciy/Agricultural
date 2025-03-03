package com.example.agriculture.mapper;

import com.example.agriculture.model.User;
import com.example.agriculture.model.Weather;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface WeatherMapper {
    //查询空气湿度
    @Select("SELECT date,humidity FROM weather WHERE farmer_id = #{farmer_id}")
    List<Weather> selectHumidityByFarmerId(int farmer_id);

    //查询云量
    @Select("SELECT date,cloud_pct FROM weather WHERE farmer_id = #{farmer_id}")
    List<Weather> selectPVisibilityByFarmerId(int farmer_id);

    //根据product_id获取农户id
    @Select("SELECT farmer_id FROM products WHERE id = #{product_id}")
    int selectFarmerIdByProductId(int product_id);

    //在二维码界面根据农户id获取用户信息
    @Select("SELECT * FROM users WHERE id = #{farmer_id}")
    User getUserInfo(int farmerId);
}
