<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>农业互联 - 产品管理</title>
    <%--<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/css/bootstrap.min.css">--%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.min.js"></script>

    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            height: 100vh;
            background-color: #f8f9fa;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            border-bottom: none;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 添加阴影效果 */
            background: linear-gradient(135deg, #3ABD63, #28a745);
            width: 100%;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1001;
            backdrop-filter: blur(10px);
        }

        .navbar .logo img {
            width: 50px;
            height: 50px;
            margin-right: 10px;
            border-radius: 50%;
        }

        .navbar .title {
            font-size: 1.5em;
            font-weight: bold;
            color: white;
        }

        .navbar .profile-picture {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            cursor: pointer;
            position: relative;
        }

        .navbar .profile-picture img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: none;
            min-width: 160px;
            padding: 1px;
            z-index: 1002;
        }

        .dropdown-menu a {
            display: block;
            padding: 5px 10px;
            text-decoration: none;
            color: #333;
        }

        .dropdown-menu a:hover {
            background-color: #f1f1f1;
        }

        .sidebar {
            width: 100px;
            padding: 20px;
            border-right: none;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1); /* 添加阴影效果 */
            background: linear-gradient(135deg, #3abd63, #28a745);
            height: calc(100vh - 60px);
            position: fixed;
            top: 60px;
            left: 0;
            z-index: 1000;
            transition: background 0.3s;
            backdrop-filter: blur(10px);
            margin-top: 20px;
        }

        .sidebar .btn {
            width: 100%;
            margin-bottom: 10px;
            font-size: 0.8em;
            padding: 5px 0;
            border: none;
            background: #28a745;
            color: white;
            border-radius: 4px;
            transition: background 0.3s;
        }

        .sidebar .btn:hover {
            background: #3ABD63;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            margin-left: 100px;
            margin-top: 60px;
            background-color: white;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            height: calc(100vh - 80px);
            overflow-y: auto;
        }

        .button-container {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .button-container button {
            margin-left: 10px;
        }

        .table th, .table td {
            text-align: center;
        }

        .product-name-link {
            color: #ffffff;
            text-decoration: none;
        }

        .product-name-link:hover {
            text-decoration: underline;
        }

        .modal-content {
            border-radius: 8px;
            border: none;
        }

        .modal-header {
            background-color: #28a745;
            color: white;
        }

        .product-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            padding: 20px;
        }

        .product-item {
            width: 300px;
            height: 420px;
            margin: 10px;
            text-align: center;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transition: transform 0.2s;
        }

        .product-item:hover {
            transform: translateY(-5px);
        }

        .product-item img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-bottom: 1px solid #dee2e6;
            flex-shrink: 0;
        }

        .product-item h5 {
            font-size: 1em;
            font-weight: bold;
            margin: 10px 0;
            color: #333;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .product-item .buttons {
            margin-top: auto;
            display: flex;
            justify-content: center;
            gap: 10px;
            padding: 10px;
            background: #f9f9f9;
            border-top: 1px solid #dee2e6;
        }

        .product-item .buttons a,
        .product-item .buttons button {
            font-size: 0.9em;
            padding: 5px 10px;
            border-radius: 4px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        /* 表单样式优化 */
        .form-group label {
            font-weight: bold;
        }

        .form-control {
            border-radius: 4px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }

        .form-control-file {
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 5px;
        }

        /* 按钮样式优化 */
        .btn-primary {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-primary:hover {
            background-color: #3ABD63;
            border-color: #3ABD63;
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #545b62;
            border-color: #545b62;
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-success:hover {
            background-color: #3ABD63;
            border-color: #3ABD63;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }

        .btn-warning {
            background-color: #ffc107;
            border-color: #ffc107;
        }

        .btn-warning:hover {
            background-color: #e0a800;
            border-color: #d39e00;
        }
    </style>

</head>
<body>

<!-- 上导航栏 -->
<nav class="navbar">
    <div class="logo">
        <img src="program_logo/logo.png" alt="Logo">
        <span class="title">绿泽农联</span>
    </div>
    <div class="profile-picture">
        <img src="avatar/未命名.jpg" alt="用户头像" id="navProfileImage">
        <div class="dropdown-menu">
            <a href="#" data-toggle="modal" data-target="#profileModal" id="profileLink">完善信息</a>
            <a href="#" id="logoutLink">退出登录</a>
        </div>
    </div>
</nav>

<!-- 左侧边栏 -->
<div class="sidebar">
    <button id="aiButton" class="btn btn-primary">
        AI对话
    </button>
    <button id="aiRecognitionButton" class="btn btn-primary">
        AI识别
    </button>
</div>

<!-- 主内容区域 -->
<div class="main-content">
    <!-- 按钮容器 -->
    <div class="button-container">
        <!-- 添加产品按钮 -->
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#publishModal">
            创建产品
        </button>
    </div>

    <!-- 产品列表 -->
    <div class="product-list mt-5" id="productListContainer">
        <!-- 产品列表内容将通过JS动态加载 -->
    </div>
</div>

<!-- 发布产品弹窗 -->
<div class="modal fade" id="publishModal" tabindex="-1" role="dialog" aria-labelledby="publishModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="publishModalLabel">发布产品</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="publishForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="newProductName">添加新产品名称:</label>
                        <input type="text" class="form-control" id="newProductName" name="newProductName" required>
                    </div>
                    <div class="form-group">
                        <label for="productImage">上传产品图片:</label>
                        <input type="file" class="form-control-file" id="productImage" name="productImage" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="addProductButton">添加产品</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改产品名称弹窗 -->
<div class="modal fade" id="editProductModal" tabindex="-1" role="dialog" aria-labelledby="editProductModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editProductModalLabel">修改产品名称</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="editProductForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="editedProductName">新的产品名称:</label>
                        <input type="text" class="form-control" id="editedProductName" name="editedProductName">
                    </div>
                    <div class="form-group">
                        <label for="productImage">上传产品图片:</label>
                        <input type="file" class="form-control-file" id="newProductImage" name="newProductImage">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateProductButton">保存修改</button>
            </div>
        </div>
    </div>
</div>

<!-- 完善信息弹窗 -->
<div class="modal fade" id="profileModal" tabindex="-1" role="dialog" aria-labelledby="profileModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="profileModalLabel">完善个人信息</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="profileForm" enctype="multipart/form-data">
                    <div class="d-flex align-items-center mb-3">
                        <div class="mr-3">
                            <img id="profileImage" src="" alt="用户头像" class="rounded-circle"
                                 style="width: 100px; height: 100px;">
                        </div>
                        <div>
                            <button type="button" class="btn btn-primary" id="changeProfilePictureButton">修改头像
                            </button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="username">用户名:</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="password">密码:</label>
                        <input type="text" class="form-control" id="password" name="password">
                    </div>
                    <div class="form-group">
                        <label for="role">身份:</label>
                        <input type="text" class="form-control" id="role" name="role">
                    </div>
                    <div class="form-group">
                        <label for="phone">联系电话:</label>
                        <input type="text" class="form-control" id="phone" name="phone">
                    </div>
                    <div class="form-group">
                        <label for="email">电子邮箱:</label>
                        <input type="email" class="form-control" id="email" name="email">
                    </div>
                    <div class="form-group">
                        <label>产业地址:</label>
                        <div class="d-flex">
                            <select class="form-control mr-2" id="country" name="country">
                                <option value="">选择国家</option>
                                <!-- 国家选项将通过JS动态加载 -->
                            </select>
                            <select class="form-control mr-2" id="province" name="province">
                                <option value="">选择省份</option>
                                <!-- 省份选项将通过JS动态加载 -->
                            </select>
                            <select class="form-control" id="city" name="city">
                                <option value="">选择市县</option>
                                <!-- 市县选项将通过JS动态加载 -->
                            </select>
                        </div>
                    </div>
                    <input type="file" class="form-control-file d-none" id="profilePicture" name="imageurl">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveProfileButton">保存</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 获取国家、省份和市县数据的API
    const apiUrl = {
        countries: 'farmer/getCountry',
        provinces: 'farmer/getProvince',
        cities: 'farmer/getCity'
    };

    // 获取农户已发布的产品名称并展示在表格中-6
    function loadProductNames() {
        $.ajax({
            url: 'farmer/getProductNames',
            type: 'GET',
            success: function (productNames) {
                const productListContainer = $('#productListContainer');
                productListContainer.empty(); // 清空现有的列表

                if (productNames.length > 0) {
                    productNames.forEach(function (product) {
                        const productItem = $('<div class="product-item">');
                        productItem.append('<h5>' + product.name + '</h5>');
                        productItem.append('<img src="' + product.image_url + '" alt="产品图片">');
                        productItem.append('<div class="buttons">' +
                            '<a href="/productDetailsPage?productId=' + product.id + '&productName=' + encodeURIComponent(product.name) + '" class="btn btn-success btn-sm product-name-link" target="_blank">详情</a> ' +
                            '<button class="btn btn-danger btn-sm delete-product-button" data-product-id="' + product.id + '">删除</button> ' +
                            '<button class="btn btn-warning btn-sm edit-product-button" data-product-id="' + product.id + '">修改</button>' +
                            '</div>');
                        productListContainer.append(productItem);
                    });
                } else {
                    productListContainer.append('<p>暂无产品</p>');
                }
            },
            error: function () {
                alert('加载产品名称失败，请重试。');
            }
        });
    }

    // 添加新产品名称-6
    $('#addProductButton').on('click', function () {
        const newProductName = $('#newProductName').val().trim();
        const productImage = $('#productImage')[0].files[0];

        if (newProductName === '') {
            alert('请输入产品名称');
            return;
        }

        if (!productImage) {
            alert('请选择产品图片');
            return;
        }

        const formData = new FormData();
        formData.append('newProductName', newProductName);
        formData.append('productImage', productImage);

        $.ajax({
            url: 'farmer/addProductName',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                $('#newProductName').val(''); // 清空输入框
                $('#productImage').val(''); // 清空文件输入
                loadProductNames(); // 重新加载产品列表
                $('#publishModal').modal('hide'); // 关闭模态框
            },
            error: function () {
                alert('添加产品失败，请重试。');
            }
        });
    });

    // 页面加载时显示所有产品名称
    $(document).ready(function () {
        loadProductNames();

        // 绑定删除按钮的点击事件-6
        $(document).on('click', '.delete-product-button', function () {
            const productId = $(this).data('product-id');
            console.log('Product ID:', productId);

            // 确认删除
            if (confirm('确定要删除此产品吗？')) {
                $.ajax({
                    url: 'farmer/deleteProductName/' + productId,
                    type: 'POST',
                    //data: {productId: productId},
                    success: function (response) {
                        loadProductNames(); // 重新加载产品列表
                    },
                    error: function () {
                        alert('删除产品失败，检查并重试。');
                    }
                });
            }
        });

        // 绑定产品修改按钮的点击事件
        $(document).on('click', '.edit-product-button', function () {
            const productId = $(this).data('product-id');
            $('#editProductModal').modal('show'); // 显示模态框
            $('#updateProductButton').data('product-id', productId); // 存储产品ID
        });

        // 绑定产品保存修改按钮的点击事件
        $('#updateProductButton').on('click', function () {
            const productId = $(this).data('product-id');
            const editedProductName = $('#editedProductName').val().trim();
            const productImage = $('#newProductImage')[0].files[0]; // 获取上传的图片文件
            if (editedProductName === '' || editedProductName == null) {
                alert('新的产品名称不可为空');
                return;
            }

            // 创建一个FormData对象，用于封装表单数据，包括文件
            const formData = new FormData();
            formData.append('productId', productId);
            formData.append('productName', editedProductName);
            formData.append('productImage', productImage);

            $.ajax({
                url: 'farmer/updateProductName',
                type: 'POST',
                data: formData,
                processData: false, // 不处理数据
                contentType: false, // 不设置内容类型
                success: function (response) {
                    $('#editedProductName').val(''); // 清空输入框
                    loadProductNames(); // 重新加载产品列表
                    $('#editProductModal').modal('hide'); // 关闭模态框
                    // 更新页面上的图片
                    $('#productImage').attr('src', response);
                },
                error: function () {
                    alert('修改产品名称失败，检查并重试。');
                }
            });
        });

        // 绑定退出登录链接的点击事件
        $('#logoutLink').on('click', function (event) {
            event.preventDefault(); // 防止默认的链接行为
            window.location.href = '/login'; // 重定向到登录页面
        });

        // 加载国家数据
        function loadCountries() {
            $.ajax({
                url: apiUrl.countries,
                type: 'GET',
                success: function (countries) {
                    const countrySelect = $('#country');
                    countrySelect.empty().append($('<option>', {
                        value: '',
                        text: '选择国家'
                    }));
                    countries.forEach(function (country) {
                        countrySelect.append($('<option>', {
                            value: country.countryZh,
                            text: country.countryZh
                        }));
                    });
                },
                error: function () {
                    alert('加载国家数据失败，请重试。');
                }
            });
        }


        // 加载省份数据
        function loadProvinces(countryId) {
            $.ajax({
                url: apiUrl.provinces + '/' + countryId,
                type: 'GET',
                success: function (provinces) {
                    const provinceSelect = $('#province');
                    provinceSelect.empty().append($('<option>', {
                        value: '',
                        text: '选择省份'
                    }));
                    provinces.forEach(function (province) {
                        provinceSelect.append($('<option>', {
                            value: province.provinceZh,
                            text: province.provinceZh
                        }));
                    });
                },
                error: function () {
                    alert('加载省份数据失败，请重试。');
                }
            });
        }

        // 加载市县数据
        function loadCities(provinceId) {
            $.ajax({
                url: apiUrl.cities + '/' + provinceId,
                type: 'GET',
                success: function (cities) {
                    const citySelect = $('#city');
                    citySelect.empty().append($('<option>', {
                        value: '',
                        text: '选择市县'
                    }));
                    cities.forEach(function (city) {
                        citySelect.append($('<option>', {
                            value: city.cityZh,
                            text: city.cityZh
                        }));
                    });
                },
                error: function () {
                    alert('加载市县数据失败，请重试。');
                }
            });
        }

        // 绑定国家选择事件
        $('#country').on('change', function () {
            const countryId = $(this).val();
            if (countryId) {
                loadProvinces(countryId);
            } else {
                $('#province').empty().append($('<option>', {
                    value: '',
                    text: '选择省份'
                }));
                $('#city').empty().append($('<option>', {
                    value: '',
                    text: '选择市县'
                }));
            }
        });

        // 绑定省份选择事件
        $('#province').on('change', function () {
            const provinceId = $(this).val();
            if (provinceId) {
                loadCities(provinceId);
            } else {
                $('#city').empty().append($('<option>', {
                    value: '',
                    text: '选择市县'
                }));
            }
        });

        // 绑定完善信息链接的点击事件
        $('#profileLink').on('click', function (event) {
            event.preventDefault(); // 防止默认的链接行为
            loadCountries(); // 加载国家数据

            $.ajax({
                url: 'farmer/getProfile',
                type: 'GET',
                success: function (profile) {
                    // 填充信息
                    $('#username').val(profile.username);
                    $('#password').val(profile.password);
                    $('#role').val(profile.role);
                    $('#email').val(profile.email);
                    $('#phone').val(profile.phone);
                    $('#location').val(profile.location);
                    if (profile.imageurl) {
                        $('#profileImage').attr('src', profile.imageurl); // 更新头像
                        $('#navProfileImage').attr('src', profile.imageurl); // 更新导航栏中的头像
                    }

                    // 设置国家、省份和市县的初始值
                    if (profile.country) {
                        $('#country').val(profile.country);
                        loadProvinces(profile.country);
                    }
                    if (profile.province) {
                        $('#province').val(profile.province);
                        loadCities(profile.province);
                    }
                    if (profile.city) {
                        $('#city').val(profile.city);
                    }
                    $('#profileModal').modal('show'); // 显示模态框
                },
                error: function () {
                    alert('获取个人信息失败，请重试。');
                }
            });
        });


        // 绑定修改头像按钮的点击事件
        $('#changeProfilePictureButton').on('click', function () {
            $('#profilePicture').click(); // 触发文件选择框
        });

        // 监听文件选择框的变化
        $('#profilePicture').on('change', function (event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    $('#profileImage').attr('src', e.target.result); // 更新头像预览
                };
                reader.readAsDataURL(file);
            }
        });

        // 绑定用户信息保存按钮的点击事件
        $('#saveProfileButton').on('click', function () {
            const username = $('#username').val().trim();
            const password = $('#password').val().trim();
            const role = $('#role').val().trim();
            const phone = $('#phone').val().trim();
            const email = $('#email').val().trim();
            const country = $('#country').val();
            console.log(country);
            const province = $('#province').val();
            console.log(province);
            const city = $('#city').val();
            const profilePicture = $('#profilePicture')[0].files[0];

            if (username === '' || role === '') {
                alert('用户名和身份不能为空');
                return;
            }

            const formData = new FormData();
            formData.append('username', username);
            formData.append('password', password);
            formData.append('role', role);
            formData.append('phone', phone);
            formData.append('email', email);
            // 合并 location, country, province 为一个新的 location
            const newLocation = country + ',' + province + ',' + city;
            console.log(newLocation);
            formData.append('location', newLocation);
            if (profilePicture) {
                formData.append('imageurl', profilePicture);
            }

            $.ajax({
                url: 'farmer/updateProfile',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    if (response.imageurl) {
                        $('#navProfileImage').attr('src', response.imageurl); // 更新导航栏中的头像
                        $('#profileModal').modal('hide'); // 关闭模态框
                    } else if (response.imageurl === null) {
                        $('#profileModal').modal('hide'); // 关闭模态框
                    } else {
                        alert('你大爷的瞎改')
                    }

                },
                error: function () {
                    alert('个人信息保存失败，请重试。');
                }
            });
        });


        // 初始化头像
        $.ajax({
            url: 'farmer/getProfile',
            type: 'GET',
            success: function (profile) {
                // 填充信息
                $('#username').val(profile.username);
                $('#password').val(profile.password);
                $('#role').val(profile.role);
                $('#email').val(profile.email);
                $('#phone').val(profile.phone);
                $('#location').val(profile.location);
                if (profile.imageurl) {
                    $('#profileImage').attr('src', profile.imageurl); // 更新头像预览
                    $('#navProfileImage').attr('src', profile.imageurl); // 更新导航栏中的头像
                }
            },
            error: function () {
                alert('获取个人信息失败，请重试。');
            }
        });

        // 绑定鼠标悬停事件
        let dropdownTimeout;
        $('.profile-picture').hover(
            function () {
                clearTimeout(dropdownTimeout);
                $('.dropdown-menu').stop(true, true).fadeIn(200); // 快速显示
            },
            function () {
                dropdownTimeout = setTimeout(function () {
                    $('.dropdown-menu').fadeOut(500); // 消失延迟
                }, 500);
            }
        );
        $('.dropdown-menu').hover(
            function () {
                clearTimeout(dropdownTimeout);
            },
            function () {
                dropdownTimeout = setTimeout(function () {
                    $('.dropdown-menu').fadeOut(500); // 消失延迟
                }, 500);
            }
        );

        // 绑定文档的点击事件，关闭下拉菜单
        $(document).on('click', function (event) {
            if (!$(event.target).closest('.profile-picture').length) {
                $('.dropdown-menu').hide(); // 隐藏下拉菜单
            }
        });
    });

    // 绑定 AI 识别按钮的点击事件
    $("#aiRecognitionButton").click(function (event) {
        event.preventDefault(); // 防止默认的按钮行为
        window.location.href = "/imageRecognition"; // 跳转到 AI 图像识别界面
    });

    // 绑定 AI 交互按钮的点击事件
    $("#aiButton").click(function (event) {
        event.preventDefault(); // 防止默认的按钮行为
        window.location.href = "/chat";
    });
</script>

</body>
</html>
