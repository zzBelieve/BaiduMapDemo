//
//  MapTool.h
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/31.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef void (^ReverseGeoCompletionBlock)(BMKSearchErrorCode error,BMKReverseGeoCodeResult *result);

typedef void (^GeoCompletionBlock)(BMKSearchErrorCode error,BMKGeoCodeResult *result);


@interface MapTool : NSObject


+ (instancetype)sharedMapTool;



- (void)reverseGeocode:(CLLocationCoordinate2D)LocationCoordinate2D  reverseGeoCompletionBlock:(ReverseGeoCompletionBlock)reverseGeoCompletionBlock;




- (void)geocode:(NSString *)address city:(NSString *)city geoCompletionBlock:(GeoCompletionBlock)geoCompletionBlock;



@end
