//
//  LocationViewController.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/12.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//定位功能

#import "LocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "ZZCustomAnnotationView.h"
@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    
    BMKMapView* _mapView;


}

@property(nonatomic,strong)BMKLocationService *locationService;

@end

@implementation LocationViewController

#pragma mark - lazy
- (BMKLocationService *)locationService{


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


#pragma mark - View lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.trafficEnabled = YES;
    
    //开始定位
    [self.locationService startUserLocationService];
    
    [self.view addSubview:_mapView];
    
    
    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
    userlocationStyle.accuracyCircleStrokeColor = [UIColor redColor];
    userlocationStyle.accuracyCircleFillColor = [UIColor cyanColor];
    userlocationStyle.locationViewImgName = @"bnavi_icon_location_fixed";
    [_mapView updateLocationViewWithParam:userlocationStyle];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    self.locationService.delegate = nil;
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}





/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{

    NSLog(@"willStartLocatingUser");

}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{

 NSLog(@"didStopLocatingUser");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{

  NSLog(@"didUpdateUserHeading");
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    NSLog(@"didUpdateBMKUserLocation");
     [_mapView updateLocationData:userLocation];// 动态更新我的位置数
//    self.locationService
    

}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{


    NSLog(@"didFailToLocateUserWithError");

}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{

    static NSString *ID = @"custom";
    
    ZZCustomAnnotationView *annView = (ZZCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annView == nil) {
        
        annView = [[ZZCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    }


    return annView;
}
@end
