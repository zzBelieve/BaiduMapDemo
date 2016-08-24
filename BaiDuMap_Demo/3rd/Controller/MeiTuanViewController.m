//
//  MeiTuanViewController.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/24.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import "MeiTuanViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MeiTuanModel.h"

#import "MeiTuanAnnotation.h"

#import "MeiTuanPaoPaoView.h"
@interface MeiTuanViewController ()<BMKMapViewDelegate,MeiTuanPaoPaoViewDelegate>
{

    BMKMapView *_mapView;

}


@end

@implementation MeiTuanViewController



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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
    
    [self loadData];
}

- (void)loadData{

    NSString *urlString = @"http://api.meituan.com/meishi/filter/v4/deal/select/city/1/area/14/cate/1?__skua=58c45e3fe9ccacce6400c5a736b76480&userid=267752722&__vhost=api.meishi.meituan.com&movieBundleVersion=100&wifi-mac=8c%3Af2%3A28%3Afc%3A41%3A92&utm_term=6.5.1&limit=25&ci=1&__skcy=jyDTYwzfsbzflQbUtxRRR1RK2Ag%3D&__skts=1466298960.130064&sort=defaults&__skno=5210AD02-055C-47B7-BD23-A26EB36E2A20&wifi-name=MERCURY_4192&uuid=E158E8C43627D4B0B2BA94FC17DD78F08B7148D4A037A9933F3180FC1E550587&utm_content=E158E8C43627D4B0B2BA94FC17DD78F08B7148D4A037A9933F3180FC1E550587&utm_source=AppStore&version_name=6.5.1&mypos=38.300178%2C116.909954&utm_medium=iphone&wifi-strength=&wifi-cur=0&offset=0&poiFields=cityId%2Clng%2CfrontImg%2CavgPrice%2CavgScore%2Cname%2Clat%2CcateName%2CareaName%2CcampaignTag%2Cabstracts%2Crecommendation%2CpayInfo%2CpayAbstracts%2CqueueStatus&hasGroup=true&utm_campaign=AgroupBgroupD200Ghomepage_category1_1__a1&__skck=3c0cf64e4b039997339ed8fec4cddf05&msid=AE66B26D-47FB-4959-B3F3-FE25606FF0CB2016-06-19-09-1327";
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *data = responseObject[@"data"];
        for (NSDictionary *dict in data) {
            NSDictionary *poiDict = dict[@"poi"];
            
            MeiTuanModel *poi = [MeiTuanModel mj_objectWithKeyValues:poiDict];
            
            
            MeiTuanAnnotation *annotation = [[MeiTuanAnnotation alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.lat, poi.lng);
            annotation.coordinate = coordinate;
            annotation.model = poi;
            annotation.type = arc4random_uniform(4);
            annotation.title = poi.name;
            
            [_mapView addAnnotation:annotation];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"加载失败");
    }];


}

- (void)setUp{
    
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_mapView];
    
}


//- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    // 生成重用标示identifier
//    NSString *AnnotationViewID = @"ID";
//    
//    // 检查是否有重用的缓存
//    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//    
//    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
//    if (annotationView == nil) {
//        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
//        // 设置重天上掉下的效果(annotation)
//        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
//        
//    }
//    
//    // 设置位置
//    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
//    annotationView.annotation = annotation;
//    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
//    annotationView.canShowCallout = YES;
//    // 设置是否可以拖拽
//    annotationView.draggable = NO;
//    
//    annotationView.image = [UIImage imageNamed:@"category_1"];
//    
//    return annotationView;
//}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{

    
    if ([annotation isKindOfClass:[MeiTuanAnnotation class]]) {
        
        
        BMKAnnotationView *annotationView = [self getAnnotataionView:mapView viewForAnnotation:(MeiTuanAnnotation*)annotation];
        
        MeiTuanPaoPaoView * paopaoView = [MeiTuanPaoPaoView paoPaoView];
        paopaoView.delegate = self;
        MeiTuanAnnotation *aninotaion =  (MeiTuanAnnotation *)annotationView.annotation;
        paopaoView.model =aninotaion.model;
        
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
        
        return annotationView;
        
    }

    return nil;
}


- (BMKAnnotationView *)getAnnotataionView:(BMKMapView *)mapView viewForAnnotation:(MeiTuanAnnotation*)annotation{
    
    BMKAnnotationView* view = nil;
    
    switch (annotation.type) {
        case 0:
        {
        
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"One"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"One"];
                view.image = [UIImage imageNamed:@"category_1"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = annotation;
            
        
        }
            break;
            
        case 1:
        {
            
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"two"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"two"];
                view.image = [UIImage imageNamed:@"category_2"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = annotation;
            
        }
            break;
            
            
        case 2:
        {
            
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Three"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Three"];
                view.image = [UIImage imageNamed:@"category_3"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = annotation;
            
            
        }
            break;
            
            
        case 3:
        {
            
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Four"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Four"];
                view.image = [UIImage imageNamed:@"category_4"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = annotation;
            
        }
            break;
            
        case 4:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"five"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"five"];
                view.image = [UIImage imageNamed:@"category_5"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = annotation;
            
            
        }
            break;
            
        default:
            break;
    }


    return view;


}

#pragma mark - 大头针点击方法
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{

    
    MeiTuanAnnotation *aninotaion =  (MeiTuanAnnotation *)view.annotation;
    
    NSLog(@"...%@",aninotaion.model.name);
   
}

#pragma mark - 气泡点击方法
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{

    MeiTuanAnnotation *aninotaion =  (MeiTuanAnnotation *)view.annotation;
    
    NSLog(@"...%@",aninotaion.model.name);

}



#pragma mark - MeiTuanPaoPaoViewDelegate
- (void)paopaoView:(MeiTuanPaoPaoView *)pappaoView buttonClick:(MeiTuanModel *)model{


    
    NSLog(@"...%@",model.name);
}
@end
