package com.example.agriculture.service;

import com.example.agriculture.mapper.FarmerMapper;
import com.example.agriculture.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;


@Service
public class FarmerService {

    @Autowired
    private FarmerMapper farmerMapper;

    // 获取农户已发布的产品列表
    public List<Product> getProductByFarmerId(int farmerId) {
        System.out.println("产品列表" + farmerMapper.selectByFarmerId(farmerId));
        return farmerMapper.selectByFarmerId(farmerId);
    }

    public Product getOnlyProducts(int productId) {
        return farmerMapper.getOnlyProduct(productId);
    }

    public List<ProductAndVideo> getProductsInfo(int productId, String productName) {
        return farmerMapper.getProductsInfo(productId, productName);
    }

    public int checkVideoExists(int productId) {
        return farmerMapper.checkVideoExists(productId);
    }

    //为指定农户添加产品
    public void addProductName(String productName, int farmerId, MultipartFile image_url) throws IOException {
        String originalFilename = image_url.getOriginalFilename();
        assert originalFilename != null;
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String uniqueFilename = "农户" + farmerId + "_" + productName + "_" + UUID.randomUUID() + extension;
        // 使用相对路径, 存储在 resources/static/videos 下
        String filePath = "images/" + uniqueFilename;
        // 获取当前工作目录并拼接文件保存路径
        String basePath = System.getProperty("user.dir") + "/src/main/resources/static/";
        // 创建目标文件
        File dest = new File(basePath + filePath);
        if (!dest.exists()) {
            dest.getParentFile().mkdirs();  // 创建目录
        }
        // 保存文件
        image_url.transferTo(dest);

        System.out.println("Video file saved at: " + dest.getAbsolutePath()); // 添加日志确认文件保存路径
        Product product = new Product();
        product.setName(productName);
        product.setFarmer_id(farmerId);
        product.setStatus("0");
        product.setImage_url(filePath);
        farmerMapper.insert(product);
    }

    //获取用户所有信息
    public User getUserInfo(int farmerId) {
        User user = farmerMapper.getUserInfo(farmerId);
        if (user.getRole().equals("farmer")) {
            user.setRole("农户");
        } else {
            user.setRole("用户");
        }
        return user;
    }

