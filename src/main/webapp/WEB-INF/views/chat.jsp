<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI交互</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
            margin: 0;
        }
        #chat-container {
            width: 80%;
            max-width: 800px;
            border: 1px solid #ccc;
            border-radius: 8px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 80%;
        }
        #conversation {
            flex: 1;
            padding: 10px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }
        .messag {
            margin: 5px 0;
            padding: 10px;
            border-radius: 5px;
            max-width: 70%;
        }
        .ai-messag {
            background-color: #e0f7fa;
            align-self: flex-start;
        }
        .user-messag {
            background-color: #fff176;
            align-self: flex-end;
        }
        #input-container {
            display: flex;
            border-top: 1px solid #ccc;
        }
        #user-input {
            flex: 1;
            padding: 10px;
            border: none;
            outline: none;
        }
        #voice-btn {
            padding: 10px 20px;
            border: none;
            background-color: #4caf50;
            color: white;
            cursor: pointer;
        }
        #voice-btn:hover {
            background-color: #388e3c;
        }
    </style>
</head>
<body>
<div id="chat-container">
    <div id="conversation"></div>
    <div id="input-container">
        <input type="text" id="user-input" placeholder="输入消息...">
        <button id="voice-btn">发送</button>
    </div>
</div>

<script>
    let currentAiMessageDiv = null;

    document.getElementById('voice-btn').addEventListener('click', function() {
        const userInput = document.getElementById('user-input').value;
        if (userInput.trim() === '') return;

        // 显示用户消息
        const conversation = document.getElementById('conversation');
        const userMessageDiv = document.createElement('div');
        userMessageDiv.className = 'messag user-messag';
        userMessageDiv.textContent = userInput;
        conversation.appendChild(userMessageDiv);

        // 清空输入框
        document.getElementById('user-input').value = '';

        // 发送消息到后端
        fetch('/api/send-data', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ userInput: userInput })
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                // 不需要在这里处理响应，因为 AI 响应会通过 EventSource 接收
            })
            .catch(error => console.error('Error sending user message:', error));

        // 创建一个新的 div 来存储 AI 回复
        currentAiMessageDiv = document.createElement('div');
        currentAiMessageDiv.className = 'messag ai-messag';
        conversation.appendChild(currentAiMessageDiv);
    });

    // 使用 EventSource 接收 AI 响应
    const eventSource = new EventSource('/api/receive-response');

    eventSource.onmessage = function(event) {
        try {
            const data = JSON.parse(event.data);

            // 获取 AI 回复内容并进行处理
            let aiResponse = data.messag.content;

            let replaceRegex = /(\n\r|\r\n|\r|\\n|\\n)/g;
            let newStr = aiResponse.replace(replaceRegex, '<br/>');

            // 将处理后的内容追加到当前的 aiMessageDiv
            if (currentAiMessageDiv) {
                currentAiMessageDiv.innerHTML += newStr;
            }

            // 滚动到底部
            const conversation = document.getElementById('conversation');
            conversation.scrollTop = conversation.scrollHeight;

        } catch (error) {
            console.error('Error parsing event data:', error);
        }
    };

    eventSource.onerror = function(err) {
        console.error('EventSource failed:', err);
        eventSource.close();
    };
</script>
</body>
</html>
