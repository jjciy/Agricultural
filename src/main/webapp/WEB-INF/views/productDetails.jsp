<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>产品详情</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.min.js"></script>

    <style>
        /* 全屏背景 */
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #9dcf9b, #4d8b3b); /* 渐变绿色背景 */
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden; /* 防止滚动条出现 */
        }

        .product-details {
            width: 80%; /* 设置宽度为屏幕的80% */
            max-width: 1200px; /* 最大宽度 */
            min-height: 80%; /* 最小高度为80% */
            background-color: #ffffff; /* 白色背景 */
            padding: 20px;
            border-radius: 5px;
            position: relative;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); /* 加阴影 */
            overflow-y: auto; /* 内容溢出时显示滚动条 */
        }

        .product-details h2 {
            margin-bottom: 20px;
            color: #2d6a4f;
        }

        .product-details p {
            margin-bottom: 10px;
            color: #333;
        }

        .video-list {
            margin-top: 20px;
        }

        .video-form {
            margin-top: 20px;
        }

        .add-video-button {
            cursor: pointer;
            width: 50px;
            height: 50px;
        }

        .qr-code-container {
            margin-top: 20px;
        }

        .complete-button {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        .complete-button:hover {
            background-color: #218838;
        }

        /* 样式调整：去掉表格的边框 */
        .table {
            width: 100%;
            margin-top: 20px;
        }

        .table th, .table td {
            text-align: center;
            padding: 10px;
        }

        .table-striped tbody tr:nth-child(odd) {
            background-color: #f9f9f9;
        }

        .table th {
            background-color: #28a745;
            color: white;
            font-weight: bold;
        }

        .table td {
            background-color: #ffffff;
            color: #333;
        }

        .table-bordered {
            border: none;
        }
    </style>
</head>
<body>

<div class="product-details">
    <h2 id="productName"></h2>

    <div class="qr-code-container" id="qrCodeContainer"
         style="position: absolute; top: 20px; right: 20px; display: none;">
        <img id="productQRCode" src="" alt="二维码" style="width: 100px; height: 100px; border-radius: 5px;">
    </div>

    <p id="productStatus"></p>
    <div class="video-list">
        <h3>视频列表:</h3>
        <table class="table table-striped table-bordered">
            <thead>
            <tr>
                <th>阶段</th>
                <th>视频链接</th>
                <th>上传日期</th>
            </tr>
            </thead>
            <tbody id="videoItems"></tbody>
        </table>
    </div>
    <div class="video-form">
        <h3>添加阶段视频</h3>
        <img src="program_logo/plus_image.png" alt="添加视频" class="add-video-button" data-toggle="modal"
             data-target="#addVideoModal">
    </div>
    <button type="button" class="btn complete-button" id="completeProductButton">完成</button>
</div>

<!-- 添加视频模态框 -->
<div class="modal fade" id="addVideoModal" tabindex="-1" role="dialog" aria-labelledby="addVideoModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addVideoModalLabel">添加阶段视频</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="addVideoForm" enctype="multipart/form-data">
                    <input type="hidden" id="productId" name="productId" value="">
                    <div class="form-group">
                        <label for="videoTitle">视频阶段:</label>
                        <input type="text" class="form-control" id="videoTitle" name="videoTitle" required>
                    </div>
                    <div class="form-group">
                        <label for="videoFile">选择视频文件:</label>
                        <input type="file" class="form-control-file" id="videoFile" name="videoFile" required>
                    </div>
                    <button type="button" class="btn btn-primary" id="submitVideoButton">添加</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 二维码模态框 -->
<div class="modal fade" id="qrCodeModal" tabindex="-1" role="dialog" aria-labelledby="qrCodeModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="qrCodeModalLabel">二维码</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <img id="qrCodeImage" src="" alt="二维码" style="max-width: 100%;">
                <!-- 新增下载按钮 -->
                <button type="button" class="btn btn-success mt-3" id="downloadQrCodeButton">下载二维码</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 获取产品ID和名称
    const urlParams = new URLSearchParams(window.location.search);
    const productId = urlParams.get('productId');
    const productName = urlParams.get('productName');

    // 设置隐藏字段的值
    if (productId && productName) {
        document.getElementById('productId').value = productId;
        document.getElementById('productName').innerText = productName;
    } else {
        alert('未提供产品信息');
    }

    // 获取产品详情-6
    function getProductDetails(productId, productName) {
        // 封装成所需的对象格式
        let productData = {
            id: productId,
            name: productName
        };
        $.ajax({
            url: 'farmer/getProductDetails',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(productData),
            success: function (data) {
                console.log(data);
                const productNameElement = $('#productName');
                const productStatusElement = $('#productStatus');
                const videoItemsElement = $('#videoItems');

                if (data.length > 0) {
                    const firstProduct = data[0];
                    productNameElement.text(firstProduct.name);
                    productStatusElement.text('状态: ' + (firstProduct.status === '0' ? '未完成' : '已完成'));

                    // 如果状态为已完成，显示二维码
                    if (firstProduct.status === '1') {
                        $('#qrCodeContainer').show();  // 显示二维码区域
                        getQRCode(productId); // 获取二维码
                    } else {
                        $('#qrCodeContainer').hide(); // 隐藏二维码区域
                    }

                    // 清空视频列表
                    videoItemsElement.empty();

                    // 添加视频项
                    let hasVideos = false;
                    data.forEach(product => {
                        if (product.uploaded_date) {
                            const date = new Date(product.uploaded_date);
                            const formattedDate = date.toISOString().split('T')[0];
                            product.uploaded_date = formattedDate;
                        }
                        if (product.video_url) { // 只有当 video_url 不为 null 时才添加视频项
                            const videoItem = $('<tr>')
                                .append(
                                    $('<td>').text(product.period),
                                    $('<td>').append(
                                        $('<a>')
                                            .attr('href', product.video_url)
                                            .attr('target', '_blank')
                                            .text('查看视频')
                                    ),
                                    $('<td>').text(product.uploaded_date)
                                );
                            videoItemsElement.append(videoItem);
                            hasVideos = true;
                        }
                    });

                    if (!hasVideos) {
                        const noVideoItem = $('<tr>')
                            .append(
                                $('<td colspan="3">').text('暂无视频')
                            );
                        videoItemsElement.append(noVideoItem);
                    }
                } else {
                    alert('没有找到相关产品信息。');
                }
            },
            error: function () {
                alert('加载产品详情失败，请重试。');
            }
        });
    }

    // 获取二维码-6
    function getQRCode(productId) {
        $.ajax({
            url: 'farmer/getProductQRCode/' + productId, // 后端获取二维码的接口
            type: 'GET',
            contentType: 'application/json',
            // data: productId,
            success: function (response) {
                if (response) {
                    const qrCodeImage = $('#productQRCode');
                    qrCodeImage.attr('src', 'data:image/png;base64,' + response); // 设置二维码图片
                    $('#qrCodeContainer').show(); // 显示二维码容器
                } else {
                    alert('获取二维码失败');
                }
            },
            error: function () {
                alert('加载二维码失败，请重试。');
            }
        });
    }


    // 添加阶段视频-6
    $('#submitVideoButton').on('click', function () {
        const formData = new FormData($('#addVideoForm')[0]);
        formData.append('productId', productId);

        $.ajax({
            url: 'farmer/addProductVideo',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                alert('视频添加成功！');
                $('#addVideoForm')[0].reset(); // 清空表单
                $('#addVideoModal').modal('hide'); // 关闭模态框
                location.reload(); // 刷新页面
            },
            error: function () {
                alert('添加视频失败，请重试。');
            }
        });
    });

    // 完成产品-6
    $('#completeProductButton').on('click', function () {
        $.ajax({
            url: 'farmer/completeProduct/' + productId,
            type: 'POST',
            // data: {productId: productId},
            success: function (response) {
                alert('产品状态更新成功！');
                const qrCodeImage = document.getElementById('qrCodeImage');
                qrCodeImage.src = 'data:image/png;base64,' + response.qrCodeBase64;
                $('#qrCodeModal').modal('show'); // 显示二维码模态框
                getQRCode(productId)
            },
            error: function () {
                alert('更新产品状态失败，请重试。');
            }
        });
    });

    // 下载二维码图片
    $('#downloadQrCodeButton').on('click', function () {
        const qrCodeImage = document.getElementById('qrCodeImage');
        const qrCodeDataUrl = qrCodeImage.src;

        // 创建一个临时的下载链接
        const link = document.createElement('a');
        link.href = qrCodeDataUrl; // 设置下载链接为二维码图片的Data URL
        link.download = 'product_qr_code.png'; // 设置下载文件名
        link.click(); // 模拟点击下载链接
    });

    // 页面加载时获取产品详情
    $(document).ready(function () {
        if (productId && productName) {
            getProductDetails(productId, productName);
        } else {
            alert('未提供完整的产品信息');
        }
    });
</script>

</body>
</html>
