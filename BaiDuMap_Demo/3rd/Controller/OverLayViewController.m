//
//  OverLayViewController.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/24.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import "OverLayViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface OverLayViewController ()<BMKMapViewDelegate>
{


    BMKMapView *_mapView;
    
    BMKCircle *_circle;
    BMKPolygon *_polygon;
    BMKPolygon *_polygon2;
    BMKPolyline *_polyline;
    BMKPolyline *_colorfulPolyline;
    BMKArcline *_arcline;
    BMKGroundOverlay *_ground2;
    

}
@end

@implementation OverLayViewController

#pragma mark - View lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUp];
    
    //添加内置覆盖物
    [self addOverlayView];
}

- (void)setUp{

    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_mapView];

}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)addOverlayView{

    // 添加圆形覆盖物
    if (_circle == nil) {
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        _circle = [BMKCircle circleWithCenterCoordinate:coor radius:5000];
    }
    [_mapView addOverlay:_circle];
    
    // 添加多边形覆盖物
    if (_polygon == nil) {
        CLLocationCoordinate2D coords[4] = {0};
        coords[0].latitude = 39.915;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.815;
        coords[1].longitude = 116.404;
        coords[2].latitude = 39.815;
        coords[2].longitude = 116.504;
        coords[3].latitude = 39.915;
        coords[3].longitude = 116.504;
        _polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
    }
    [_mapView addOverlay:_polygon];
    
    // 添加多边形覆盖物
    if (_polygon2 == nil) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.604;
        coords[1].latitude = 39.865;
        coords[1].longitude = 116.604;
        coords[2].latitude = 39.865;
        coords[2].longitude = 116.704;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.654;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.704;
        _polygon2 = [BMKPolygon polygonWithCoordinates:coords count:5];
    }
    [_mapView addOverlay:_polygon2];
    
    //添加折线覆盖物
    if (_polyline == nil) {
        CLLocationCoordinate2D coors[2] = {0};
        coors[1].latitude = 39.895;
        coors[1].longitude = 116.354;
        coors[0].latitude = 39.815;
        coors[0].longitude = 116.304;
        _polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
    }
    [_mapView addOverlay:_polyline];
    
    //添加折线(分段颜色绘制)覆盖物
    if (_colorfulPolyline == nil) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.925;
        coords[1].longitude = 116.454;
        coords[2].latitude = 39.955;
        coords[2].longitude = 116.494;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.554;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.604;
        //构建分段颜色索引数组
        NSArray *colorIndexs = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:2], nil];
        
        //构建BMKPolyline,使用分段颜色索引，其对应的BMKPolylineView必须设置colors属性
        _colorfulPolyline = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:colorIndexs];
    }
    [_mapView addOverlay:_colorfulPolyline];
    
    // 添加圆弧覆盖物
    if (_arcline == nil) {
        CLLocationCoordinate2D coords[3] = {0};
        coords[0].latitude = 40.065;
        coords[0].longitude = 116.124;
        coords[1].latitude = 40.125;
        coords[1].longitude = 116.304;
        coords[2].latitude = 40.065;
        coords[2].longitude = 116.404;
        _arcline = [BMKArcline arclineWithCoordinates:coords];
    }
    [_mapView addOverlay:_arcline];



    //添加图片图层覆盖物
    if (_ground2 == nil) {
        CLLocationCoordinate2D coords[2] = {0};
        coords[0].latitude = 39.910;
        coords[0].longitude = 116.370;
        coords[1].latitude = 39.950;
        coords[1].longitude = 116.430;
        
        BMKCoordinateBounds bound;
        bound.southWest = coords[1];
        bound.northEast = coords[0];
        _ground2 = [BMKGroundOverlay groundOverlayWithBounds:bound icon:[UIImage imageNamed:@"test.png"]];
        _ground2.alpha = 0.8;
    }
    [_mapView addOverlay:_ground2];

}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        circleView.lineWidth = 5.0;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == _colorfulPolyline) {
            polylineView.lineWidth = 5;
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:
                                   [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5], nil];
        } else {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 20.0;
            [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        }
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = (overlay == _polygon2);
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    return nil;
}

@end
