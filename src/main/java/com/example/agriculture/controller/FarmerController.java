package com.example.agriculture.controller;

import com.example.agriculture.model.*;
import com.example.agriculture.service.FarmerService;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("farmer")
public class FarmerController {

    @Value("${tianqiapi.appid}")
    private String appid;

    @Value("${tianqiapi.appsecret}")
    private String appsecret;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private FarmerService farmerService;

    // 默认获取农户已发布的产品信息
    @GetMapping("/getProductNames")
    public List<Product> getProductNames(HttpSession session) {
        int farmerId = (int) session.getAttribute("farmerId");
        return farmerService.getProductByFarmerId(farmerId);
    }

    // 添加新产品名称
    @PostMapping("/addProductName")
    public ResponseEntity<String> addProductName(@RequestParam("newProductName") String newProductName,
                                                 @RequestParam("productImage") MultipartFile imageurl,
                                                 HttpSession session) throws IOException {
        int farmerId = (int) session.getAttribute("farmerId");
        farmerService.addProductName(newProductName, farmerId, imageurl);
        return ResponseEntity.ok("success");
    }

    //根据productId获取产品信息(需要productId和productName)
    @PostMapping("/getProductDetails")
    public List<ProductAndVideo> getProductDetails(@RequestBody Product product2) {
        int productId = product2.getId();
        String productName = product2.getName();
        // 检查视频是否存在
        int count = farmerService.checkVideoExists(productId);
        System.out.println(productName + "的视频数量:" + count);
        if (count == 0) {
            // 如果视频不存在，获取仅包含产品信息的对象
            Product product1 = farmerService.getOnlyProducts(productId);
            // 创建一个新的 ProductAndVideo 对象，其中视频信息为空
            ProductAndVideo productAndVideo = new ProductAndVideo(product1.getName(), product1.getFarmer_id(), product1.getId(), "", null, product1.getStatus(), "");
            // 返回包含该对象的列表
            return List.of(productAndVideo);//内联变量
        } else {
            // 如果视频存在，从数据库查询产品信息
            List<ProductAndVideo> product = farmerService.getProductsInfo(productId, productName);

            // 创建一个新的列表来存储格式化后的产品信息
            List<ProductAndVideo> formattedProductList = new ArrayList<>();
            for (ProductAndVideo productAndVideo : product) {
                Date date = productAndVideo.getUploaded_date();
                if (date != null) {
                    // 获取上传日期
                    LocalDate localDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                    // 将 LocalDate 转换回 Date，使用 UTC 时区
                    ZonedDateTime zonedDateTime = localDate.atStartOfDay(ZoneId.of("UTC"));
                    Date correctedDate = Date.from(zonedDateTime.toInstant());
                    // 设置更正后的上传日期
                    productAndVideo.setUploaded_date(correctedDate);
                }
                // 将格式化后的产品信息添加到列表中
                formattedProductList.add(productAndVideo);
            }
            return formattedProductList;
        }
    }

    // 根据productId上传对应的视频
    @PostMapping("/addProductVideo")
    public ResponseEntity<String> uploadVideo(@RequestParam("videoTitle") String videoTitle,
                                              @RequestParam("videoFile") MultipartFile videoFile,
                                              @RequestParam("productId") int productId) {
        farmerService.addProductVideo(productId, videoFile, videoTitle);
        return ResponseEntity.ok("success");
    }

    // 完成上传视频更改状态码并生成二维码返回给前端
    @PostMapping("/completeProduct/{productId}")
    public ResponseEntity<Map<String, String>> completeProduct(@PathVariable int productId) throws WriterException, IOException {
        farmerService.completeUpload(productId);
        // 生成只包含 product_id 的二维码内容
        String qrUrl = generateDynamicQRUrl(productId);
        System.out.println(qrUrl);

        // 生成二维码
        String qrCodeBase64 = generateQRCode(qrUrl);
        System.out.println("生成的二维码: " + qrCodeBase64);

        // 返回响应
        Map<String, String> response = new HashMap<>();
        response.put("qrCodeBase64", qrCodeBase64);

        farmerService.updateQrCodeUrl(productId, qrCodeBase64);//将qrCodeBase64保存到数据库,绑定id
        return ResponseEntity.ok(response);
    }




