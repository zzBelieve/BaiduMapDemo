//
//  GeoAndReGeoViewController.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/31.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import "GeoAndReGeoViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "BottomView.h"

#import "MapTool.h"
@interface GeoAndReGeoViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    
    BMKMapView* _mapView;
    
    
}

@property(nonatomic,strong)BMKLocationService *locationService;
@property(nonatomic,strong)BMKUserLocation *userLocation;

@property(nonatomic,strong)BottomView *bottomView;

@end

@implementation GeoAndReGeoViewController
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

- (BottomView *)bottomView{


    if (!_bottomView) {
        
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:self options:nil] lastObject];
        _bottomView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 120);
        
    }

    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    
    //开始定位
    [self.locationService startUserLocationService];
    
    [self.view addSubview:_mapView];
    [self.view addSubview:self.bottomView];
    
    
    
    
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 120, 45, 45)];
    [locationButton setImage:[UIImage imageNamed:@"navigation_n"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
}
- (void)locationButtonClick{

    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.userLocation.location.coordinate.latitude, self.userLocation.location.coordinate.longitude) animated:YES];
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

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
//    NSLog(@"didUpdateBMKUserLocation");
    [_mapView updateLocationData:userLocation];// 动态更新我的位置数
    //    self.locationService
    
    self.userLocation = userLocation;
    
    
    
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{

    [_mapView removeAnnotations:_mapView.annotations];
    
    
    [[MapTool sharedMapTool] reverseGeocode:coordinate reverseGeoCompletionBlock:^(BMKSearchErrorCode error, BMKReverseGeoCodeResult *result) {
        
        if (error==0) {
            
            
            
            NSLog(@"%@",result.address);
            self.bottomView.addressLabel.text = result.address;
            
        }else{
        
           self.bottomView.addressLabel.text = @"获取位置失败";
        }
    }];
    
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    [_mapView addAnnotation:annotation];
    
    // 1 系统自带计算距离的方法
//    CLLocation *destloc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    CLLocation *selfloc = self.userLocation.location;
//    
//    CLLocationDistance distanceSystem = [destloc distanceFromLocation:selfloc];
    
    
    //2 百度的计算距离方法
    BMKMapPoint point1 = BMKMapPointForCoordinate(self.userLocation.location.coordinate);
    BMKMapPoint point2 = BMKMapPointForCoordinate(coordinate);
    CLLocationDistance distanceBaiDu = BMKMetersBetweenMapPoints(point1,point2);
    
    

    
    self.bottomView.distanceLabel.text = [NSString stringWithFormat:@"距您%d米",(int)distanceBaiDu];
    self.bottomView.lonLabel.text = [NSString stringWithFormat:@"经度 ：%f",coordinate.longitude];
    self.bottomView.latLabel.text = [NSString stringWithFormat:@"纬度 ：%f",coordinate.latitude];

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    NSLog(@"....");
    
}
@end
