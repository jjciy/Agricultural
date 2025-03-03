package com.example.agriculture.controller;

import com.example.agriculture.model.Product;
import com.example.agriculture.model.User;
import com.example.agriculture.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class LoginController {
    
    @Autowired
    private UserService userService;

    @PostMapping("login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody User user, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User users = userService.login(user);

        if (users != null) {
            if (users.getRole().equals("farmer")) {
                session.setAttribute("farmerId", users.getId());
            }
            response.put("status", "success");
            response.put("role", users.getRole());
        } else {
            response.put("status", "error");
            response.put("message", "用户名或密码错误");
        }
        return ResponseEntity.ok(response); // 确保返回的是 JSON 响应
    }

    @PostMapping("register")
    public ResponseEntity<Map<String, Object>> registerUser(@RequestBody User user) {
        Map<String, Object> response = new HashMap<>();
        boolean isRegistered = userService.register(user);
        if (isRegistered) {
            response.put("status", "success");
        } else {
            response.put("status", "error");
            response.put("message", "注册失败，请重试");
        }
        return ResponseEntity.ok(response);
    }

    //首页信息的获取
    @GetMapping("initInfo")
    public ResponseEntity<List<Product>> getInitInfo() {
        List<Product> products = userService.getInitInfo();
        return ResponseEntity.ok(products);
    }
}