    // 根据productId获取具体产品的详细信息
    @PostMapping("/getProduct/{productId}")
    public ResponseEntity<?> getProduct(@PathVariable int productId) {
        try {
            // 获取产品信息
            List<ProductAndVideo> productAndVideos = farmerService.getByProductId(productId);
            System.out.println("获取的产品信息: " + productAndVideos);

            if (productAndVideos != null && !productAndVideos.isEmpty()) {
                List<Map<String, String>> productDetails = new ArrayList<>();
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                int count = 0;

                for (ProductAndVideo pav : productAndVideos) {
                    Map<String, String> detail = new HashMap<>();
                    count++;

                    // 添加阶段信息
                    detail.put("name", pav.getName());
                    detail.put("period", pav.getPeriod());
                    detail.put("video_url", pav.getVideo_url());
                    detail.put("uploaded_date", dateFormat.format(pav.getUploaded_date()));
                    detail.put("stage", "阶段" + count);

                    productDetails.add(detail);
                }

                return ResponseEntity.ok(productDetails);  // 返回产品详情数据JSON
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("未找到产品信息");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("获取产品信息时发生错误: " + e.getMessage());
        }
    }

    // 获取用户详细信息
    @GetMapping("/getProfile")
    public ResponseEntity<?> getProfile(HttpSession session) {
        int farmerId = (int) session.getAttribute("farmerId");
        User user = farmerService.getUserInfo(farmerId);
        return ResponseEntity.ok(user);
    }

    // 更新用户信息
    @PostMapping("/updateProfile")
    public ResponseEntity<Map<String, Object>> updateProfile(@RequestParam("username") String username,
                                                             @RequestParam("password") String password,
                                                             @RequestParam("role") String role,
                                                             @RequestParam(value = "imageurl", required = false) MultipartFile imageurl,
                                                             @RequestParam("email") String email,
                                                             @RequestParam("phone") String phone,
                                                             @RequestParam("location") String location, HttpSession session) throws IOException {

        int farmerId = (int) session.getAttribute("farmerId");

        String updatedImageUrl = farmerService.updateUserInfo(farmerId, username, password, role, email, phone, location, imageurl);

        // 构建响应对象
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("imageurl", updatedImageUrl);

        return ResponseEntity.ok(response);
    }

    // 删除产品
    @PostMapping("/deleteProductName/{productId}")
    public ResponseEntity<String> deleteProductName(@PathVariable int productId) {
        farmerService.deleteProduct(productId);
        return ResponseEntity.ok("success");
    }

    // 修改产品
    @PostMapping("/updateProductName")
    public ResponseEntity<String> updateProductName(@RequestParam("productName") String productName,
                                                    @RequestParam(value = "productId", required = false) int productId,
                                                    @RequestParam(value = "productImage", required = false) MultipartFile productImage,
                                                    HttpSession session) throws IOException {

        int farmerId = (int) session.getAttribute("farmerId");
        String imagePath = farmerService.updateProductNameAndImage(farmerId, productName, productId, productImage);
        return ResponseEntity.ok(imagePath);
    }

    // 产品页面二维码获取
    @GetMapping("/getProductQRCode/{productId}")
    public ResponseEntity<String> getProductQRCode(@PathVariable int productId) {
        String qrCodeBase64 = farmerService.getQrCodeUrl(productId);
        return ResponseEntity.ok(qrCodeBase64);
    }

    //获取国家
    @GetMapping("/getCountry")
    public ResponseEntity<List<City>> getCountry() {
        List<City> countryList = farmerService.getCountry();
        return ResponseEntity.ok(countryList);
    }

    //根据国家获取省份
    @GetMapping("/getProvince/{countryZh}")
    public ResponseEntity<List<City>> getProvince(@PathVariable String countryZh) {
        List<City> provinceList = farmerService.getProvince(countryZh);
        return ResponseEntity.ok(provinceList);
    }

    //根据省份获取城市
    @GetMapping("/getCity/{provinceZh}")
    public ResponseEntity<List<City>> getCity(@PathVariable String provinceZh) {
        List<City> cityList = farmerService.getCity(provinceZh);
        return ResponseEntity.ok(cityList);
    }

    //点击完成按钮生成二维码时或者进入产品详情页面就触发，根据城市获取最近十五天的天气数据使其保存到数据库(以及农户id)，不返回给前端数据
    //中文城市名称city
    @GetMapping("/getWeather/{city}")
    public ResponseEntity<Boolean> getWeather(@PathVariable String city,
                                              HttpSession session) {
        int farmer_id = (int) session.getAttribute("farmerId");
        //先删除原来的天气数据
        farmerService.deleteWeatherDataByFarmerId(farmer_id);

        String cityId = farmerService.getCityId(city);
        //去掉cityId前两个字符
        String city_Id = cityId.substring(2);
        //获取当前日期并转为格式化（年月日）,并获取根据当前日期得出十五日之前的日期。
        // 定义日期格式
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        // 获取当前日期并格式化为 yyyy-MM-dd
        LocalDate currentDate = LocalDate.now();
        String formattedCurrentDate = currentDate.format(formatter);
        System.out.println("当前日期: " + formattedCurrentDate);

        // 获取十五天前的日期并格式化为 yyyy-MM-dd
        LocalDate fifteenDaysAgo = currentDate.minusDays(15);
        String formattedFifteenDaysAgo = fifteenDaysAgo.format(formatter);
        System.out.println("十五天前的日期: " + formattedFifteenDaysAgo);
        String date = formattedFifteenDaysAgo + "_" + formattedCurrentDate;

        String url = String.format("http://gfeljm.tianqiapi.com/free/history?appid=%s&appsecret=%s&cityid=%s&date=%s",
                appid, appsecret, city_Id, date);
        WeatherResponse response = restTemplate.getForObject(url, WeatherResponse.class);
        // 检查 response 是否为空
        if (response == null) {
            return ResponseEntity.ok(false);
        }

        boolean insertSuccess = true;
        for (Weather weather : response.getList()) {
            try {
                weather.setFarmer_id(farmer_id);
                weather.setCityId(cityId);
                farmerService.insertWeatherData(weather);
            } catch (Exception e) {
                e.printStackTrace();
                insertSuccess = false;
                break;
            }
        }
        return ResponseEntity.ok(insertSuccess);
    }



    // 生成动态的二维码包含的链接
    private String generateDynamicQRUrl(int productId) {
        try {
            InetAddress localHost = InetAddress.getLocalHost();
            String hostAddress = localHost.getHostAddress();
            return "http://" + hostAddress + ":8080/productPage?product_id=" + productId;//当前ip(网络)
        } catch (UnknownHostException e) {
            e.printStackTrace();
            return "http://localhost:8080/productPage?product_id=" + productId; // 否则默认生成localhost(本机测试环境)
        }
    }

    // 生成二维码
    private String generateQRCode(String content) throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);

        BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, 200, 200, hints);
        BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(bufferedImage, "png", baos);
        byte[] imageBytes = baos.toByteArray();
        return Base64.getEncoder().encodeToString(imageBytes);
    }
}