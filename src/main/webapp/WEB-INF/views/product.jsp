<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>产品详情</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: linear-gradient(to right, #9dcf9b, #f4f7f6); /* 与登录页面背景一致 */
        }

        h1 {
            color: #2d6a4f; /* 深绿色 */
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px; /* 缩小标题字体 */
        }

        .productInfo-container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(234, 229, 229, 0.23);
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            display: none; /* 初始隐藏 */
        }

        .UserInfo-container {
            display: flex;
            max-width: 900px;
            background: rgba(234, 229, 229, 0.23);
            margin: 0 auto;
            align-items: center;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        .UserInfo-container p {
            margin: 0;
            font-size: 14px;
            flex: 1;
            text-align: center;
        }

        .error-message {
            color: red;
            text-align: center;
            display: none;
        }

        .chart-container {
            margin: 0 auto; /* 水平居中 */
            max-width: 900px;
            text-align: center;
            background: rgba(234, 229, 229, 0.23);
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        canvas {
            max-width: 100%;
            height: 400px;
            margin: 0 auto;
            display: block;
        }

        #humidityChart, #LightRecordChart {
            max-width: 100%; /* 自适应宽度 */
        }

        /* TimeLine样式 */
        .timeline {
            list-style: none;
            padding: 0;
            margin: 0;
            position: relative;
        }

        /* 分割线 */
        .timeline:before {
            content: '';
            position: absolute;
            left: 50%;
            top: 0;
            bottom: 0;
            width: 2px;
            background: rgba(101, 168, 107, 0.32);
        }

        .timeline-item {
            position: relative;
            padding: 10px 0; /* 减少上下间距 */
            width: 50%;
            font-size: 14px; /* 缩小字体 */
        }

        .timeline-item:nth-child(even) {
            left: 50%;
        }

        .timeline-item:nth-child(odd) {
            left: 0;
        }

        .timeline-item:before {
            content: '';
            position: absolute;
            top: 10px; /* 缩小标记的位置 */
            left: -6px;
            height: 12px;
            width: 12px;
            border-radius: 50%;
            background: #28a745;
            border: 2px solid #fff;
        }

        .timeline-item:nth-child(even):before {
            left: -6px;
        }

        .timeline-item:nth-child(odd):before {
            left: calc(100% - 6px);
        }

        /* 阶段项目样式 */
        .timeline-item .timeline-content {
            padding: 5px 15px; /* 减少 padding */
            border-radius: 8px;
            background: rgba(213, 195, 195, 0.16);
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
            width: 95%;
        }

        .timeline-item:nth-child(even) .timeline-content {
            margin-left: 20px;
        }

        .timeline-item:nth-child(odd) .timeline-content {
            margin-right: 20px;
        }

        /* 调整文本样式 */
        .timeline-item .timeline-content h5 {
            font-size: 16px; /* 缩小标题字体 */
            margin-bottom: 5px; /* 减少标题与内容的间距 */
        }

        .timeline-item .timeline-content p {
            font-size: 14px; /* 缩小文本字体 */
            margin-bottom: 5px;
        }

        .timeline-item .timeline-content a {
            font-size: 14px;
            color: #007bff;
            text-decoration: none;
        }

        .timeline-item .timeline-content a:hover {
            text-decoration: underline;
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            body {
                font-size: 14px; /* 减小整体字体大小 */
            }

            h1 {
                font-size: 20px; /* 减小标题字体 */
            }

            .productInfo-container {
                max-width: 100%;
                padding: 15px;
            }

            .UserInfo-container {
                flex-direction: column;
                align-items: flex-start;
            }

            .UserInfo-container p {
                margin-bottom: 10px;
                text-align: left;
            }

            .chart-container {
                margin: 15px 0;
            }

            canvas {
                height: 300px;
            }

            .timeline {
                padding: 0 10px;
            }

            .timeline-item {
                width: 100%;
                left: 0;
                padding: 5px 0;
            }

            .timeline-item:before {
                left: 15px;
            }

            .timeline-item:nth-child(even):before,
            .timeline-item:nth-child(odd):before {
                left: 15px;
            }

            .timeline-item .timeline-content {
                margin: 0;
                width: 100%;
                padding: 10px;
            }

            .timeline-item .timeline-content h5 {
                font-size: 16px;
            }

            .timeline-item .timeline-content p {
                font-size: 14px;
            }

            .timeline-item .timeline-content video {
                width: 100%;
                height: auto;
            }
        }
    </style>
</head>
<body>

<h1>产品详情</h1>

<!-- 用户信息显示区域 -->
<div id="userInfo" class="UserInfo-container" style="display: none;">
    <p><strong>姓名:</strong> <span id="username"></span></p>
    <p><strong>电话:</strong> <span id="phone"></span></p>
    <p><strong>位置:</strong> <span id="location"></span></p>
</div>

<!-- 错误提示 -->
<div id="error" class="error-message"></div>

<!-- 产品详情容器 -->
<div class="productInfo-container" id="info-container">
    <ul class="timeline" id="productDetailsTimeline">
        <!-- 产品详情数据将填充到这里 -->
    </ul>
</div>

<!-- 湿度图表 -->
<div class="chart-container">
    <canvas id="humidityChart"></canvas>
</div>

<!-- 光照强度图表 -->
<div class="chart-container">
    <canvas id="LightRecordChart"></canvas>
</div>

<input type="hidden" id="productId" name="productId">

<script>
    // 获取URL中的产品ID参数
    const urlParams = new URLSearchParams(window.location.search);
    const product_id = urlParams.get('product_id');
    console.log(product_id);

    if (product_id) {
        document.getElementById('productId').value = product_id;
    } else {
        alert('未提供产品信息');
    }

    // 获取产品详情并显示为时间轴
    function fetchProductDetails(product_id) {
        $.ajax({
            url: 'farmer/getProduct/' + product_id, // 确保URL路径正确
            method: 'POST',
            success: function (response) {
                console.log('getProduct返回的数据：', response);

                if (Array.isArray(response) && response.length > 0) {
                    const productDetailsTimeline = $('#productDetailsTimeline');
                    productDetailsTimeline.empty();  // 清空时间轴内容

                    response.forEach((product, index) => {
                        const item = $('<li>').addClass('timeline-item');
                        item.append(
                            $('<div>').addClass('timeline-content').append(
                                $('<h5>').text(product.name),
                                $('<p>').text('阶段: ' + product.period),
                                $('<video controls>')
                                    .attr('src', product.video_url)
                                    .attr('width', '100%')
                                    .attr('height', '200px'),
                                $('<p>').text('上传日期: ' + product.uploaded_date)
                            )
                        );
                        productDetailsTimeline.append(item);
                    });

                    $('#info-container').show(); // 显示产品详情
                } else {
                    $('#error').text('没有找到产品详情信息').show();
                }
            },
            error: function (xhr, status, error) {
                console.error('请求失败: ', error);
                $('#error').text('请求失败: ' + error).show();
            }
        });
    }

    // 获取湿度数据并绘制湿度图表
    function fetchAndDrawChart(product_id) {
        $.ajax({
            url: "weather/humidity/" + product_id,
            method: "GET",
            dataType: "json",
            success: function (data) {
                console.log('humidity返回的数据：', data);
                if (!data || !Array.isArray(data) || data.length === 0) {
                    console.error('No data received or data is not an array.');
                    alert('未接收到有效数据。');
                    return;
                }

                const labels = data.map(item => {
                    const date = new Date(item.date);
                    return date.toLocaleString([], {year: 'numeric', month: '2-digit', day: '2-digit', hour12: false});
                });

                const humidityValues = data.map(item => parseFloat(item.humidity));

                const ctx = document.getElementById('humidityChart').getContext('2d');
                if (!ctx) {
                    console.error('Canvas element not found.');
                    alert('未找到 canvas 元素。');
                    return;
                }

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '空气湿度 (%)',
                            data: humidityValues,
                            borderColor: 'rgba(75, 192, 192, 1)',
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true, // 开启响应式
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                title: {display: true, text: '时间'},
                                ticks: {autoSkip: false}
                            },
                            y: {
                                title: {display: true, text: '空气湿度 (%)'},
                                beginAtZero: true
                            }
                        }
                    }
                });
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error('Error fetching data:', textStatus, errorThrown);
                alert('无法获取数据，请检查网络连接或稍后再试');
            }
        });
    }

    // 获取光照强度数据并绘制光照强度图表
    function lightDrawChart(product_id) {
        $.ajax({
            url: "weather/visibility/" + product_id,
            method: "GET",
            dataType: "json",
            success: function (data) {
                console.log('visibility返回的数据：', data); // 添加调试信息
                if (!data || !Array.isArray(data) || data.length === 0) {
                    console.error('No data received or data is not an array.');
                    alert('未接收到有效数据。');
                    return;
                }

                const labels = data.map(item => {
                    const date = new Date(item.date);
                    return date.toLocaleString([], {year: 'numeric', month: '2-digit', day: '2-digit', hour12: false});
                });

                const lightValues = data.map(item => parseFloat(item.cloud_pct));

                const ctx = document.getElementById('LightRecordChart').getContext('2d');
                if (!ctx) {
                    console.error('Canvas element not found.');
                    alert('未找到 canvas 元素。');
                    return;
                }

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '云量 (%)',
                            data: lightValues,
                            borderColor: 'rgba(255, 159, 64, 1)',
                            backgroundColor: 'rgba(255, 159, 64, 0.2)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                title: {display: true, text: '时间'},
                                ticks: {autoSkip: false}
                            },
                            y: {
                                title: {display: true, text: '云量 (%)'},
                                beginAtZero: true
                            }
                        }
                    }
                });
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error('Error fetching data:', textStatus, errorThrown);
                alert('无法获取数据，请检查网络连接或后端服务。');
            }
        });
    }

    // 根据产品id获取农户信息
    function getFarmerInfo(product_id) {
        $.ajax({
            url: "weather/farmerInfo/" + product_id,
            method: "GET",
            dataType: "json",
            success: function (data) {
                console.log('农户信息：', data);
                if (data && data.username && data.phone && data.location) {
                    $('#username').text(data.username);
                    $('#phone').text(data.phone);
                    $('#location').text(data.location);
                    console.log('显示用户信息');
                    $('#userInfo').show();
                } else {
                    console.log('用户信息不完整');
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error('Error fetching data:', textStatus, errorThrown);
                alert('无法获取数据，请检查网络连接或后端服务。');
            }
        });
    }

    // 页面加载时获取数据并绘制图表
    window.onload = () => {
        const product_id = document.getElementById('productId').value;
        if (product_id) {
            getFarmerInfo(product_id);
            fetchProductDetails(product_id);
            fetchAndDrawChart(product_id);
            lightDrawChart(product_id);
        } else {
            console.error('Product ID is missing or invalid.');
            alert('产品ID缺失或无效。');
        }
    };
</script>

<!-- 确保 Chart.js 库在页面底部加载 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js" defer></script>

</body>
</html>
