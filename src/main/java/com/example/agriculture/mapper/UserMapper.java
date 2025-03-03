package com.example.agriculture.mapper;

import com.example.agriculture.model.Product;
import com.example.agriculture.model.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserMapper {

//    登陆时查询
    @Select("SELECT * FROM users WHERE username = #{username} AND password = #{password}")
    User findByUsernameAndPassword(User user);

//    插入用户信息
    @Insert("INSERT INTO users (username, password, email, phone, role) VALUES (#{username}, #{password}, #{email}, #{phone}, #{role})")
    void insertUser(User user);

    @Select("SELECT name, qrcode_url FROM products WHERE status = 1 LIMIT 9")
    List<Product> getInitInfo();
}

