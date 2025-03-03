package com.example.agriculture.model;

import lombok.Data;

@Data
public class User {

    private int id;  // 主键，自增
    private String password;  // 密码
    private String username;  // 姓名
    private String role;  // 角色类型（农民或消费者）
    private String email;  // 邮箱
    private String phone;  // 电话
    private String location;//地址
    private String imageurl;//头像路径

    public User() {
    }

    public User(int id, String password, String username, String role, String email, String phone, String location, String imageurl) {
        this.id = id;
        this.password = password;
        this.username = username;
        this.role = role;
        this.email = email;
        this.phone = phone;
        this.location = location;
        this.imageurl = imageurl;
    }
}


