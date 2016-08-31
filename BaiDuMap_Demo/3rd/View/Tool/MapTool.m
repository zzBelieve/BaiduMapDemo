//
//  MapTool.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/31.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import "MapTool.h"

@interface MapTool()<BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)BMKGeoCodeSearch *geocodesearch;


@property(nonatomic,strong)ReverseGeoCompletionBlock reverseGeoCompletionBlock;


@property(nonatomic,strong)GeoCompletionBlock geoCompletionBlock;

@end




@implementation MapTool

+ (instancetype)sharedMapTool{


    static MapTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _tool = [[self alloc] init];
    });
    
    return _tool;
}

#pragma mark - Lazy

- (BMKGeoCodeSearch *)geocodesearch{


    if (!_geocodesearch) {
        
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
    }
    return _geocodesearch;

}


- (void)reverseGeocode:(CLLocationCoordinate2D)LocationCoordinate2D reverseGeoCompletionBlock:(ReverseGeoCompletionBlock)reverseGeoCompletionBlock{

    
    self.reverseGeoCompletionBlock = reverseGeoCompletionBlock;
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = LocationCoordinate2D;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }


}

- (void)geocode:(NSString *)address city:(NSString *)city geoCompletionBlock:(GeoCompletionBlock)geoCompletionBlock{


    self.geoCompletionBlock = geoCompletionBlock;
    
    
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= city;
    geocodeSearchOption.address = address;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }


}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        
        ! self.reverseGeoCompletionBlock ? : self.reverseGeoCompletionBlock(error,result);
        
    }else{
    
        ! self.reverseGeoCompletionBlock ? : self.reverseGeoCompletionBlock(error,nil);
    
    }
}

/**
 *
 *
 *  @param result   地理编码结果
 *  @param error    错误信息
 */

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        
        ! self.geoCompletionBlock ? : self.geoCompletionBlock(error,result);
        
    }else{
    
        
        ! self.geoCompletionBlock ? : self.geoCompletionBlock(error,nil);
    
    }
}

@end
