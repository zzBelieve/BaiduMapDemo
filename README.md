
#1.申请秘钥 
   前往 **<http://lbsyun.baidu.com/apiconsole/key>** 申请秘钥.
   创建应用->填写应用名称、应用类型选择“iOS SDK”,安全码组成 : Bundle Identifier. 完成之后控制台列表中的“访问应用（ak）”就是您在开发过程中需要用到的开发密钥.
   
   
   
   
#2 手动配置开发环境(Cocoapods自行百度)
 * <http://lbsyun.baidu.com/index.php?title=iossdk/sdkiosdev-download> 下载百度地图iOS SDK
 
 * 新建一个工程,导入需要 .framework包.其中`BaiduMapAPI_Base.framework`为基础包，使用SDK任何功能都需导入，其他分包可按需导入.
   保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)，或者在工程属性中指定编译方式，即在Xcode的Project -> Edit Active Target -> Build Setting -> Compile Sources As，设置为"Objective-C++"
 
 
 * 引入系统库(直接复制,不分顺序) `CoreLocation.framework`、 `QuartzCore.framework`、`OpenGLES.framework`、`SystemConfiguration.framework`、`CoreGraphics.framework`、`Security.framework`、`libsqlite3.0.tbd`、`CoreTelephony.framework` 、`libstdc++.6.0.9.tbd`
 
    ![SystemFrameWork.png](http://upload-images.jianshu.io/upload_images/668391-77fc580aee451e0c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 

* 环境配置 在TARGETS->Build Settings->Other Linker Flags 中添加**-ObjC** (注意大小写)。

![ObjC.png](http://upload-images.jianshu.io/upload_images/668391-3eb5d1f2c0a7b7fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
     
* 引入mapapi.bundle资源文件. BaiduMapAPI_Map.framework->Resources文件中选择`mapapi.bundle`文件，并勾选“Copy items if needed”复选框，单击“Add”按钮，将资源文件添加到工程.

![mapBundle.png](http://upload-images.jianshu.io/upload_images/668391-52e33f1ed0b9991b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* 完成以上步骤后 TARGETS->info 添加一个key `Bundle display name` ,不然地图引擎会报下面的错误
         
![Bundle display name.png](http://upload-images.jianshu.io/upload_images/668391-312ffbfa8198b9e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
     
 
 
 
 至此 ,百度地图环境集成完毕.    
- - - -



#3 百度地图的基本功能

###3.1 定位功能
####导入头文件 `<BaiduMapAPI_Location/BMKLocationService.h>`

```
- (BMKLocationService *)locationService{//懒加载


    if (!_locationService) {
        
        
        BMKLocationService *locationService = [[BMKLocationService alloc] init];
        /// 设定定位的最小更新距离。默认为kCLDistanceFilterNone
        locationService.distanceFilter = 200.0f;
        
        /// 设定定位精度。默认为kCLLocationAccuracyBest。
        locationService.desiredAccuracy = kCLLocationAccuracyBest ;
        
        /// 设定最小更新角度。默认为1度，设定为kCLHeadingFilterNone会提示任何角度改变。
        locationService.headingFilter = 1;
        locationService.delegate = self;
        self.locationService = locationService;
    }

    return _locationService;


}

```

```
需要在info.plist文件中添加(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription)：
 *NSLocationWhenInUseUsageDescription 允许在前台使用时获取GPS的描述
 *NSLocationAlwaysUsageDescription 允许永远可获取GPS的描述
 
 
[self.locationService startUserLocationService];//开始定位

```

常见套路,通过代理 `BMKLocationServiceDelegate`的一系列方法,知晓定位的成功失败与否,不在赘述,详见Demo


真机运行或者模拟器选择位置后,地图上出现一个蓝点 

![bluebBall.png](http://upload-images.jianshu.io/upload_images/668391-0d3ca8eee061dbdd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

产品经理说了: 这个蓝色点太难看了,换~  ╮(╯▽╰)╭

```
    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
    userlocationStyle.accuracyCircleStrokeColor = [UIColor redColor];//精度圈 边框颜色
    userlocationStyle.accuracyCircleFillColor = [UIColor cyanColor];//精度圈 填充颜色
    userlocationStyle.locationViewImgName = @"bnavi_icon_location_fixed";//定位图标名称，需要将该图片放到 mapapi.bundle/images 目录下
    [_mapView updateLocationViewWithParam:userlocationStyle];

```
![CustomBall.png](http://upload-images.jianshu.io/upload_images/668391-e4decfdedcd36b54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


想换成什么样,换成什么样.
 

![sanpang.gif](http://upload-images.jianshu.io/upload_images/668391-393371b01c9b7e42.gif?imageMogr2/auto-orient/strip)
 
 
###3.2 覆盖物功能 (画圆,画线,画多边形,画圆弧,添加图片图层)
####导入头文件 `<BaiduMapAPI_Map/BMKMapComponent.h>`

####3.2.1 画圆

 ```
 BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:radius];//  coord 中心点的经纬度坐标..radius 半径，单位：米
 
 ```   
 
####3.2.2 画线 

 ```
BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coors count:count]; //coors 经纬度坐标点数组 count 坐标点的个数

 ```
####3.2.3 画多边形

```
BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:count];//coords 经纬度坐标点数组，这些点将被拷贝到生成的多边形对象中   count 点的个数

```  
####3.2.4 画圆弧

```

BMKArcline *arcline = [BMKArcline arclineWithCoordinates:coords];// coords 指定的经纬度坐标点数组(需传入3个点)

```

####3.2.4 添加图片图层

```
BMKCoordinateBounds bound;
bound.southWest = coords[0]; //西南角点经纬度坐标
bound.northEast = coords[1]; //东北角点经纬度坐标

BMKGroundOverlay *ground = [BMKGroundOverlay groundOverlayWithBounds:bound icon:[UIImage imageNamed:@"test.png"]];

``` 
 
 
 

```
[_mapView addOverlay:Overlay]; //添加覆盖物

[_mapView addOverlay:removeOverlay];//移除覆盖物

```


以上只是添加了覆盖物到地图上 ,但是具体覆盖物长什么样子,还有一些个性化定制,需要通过代理 `BMKMapViewDelegate`方法来实现

```
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay//overlay生成对应的View

```


###3.3 自定义大头针


####3.3.1 自定义标注
`BMKPointAnnotation`就代表地图上的一个点,但是具体这个点长什么样子则是由`BMKAnnotationView`来决定.
又是套路,首先往地图上添加若干BMKPointAnnotation对象(`[_mapView addAnnotation:annotation];`),然后通过`BMKMapViewDelegate`的代理方法 `- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation`来具体展示. Demo里的 `MeiTuanViewController` 请求的是美团店家的数据,如下:

![data.png](http://upload-images.jianshu.io/upload_images/668391-6596a0b3a6b2c3d4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

产品经理: 这红色的大头针太丑了,换!  

我 : 好嘞.

但是大头针的颜色只有`红`,`蓝`,`紫`(BMKPinAnnotationColorRed ,BMKPinAnnotationColorGreen,BMKPinAnnotationColorPurple)三种颜色可以选择..

产品经理: 不行,换成图片显示.

`annotationView.image = [UIImage imageNamed:@"category_1"];`


![customImage.png](http://upload-images.jianshu.io/upload_images/668391-06803a1d45a4b3bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我: 满意嘛? 


产品经理: 要根据店家类型显示不同的图片..

我: ....


但是`BMKPointAnnotation`没有标识来区分不同的店家类型..所以我们就只能自定义 `MeiTuanAnnotation` 继承 `BMKPointAnnotation`,并增加一个`type`属性来区分.

![normalPao.png](http://upload-images.jianshu.io/upload_images/668391-5252c6089ed38ce0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



我: 产品 你看行不行?

产品经理: 差不多了,但是这个大头针上面的气泡太丑了,换

我:....


####3.3.2 自定义气泡
```
annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];

这个paopaoView 我们就可以单独定制了.

```

![CustomPao.png](http://upload-images.jianshu.io/upload_images/668391-7b32142bc88b0525.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


别问我产品经理怎么不说话了,已经被我拖出去打死了.

------


###3.4 地理编码(Geo).反地理编码(ReGeo)

```
	地理编码 : 将中文地址或地名描述转换为地球表面上相应位置的功能.
	反地理编码 : 将地球表面的地址坐标转换为标准地址的过程.	
```


####导入头文件 `#import <BaiduMapAPI_Search/BMKSearchComponent.h>`, 关键的类 `BMKGeoCodeSearch`

```

- (BMKGeoCodeSearch *)geocodesearch{ //懒加载


    if (!_geocodesearch) {
        
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
    }
    return _geocodesearch;

}


```

套路来了.. 通过`BMKGeoCodeSearchDelegate`代理得到Geo和ReGeo的相关信息.

```
/**
 *
 *  @param result   地理编码结果
 *  @param error    错误信息
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
- 
```

```

/**
 *
 *  @param result   反地理编码结果
 *  @param error    错误信息
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error

```

封装了一个工具类 Demo效果如下:

![GeoReGeo.gif](http://upload-images.jianshu.io/upload_images/668391-8ecb3a779f6e6663.gif?imageMogr2/auto-orient/strip)



###3.5 不同坐标系之间的转换.

#### 3.5.1 先扫个盲.

```
 WGS84: 即地图坐标,美国GPS使用的是WGS84的坐标系统。GPS系统获得的坐标系统，基本为标准的国际通用的WGS84坐标系统.
 
 GCJ-02: 即火星坐标,是由中国国家测绘局制订的地理信息系统的坐标系统。它是一种对经纬度数据的加密算法，即加入随机的偏差。国内出版的各种地图系统（包括电子形式），出于国家安全考虑，必须至少采用GCJ-02对地理位置进行首次加密.
 
 BD-09: 即百度坐标: 在GCJ02基础上，进行了BD-09二次加密措施，API支持从WGS/GCJ转换成百度坐标，不支持反转.

```

国内常用地图的坐标系:

地图 | 坐标系
:----------- |  -----------: 
百度地图      | 百度坐标（BD-09）       
腾讯搜搜地图   |火星坐标
图吧MapBar地图 |图吧坐标
高德MapABC地图API|火星坐标
凯立德地图 | 火星坐标（转为K码）        




#### 3.5.1 WGS84.GCJ-02转换为BD-09 (百度公开API)

导入头文件 `#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>`

```
  /**
 *坐标转换函数，从原始GPS坐标，mapbar坐标,google坐标，51地图坐标，mapabc坐标转换为百度坐标（51地图坐标需要显出10000）
 *@param coordinate 待转换的坐标
 *@param type 待转换的坐标系类型，GPS为原始GPS坐标，COMMON为google坐标，51地图坐标，mapabc坐标
 *@return 返回的NSDictionry中包含“x”，“y”字段，各自对应经过base64加密之后的x，y坐标
 */
 UIKIT_EXTERN NSDictionary* BMKConvertBaiduCoorFrom(CLLocationCoordinate2D coordinate,BMK_COORD_TYPE type);

```

举个🌰

```

    CLLocationCoordinate2D originLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng);
    //转换GPS坐标至百度坐标
    NSDictionary* baiDudic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(baiDudic);//转换后的百度坐标

```


#### 3.5.2  BD-09 转换为 WGS84.GCJ-02(百度没公开API,只能google了)

在Github 找到这个转换算法 <https://github.com/TinyQ/TQLocationConverter>

```
 *  将WGS-84转为GCJ-02(火星坐标)
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;


 *  将GCJ-02(火星坐标)转为百度坐标
+ (CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p;

 *  将百度坐标转为GCJ-02(火星坐标)
+ (CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p;


 *  将GCJ-02(火星坐标)转为WGS-84
+ (CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p;

```