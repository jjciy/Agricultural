package com.example.agriculture.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    //为了使异步通信正确跳转
    @GetMapping("/init")
    public String InitPage() {
        return "init"; // 显示登录页面
    }
    @GetMapping("/consumerPage")
    public String consumerPage() {
        return "consumer";
    }

    @GetMapping("/farmerPage")
    public String farmerPage() {
        return "farmer";
    }

    @GetMapping("/errorPage")
    public String errorPage() {
        return "error";
    }

    @GetMapping("/registerPage")
    public String registerPage() {
        return "register";
    }

    @GetMapping("/loginPage")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/productDetailsPage")
    public String productDetailsPage() {
        return "productDetails";
    }

    @GetMapping("/productPage")
    public String productPage() {
        return "product";
    }

    @GetMapping("/humidityChartPage")
    public String humidityChartPage() {
        return "humidityChart";
    }

    @GetMapping("/imageRecognition")
    public String aiPage() {
        return "imageRecognition";
    }

    @GetMapping("/chat")
    public String chatPage() {
        return "chat";
    }
}