    //为指定产品上传视频文件
    public void addProductVideo(int productId, MultipartFile video, String period) {
        Video video1 = new Video();

        try {
            String videoPath = saveVideoFile(video, productId, period);
            video1.setVideo_url(videoPath);
            video1.setPeriod(period);
            video1.setProduct_id(productId);

            // 获取当前日期
            Date currentDate = new Date();
            video1.setUploaded_date(currentDate);

            farmerMapper.insertVideo(video1);
            System.out.println("Video URL: " + video1.getVideo_url()); // 添加日志，检查保存的 URL

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //标记产品状态为完成
    public void completeUpload(int productId) {
        final String status = "1";
        farmerMapper.updateProductStatus(productId, status);
    }

    //生成二维码的方法
    public List<ProductAndVideo> getByProductId(int productId) {
        return farmerMapper.selectByProductId(productId);
    }

    //保存上传的视频文件到指定目录，并返回文件的访问路径
    private String saveVideoFile(MultipartFile file, int productId, String period) throws IOException {
        String originalFilename = file.getOriginalFilename();
        assert originalFilename != null;
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String uniqueFilename = "产品" + productId + "_" + period + "_" + UUID.randomUUID() + extension;

        // 使用相对路径, 存储在 resources/static/videos 下
        String filePath = "videos/" + uniqueFilename;

        // 获取当前工作目录并拼接文件保存路径
        String basePath = System.getProperty("user.dir") + "/src/main/resources/static/";

        // 创建目标文件
        File dest = new File(basePath + filePath);
        if (!dest.exists()) {
            dest.getParentFile().mkdirs();  // 创建目录
        }

        // 保存文件
        file.transferTo(dest);

        System.out.println("Video file saved at: " + dest.getAbsolutePath()); // 添加日志确认文件保存路径
        // 返回可以通过HTTP访问的相对路径
        return filePath;
    }

    //删除产品信息
    public void deleteProduct(int productId) {

        // 1. 获取产品信息
        Product product = farmerMapper.getOnlyProduct(productId);
        if (product == null) {
            throw new RuntimeException("产品不存在");
        }

        // 2. 获取视频信息
        List<Video> videos = farmerMapper.getVideosByProductId(productId);

        // 3. 删除图片文件
        String imagePath = product.getImage_url();
        if (imagePath != null && !imagePath.isEmpty()) {
            File imageFile = new File(System.getProperty("user.dir") + "/src/main/resources/static/" + imagePath);
            if (imageFile.exists()) {
                imageFile.delete();
                System.out.println("Image file deleted: " + imageFile.getAbsolutePath());
            }
        }

        // 4. 删除视频文件
        for (Video video : videos) {
            String videoPath = video.getVideo_url();
            if (videoPath != null && !videoPath.isEmpty()) {
                File videoFile = new File(System.getProperty("user.dir") + "/src/main/resources/static/" + videoPath);
                if (videoFile.exists()) {
                    videoFile.delete();
                    System.out.println("Video file deleted: " + videoFile.getAbsolutePath());
                }
            }
        }

        // 5. 删除数据库记录
        farmerMapper.deleteProductAndRelatedData(productId);
    }

    //更新用户信息
    public String updateUserInfo(int id, String username, String password, String role, String email, String phone, String location, MultipartFile imageurl) throws IOException {
        User user = new User();
        if (imageurl != null) {
            // 1. 获取原有图片文件路径
            String oldFilepath = farmerMapper.selectAvatarPathById(id);

            // 2. 删除原有图片文件
            if (oldFilepath != null && !oldFilepath.isEmpty()) {
                File oldImageFile = new File(System.getProperty("user.dir") + "/src/main/resources/static/" + oldFilepath);
                if (oldImageFile.exists()) {
                    oldImageFile.delete();
                    System.out.println("Old image file deleted: " + oldImageFile.getAbsolutePath());
                }
            }

            String originalFilename = imageurl.getOriginalFilename();
            assert originalFilename != null;
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String uniqueFilename = "用户" + id + "_" + UUID.randomUUID() + extension;

            // 使用相对路径, 存储在 resources/static/videos 下
            String filePath = "avatar/" + uniqueFilename;

            // 获取当前工作目录并拼接文件保存路径
            String basePath = System.getProperty("user.dir") + "/src/main/resources/static/";

            // 创建目标文件
            File dest = new File(basePath + filePath);
            if (!dest.exists()) {
                dest.getParentFile().mkdirs();  // 创建目录
            }

            // 保存文件
            imageurl.transferTo(dest);

            System.out.println("image file saved at: " + dest.getAbsolutePath()); // 添加日志确认文件保存路径
            // 返回可以通过HTTP访问的相对路径
            user.setPhone(phone);
            user.setPassword(password);
            user.setRole(role);
            user.setEmail(email);
            user.setId(id);
            user.setLocation(location);
            user.setUsername(username);
            user.setImageurl(filePath);
            farmerMapper.updateUserInfo(user);
            return filePath;
        } else {
            user.setPhone(phone);
            user.setPassword(password);
            user.setRole(role);
            user.setEmail(email);
            user.setId(id);
            user.setLocation(location);
            user.setUsername(username);
            farmerMapper.updateUserInfoWithoutImage(user);
            return null;
        }
    }

    //更新产品名称
    public String updateProductNameAndImage(int farmerId, String productName, int productId, MultipartFile productImage) throws IOException {

        // 1. 获取原有图片文件路径
        String oldImagePath = farmerMapper.selectImagePathById(productId);
        // 2. 删除原有图片文件
        if (oldImagePath != null && !oldImagePath.isEmpty()) {
            File oldImageFile = new File(System.getProperty("user.dir") + "/src/main/resources/static/" + oldImagePath);
            if (oldImageFile.exists()) {
                oldImageFile.delete();
                System.out.println("Old image file deleted: " + oldImageFile.getAbsolutePath());
            }
        }


        String originalFilename = productImage.getOriginalFilename();
        assert originalFilename != null;
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String uniqueFilename = "农户" + farmerId + "_" + productName + "_" + UUID.randomUUID() + extension;
        // 使用相对路径, 存储在 resources/static/videos 下
        String filePath = "images/" + uniqueFilename;
        // 获取当前工作目录并拼接文件保存路径
        String basePath = System.getProperty("user.dir") + "/src/main/resources/static/";
        // 创建目标文件
        File dest = new File(basePath + filePath);
        if (!dest.exists()) {
            dest.getParentFile().mkdirs();  // 创建目录
        }
        // 保存文件
        productImage.transferTo(dest);
        System.out.println("image file saved at: " + dest.getAbsolutePath()); // 添加日志确认文件保存路径
        farmerMapper.updateProductName(productName, productId, filePath);
        return filePath;
    }

    //获取二维码
    public String getQrCodeUrl(int productId) {
        return farmerMapper.selectQrCodeUrlById(productId);
    }

    //更新数据库二维码的URL
    public void updateQrCodeUrl(int productId, String qrCodeUrl) {
        farmerMapper.updateQrCodeUrl(productId, qrCodeUrl);
    }

    //获取国家
    public List<City> getCountry() {
        return farmerMapper.getCountryList();
    }

    //根据国家获取省份
    public List<City> getProvince(String countryZh) {
        return farmerMapper.getProvinceList(countryZh);
    }

    //根据省份获取城市
    public List<City> getCity(String provinceZh) {
        return farmerMapper.getCityListByProvince(provinceZh);
    }

    //根据城市获取城市id
    public String getCityId(String cityZh) {
        return farmerMapper.getCityIdByCityZh(cityZh);
    }

    //根据城市id和天气数据插入天气数据
    public void insertWeatherData(Weather weather) {
        farmerMapper.insertWeatherData(weather);
    }

    //根据农户id删除原来的天气数据
    public void deleteWeatherDataByFarmerId(int farmer_id) {
        farmerMapper.deleteWeatherDataByFarmerId(farmer_id);
    }
}
