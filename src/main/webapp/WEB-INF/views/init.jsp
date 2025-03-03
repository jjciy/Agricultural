<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>绿泽农联</title>
    <!-- 引入 jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 引入 qrcodejs 库 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: #f4f7f6;
            color: #333;
        }

        header {
            background-color: #4CAF50;
            padding: 15px;
            color: white;
            text-align: center;
        }

        .container {
            max-width: 1440px;
            margin: 20px auto;
            padding: 20px;
            display: flex;
        }

        .left-section, .right-section {
            padding: 20px;
        }

        .left-section {
            flex: 0 0 60%; /* 左侧部分占60% */
        }

        .right-section {
            flex: 0 0 40%; /* 右侧部分占40% */
        }

        nav {
            background-color: #f4f7f6;
            padding: 15px;
            display: flex;
            justify-content: flex-end;
        }

        nav a {
            text-decoration: none;
            color: #4CAF50;
            padding: 10px 15px;
            margin-left: 10px;
            border: 2px solid #4CAF50;
            border-radius: 4px;
        }

        nav a:hover {
            background-color: #4CAF50;
            color: white;
        }

        footer {
            text-align: center;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            position: fixed;
            width: 100%;
            bottom: 0;
        }

        .tabs {
            display: flex;
            margin-bottom: 20px;
        }

        .tab {
            padding: 10px 20px;
            cursor: pointer;
            border: none;
            background-color: #f4f7f6;
        }

        .tab.active {
            border-bottom: 2px solid #4CAF50;
        }

        .tab-content {
            display: none;
            padding: 20px;
            border: none;
        }

        .tab-content.active {
            display: block;
        }

        .productList {
            display: flex;
            flex-wrap: wrap; /* 允许换行 */
            gap: 20px; /* 减少间距 */
        }

        .productItem {
            flex: 0 0 calc(25% - 10px); /* 每个产品项占 33.333% 的宽度，减去间距 */
            background-color: white;
            padding: 15px; /* 减少内边距 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            text-align: center;
            min-width: 180px; /* 减少最小宽度 */
        }

        .productItem img {
            width: 100px;
            height: 100px;
        }

        /* 登录和注册部分样式 */
        .login-container, .register-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: 0 auto;
            box-sizing: border-box; /* 确保内边距和边框包含在宽度内 */
        }

        /* 调整输入框的宽度 */
        .login-form input, .register-form input, .login-form select, .register-form select {
            width: 100%; /* 输入框宽度为100% */
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            transition: border-color 0.3s;
            box-sizing: border-box; /* 确保内边距和边框包含在宽度内 */
        }

        .login-header, .register-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .login-form input, .register-form input, .login-form select, .register-form select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            transition: border-color 0.3s;
        }

        .login-form input:focus, .register-form input:focus, .login-form select:focus, .register-form select:focus {
            border-color: #4CAF50;
            outline: none;
        }

        .login-form button, .register-form button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .login-form button:hover, .register-form button:hover {
            background-color: #45a049;
        }

        .placeholder {
            text-align: center;
            margin-top: 15px;
        }

        .placeholder a {
            color: #4CAF50;
            text-decoration: none;
        }

        .placeholder a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

<header>
    <h1>绿泽农联</h1>
</header>


<div class="container">
    <!-- 左侧部分 -->
    <div class="left-section">
        <div class="productList"></div>
    </div>

    <!-- 右侧部分 -->
    <div class="right-section">
        <div class="tabs">
            <div class="tab active" data-tab="login">登录</div>
            <div class="tab" data-tab="register">注册</div>
        </div>
        <div class="tab-content active" id="loginContent">
            <div class="login-container">
                <div class="login-header">
                    <h2>绿泽农联 - 登录</h2>
                </div>
                <div id="loginMessage"></div>
                <form class="login-form" id="loginForm">
                    <input type="text" name="username" placeholder="用户名" required>
                    <input type="password" name="password" placeholder="密码" required>
                    <button type="submit">登录</button>
                </form>
                <div class="placeholder">
                    <p>还没有账号？ <a href="#" id="toRegister">注册</a></p>
                </div>
            </div>
        </div>
        <div class="tab-content" id="registerContent">
            <div class="register-container">
                <div class="register-header">
                    <h2>绿泽农联 - 注册</h2>
                </div>
                <div id="registerMessage"></div>
                <form class="register-form" id="registerForm">
                    <input type="text" name="username" placeholder="用户名" required>
                    <input type="password" name="password" placeholder="密码" required>
                    <input type="email" name="email" placeholder="邮箱" required>
                    <input type="text" name="phone" placeholder="电话" required>
                    <select name="role" required>
                        <option value="">选择角色</option>
                        <option value="farmer">农户</option>
                        <option value="consumer">用户</option>
                    </select>
                    <button type="submit">注册</button>
                </form>
                <div class="placeholder">
                    <p>已有账号? <a href="#" id="toLogin">登录</a></p>
                </div>
            </div>
        </div>
    </div>


