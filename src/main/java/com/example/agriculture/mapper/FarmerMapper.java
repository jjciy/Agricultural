package com.example.agriculture.mapper;

import com.example.agriculture.model.*;
import org.apache.ibatis.annotations.*;

import java.util.List;


@Mapper
public interface FarmerMapper {
    // 获取农户已发布的产品名称
    @Select("SELECT id, name, farmer_id, status, image_url ,qrcode_url FROM products WHERE farmer_id = #{farmer_id}")
    List<Product> selectByFarmerId(int farmerId);

    @Select("SELECT * FROM products WHERE id = #{product_id}")
    Product getOnlyProduct(int product_id);

    //获取产品信息
    @Select("SELECT DISTINCT p.name, p.farmer_id, p.status, v.product_id, v.video_url, v.uploaded_date, v.period FROM products p JOIN videos v ON p.id = v.product_id WHERE v.product_id = #{productId} and p.name=#{productName}")
    List<ProductAndVideo> getProductsInfo(int productId, String productName);

    //获取产品信息时检查videos表中是否有对应的产品数据
    @Select("SELECT COUNT(*) FROM videos WHERE product_id = #{productId}")
    int checkVideoExists(int productId);

    //插入产品操作
    @Insert("INSERT INTO products (name, farmer_id, status,image_url) " + "VALUES (#{name}, #{farmer_id}, #{status},#{image_url})")
    void insert(Product product);

    //插入视频操作
    @Insert("INSERT INTO videos (product_id, uploaded_date, video_url, period) " + "VALUES (#{product_id}, #{uploaded_date}, #{video_url}, #{period})")
    void insertVideo(Video video);

    //更新状态码
    @Update("UPDATE products SET status = #{status} WHERE id = #{productId}")
    void updateProductStatus(int productId, String status);

    //生成二维码时获取这些产品数据
    @Select("SELECT DISTINCT p.name, p.farmer_id, p.status, v.product_id, v.video_url, v.uploaded_date, v.period FROM products p JOIN videos v ON p.id = v.product_id WHERE v.product_id = #{productId}")
    List<ProductAndVideo> selectByProductId(int productId);

    //删除产品信息
    @Delete("DELETE FROM airhumidity WHERE product_id = #{productId}")
    void deleteAirHumidity(int productId);

    @Delete("DELETE FROM lightrecord WHERE product_id = #{productId}")
    void deleteLightRecord(int productId);

    @Delete("DELETE FROM videos WHERE product_id = #{productId}")
    void deleteVideos(int productId);

    @Delete("DELETE FROM products WHERE id = #{productId}")
    void deleteProduct(int productId);

    default void deleteProductAndRelatedData(int productId) {
        deleteAirHumidity(productId);
        deleteLightRecord(productId);
        deleteVideos(productId);
        deleteProduct(productId);
    }

    //获取用户信息用于修改
    @Select("SELECT * FROM users WHERE id = #{farmerId}")
    User getUserInfo(int farmerId);

    //更新全部用户信息
    @Update("UPDATE users SET username = #{username},password = #{password}, email = #{email}, phone = #{phone}, location = #{location}, imageurl = #{imageurl} WHERE id = #{id}")
    void updateUserInfo(User user);

    //更新用户信息(除头像)
    @Update("UPDATE users SET username = #{username},password = #{password}, email = #{email}, phone = #{phone}, location = #{location} WHERE id = #{id}")
    void updateUserInfoWithoutImage(User user);

    //修改产品名称
    @Update("UPDATE products SET name = #{name}, image_url = #{filePath} WHERE id = #{productId}")
    void updateProductName(String name, int productId, String filePath);

    //获取二维码url
    @Select("SELECT qrcode_url FROM products WHERE id = #{productId}")
    String selectQrCodeUrlById(int productId);

    //更新二维码url
    @Update("update products set qrcode_url=#{qrCodeUrl} where id=#{productId}")
    void updateQrCodeUrl(int productId, String qrCodeUrl);

    // 删除产品时获取视频路径以删除本地资源
    @Select("SELECT * FROM videos WHERE product_id = #{productId}")
    List<Video> getVideosByProductId(@Param("productId") int productId);

    // 修改产品时获取产品旧图片路径以删除本地资源
    @Select("SELECT image_url FROM products WHERE id = #{productId}")
    String selectImagePathById(int productId);

    @Select("SELECT imageurl FROM users WHERE id = #{id}")
    String selectAvatarPathById(int id);

    //获取city中的国家列表（中国）
    @Select("SELECT DISTINCT countryZh FROM city")
    List<City> getCountryList();

    //获取city表中的省份列表
    @Select("SELECT DISTINCT provinceZh FROM city WHERE countryZh = #{countryZh}")
    List<City> getProvinceList(@Param("countryZh") String countryZh);

    //根据省份选择城市
    @Select("SELECT DISTINCT cityZh FROM city WHERE provinceZh = #{provinceZh}")
    List<City> getCityListByProvince(@Param("provinceZh") String provinceZh);

    //根据城市获取城市id
    @Select("SELECT id FROM city WHERE cityZh = #{cityZh}")
    String getCityIdByCityZh(@Param("cityZh") String cityZh);

    //根据城市id和天气数据插入天气数据
    @Insert("INSERT INTO weather (city_id, date, wea_day, wea_night, tem_day, tem_night, humidity,visibility,pressure,win,win_speed,win_meter,air,pm25,pm10,o3,no2,so2,co,sunrise,sunset,moonrise,moonset,uv,cloud_pct,precip_pct,farmer_id) " + "VALUES (#{cityId}, #{date}, #{wea_day}, #{wea_night}, #{tem_day}, #{tem_night}, #{humidity},#{visibility},#{pressure},#{win},#{win_speed},#{win_meter},#{air},#{pm25},#{pm10},#{o3},#{no2},#{so2},#{co},#{sunrise},#{sunset},#{moonrise},#{moonset},#{uv},#{cloudPct},#{precipPct},#{farmer_id})")
    void insertWeatherData(Weather weather);

    //根据农户id删除原来的天气数据
    @Delete("DELETE FROM weather WHERE farmer_id = #{farmerId}")
    void deleteWeatherDataByFarmerId(int farmerId);


}

