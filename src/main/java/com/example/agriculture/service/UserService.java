package com.example.agriculture.service;

import com.example.agriculture.mapper.UserMapper;
import com.example.agriculture.model.Product;
import com.example.agriculture.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;

    public User login(User user) {
        // 从数据库查询用户
        return userMapper.findByUsernameAndPassword(user);
    }

    public boolean register(User user) {
        try {
            userMapper.insertUser(user);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public List<Product> getInitInfo(){
        return userMapper.getInitInfo();
    }
}


