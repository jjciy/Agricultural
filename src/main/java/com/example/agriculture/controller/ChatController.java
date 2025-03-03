package com.example.agriculture.controller;

import com.alibaba.dashscope.aigc.generation.Generation;
import com.alibaba.dashscope.aigc.generation.GenerationParam;
import com.alibaba.dashscope.aigc.generation.GenerationResult;
import com.alibaba.dashscope.common.Message;
import com.alibaba.dashscope.common.Role;
import com.alibaba.dashscope.exception.ApiException;
import com.alibaba.dashscope.exception.InputRequiredException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.alibaba.dashscope.utils.JsonUtils;
import com.example.agriculture.model.Messag;
import com.example.agriculture.model.MessageResponse;
import io.reactivex.Flowable;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/api")
public class ChatController {

    private static final ExecutorService executor = Executors.newCachedThreadPool();
    private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();

    @PostMapping("/send-data")
    public SseEmitter sendData(@RequestBody String userInput) {
        SseEmitter emitter = new SseEmitter(Long.MAX_VALUE);
        String emitterId = UUID.randomUUID().toString();
        emitters.put(emitterId, emitter);

        executor.execute(() -> {
            try {
                Generation gen = new Generation();
                Message userMsg = Message.builder().role(Role.USER.getValue()).content(userInput).build();
                System.out.println("userMsg: " + userMsg);
                GenerationParam param = GenerationParam.builder()
                        .apiKey("sk-06cd4d770e7e466599c45d2be0f7712b")
                        .model("qwen-plus")
                        .messages(Arrays.asList(userMsg))
                        .resultFormat(GenerationParam.ResultFormat.MESSAGE)
                        .incrementalOutput(true)
                        .build();
                Flowable<GenerationResult> result = gen.streamCall(param);
                result.blockingForEach(message -> {
                    try {
                        // 将 message 转换为 JSON 字符串
                        String messageStr = JsonUtils.toJson(message);
                        System.out.println("messageStr: " + messageStr); // 添加日志记录
                        // 使用正则表达式提取 content 内容
                        Pattern pattern = Pattern.compile("\"content\":\"([^\"]+)\"");
                        Matcher matcher = pattern.matcher(messageStr);
                        if (matcher.find()) {
                            String content = matcher.group(1);
                            MessageResponse response = new MessageResponse(new Messag(content));
                            String responseData = JsonUtils.toJson(response);
                            System.out.println("responseData: " + responseData); // 添加日志记录
                            emitter.send(responseData);
                            sendToAllEmitters(responseData);
                            System.out.println(content);
                        }
                    } catch (IOException e) {
                        System.out.println("IOException: " + e.getMessage()); // 添加日志记录
                        emitter.completeWithError(e);
                        emitters.remove(emitterId);
                    }
                });
                emitter.complete();
                emitters.remove(emitterId);
            } catch (ApiException | NoApiKeyException | InputRequiredException e) {
                try {
                    MessageResponse errorResponse = new MessageResponse(new Messag(e.getMessage()));
                    String errorMessage = JsonUtils.toJson(errorResponse);
                    System.out.println("errorMessage: " + errorMessage); // 添加日志记录
                    emitter.send(errorMessage);
                    sendToAllEmitters(errorMessage);
                } catch (IOException ex) {
                    System.out.println("IOException in error handling: " + ex.getMessage()); // 添加日志记录
                    emitter.completeWithError(ex);
                    emitters.remove(emitterId);
                } finally {
                    emitter.complete();
                    emitters.remove(emitterId);
                }
            }
        });

        return emitter;
    }

    @GetMapping("/receive-response")
    public SseEmitter receiveResponse() {
        SseEmitter emitter = new SseEmitter(Long.MAX_VALUE);
        String emitterId = UUID.randomUUID().toString();
        emitters.put(emitterId, emitter);

        emitter.onCompletion(() -> emitters.remove(emitterId));
        emitter.onTimeout(() -> emitters.remove(emitterId));

        return emitter;
    }

    private void sendToAllEmitters(String data) {
        for (Map.Entry<String, SseEmitter> entry : emitters.entrySet()) {
            SseEmitter emitter = entry.getValue();
            try {
                emitter.send(data);
            } catch (IOException e) {
                emitter.completeWithError(e);
                emitters.remove(entry.getKey());
            }
        }
    }
}