</div>

<!-- 页脚 -->
<footer>
    <p>© 2024 绿泽农联. 版权所有.</p>
</footer>

<script>
    window.onload = function () {
        $(document).ready(function () {
            // 发送 AJAX 请求
            $.ajax({
                url: 'initInfo', // 后端接口地址
                method: 'GET', // 请求方法
                dataType: 'json', // 预期服务器返回的数据类型
                success: function (data) {
                    // 处理成功响应
                    renderProductList(data);
                },
                error: function (xhr, status, error) {
                    // 处理错误
                    console.error('请求失败:', error);
                }
            });

            // 渲染产品列表的函数
            function renderProductList(products) {
                console.log(products);
                var productListDiv = $('.productList');
                productListDiv.empty(); // 清空现有内容

                if (products.length === 0) {
                    productListDiv.append('<p>暂无产品信息</p>');
                    return;
                }

                // 创建产品项
                products.forEach(function (product) {
                    var productItem = $('<div class="productItem"></div>');
                    productItem.append('<h3>' + product.name + '</h3>');
                    productItem.append('<img src="data:image/png;base64,' + product.qrcode_url + '" alt="QR Code" style="width: 100px; height: 100px;">');

                    productListDiv.append(productItem);
                });
            }

            // 选项卡切换功能
            $('.tab').click(function () {
                var tabId = $(this).data('tab');
                $('.tab').removeClass('active');
                $(this).addClass('active');

                $('.tab-content').removeClass('active');
                $('#' + tabId + 'Content').addClass('active');
            });

            // 登录表单提交
            $("#loginForm").submit(function (event) {
                event.preventDefault(); // 防止默认的表单提交

                // 获取表单数据
                const formData = $(this).serializeArray().reduce(function (obj, item) {
                        obj[item.name] = item.value;
                        return obj;
                    }
                    , {});

                // 封装成所需的对象格式
                const loginData = {
                    username: formData.username,
                    password: formData.password
                };

                // 发送异步请求
                $.ajax({
                    url: 'login', // 修改后的后端接口地址
                    type: 'POST',
                    contentType: 'application/json', // 设置请求头
                    data: JSON.stringify(loginData), // 将数据转换为 JSON 字符串
                    success: function (response) {
                        if (response.status === "success") {
                            $("#loginMessage").html("<p style='color:green;'>登录成功！</p>");

                            // 根据用户身份跳转不同页面
                            if (response.role === "farmer") {
                                window.location.href = "/farmerPage";
                            } else if (response.role === "consumer") {
                                window.location.href = "/consumerPage";
                            } else {
                                window.location.href = "/errorPage";
                            }
                        } else {
                            $("#loginMessage").html("<p style='color:red;'>登录失败，请重试。</p>");
                        }
                    },
                    error: function () {
                        $("#loginMessage").html("<p style='color:red;'>请求失败，请稍后再试。</p>");
                    }
                });
            });


            // 注册表单提交
            $("#registerForm").submit(function (event) {
                event.preventDefault(); // 防止默认的表单提交

                // 获取表单数据
                var formData = $(this).serializeArray().reduce(function (obj, item) {
                    obj[item.name] = item.value;
                    return obj;
                }, {});

                // 封装成所需的对象格式
                var registerData = {
                    username: formData.username,
                    password: formData.password,
                    email: formData.email,
                    phone: formData.phone,
                    role: formData.role
                };

                // 发送异步请求
                $.ajax({
                    url: 'register', // 提交到的后端地址
                    type: 'POST',
                    contentType: 'application/json', // 设置请求头
                    data: JSON.stringify(registerData), // 将数据转换为 JSON 字符串
                    success: function (response) {
                        if (response.status === "success") {
                            alert("注册成功！");
                            // 切换到登录表单
                            $('.tab').removeClass('active');
                            $('.tab[data-tab="login"]').addClass('active');

                            $('.tab-content').removeClass('active');
                            $('#loginContent').addClass('active');
                        } else {
                            $("#registerMessage").html("<p style='color:red;'>注册失败，请重试。</p>");
                        }
                    },
                    error: function () {
                        $("#registerMessage").html("<p style='color:red;'>请求失败，请稍后再试。</p>");
                    }
                });
            });

            // 切换到注册表单
            $('#toRegister').click(function (event) {
                event.preventDefault();
                $('.tab').removeClass('active');
                $('.tab[data-tab="register"]').addClass('active');
                $('.tab-content').removeClass('active');
                $('#registerContent').addClass('active');
            });

            // 切换到登录表单
            $('#toLogin').click(function (event) {
                event.preventDefault();
                $('.tab').removeClass('active');
                $('.tab[data-tab="login"]').addClass('active');
                $('.tab-content').removeClass('active');
                $('#loginContent').addClass('active');
            });
        });
    };
</script>

</body>
</html>
