<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>缺陷分析</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }

        .section-header {
            font-size: 24px;
            margin-bottom: 15px;
            color: #4CAF50;
        }

        .form-section {
            background-color: white;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input[type="file"] {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        .form-group button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .form-group button:hover {
            background-color: #45a049;
        }

        pre {
            background-color: #f9f9f9;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>

<header>
    <h1>缺陷分析</h1>
</header>

<div class="container">

    <div class="form-section">
        <h2 class="section-header">上传图片</h2>
        <form id="uploadForm" enctype="multipart/form-data">
            <div class="form-group">
                <label for="file">选择图片:</label>
                <input type="file" name="file" id="file" accept="image/*" required />
            </div>
            <div class="form-group">
                <button type="submit">分析</button>
            </div>
        </form>
    </div>

    <div class="form-section">
        <h2 class="section-header">分析结果</h2>
        <pre id="result"></pre>
    </div>

</div>

<script>
    $(document).ready(function () {
        $('#uploadForm').on('submit', function (e) {
            e.preventDefault(); // 防止表单默认提交

            const formData = new FormData($(this)[0]);
            $.ajax({
                url: '/uploadToAiImageRecognition',  // 确保 URL 与控制器映射路径一致
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function (data) {
                    console.log(data)
                    $('#result').text(JSON.stringify(data, null, 2)); // 显示返回的分析结果
                },
                error: function (xhr, status, error) {
                    const errorMessage = xhr.responseJSON ? xhr.responseJSON.error : error;
                    $('#result').text('上传失败: ' + errorMessage); // 显示错误信息
                }
            });
        });
    });
</script>

</body>
</html>
