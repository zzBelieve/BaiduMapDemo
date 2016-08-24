//
//  MeiTuanModel.h
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/24.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MeiTuanModel : NSObject

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, assign) CGFloat avgScore;

@property (nonatomic, copy) NSString *cateName;

@property (nonatomic, copy) NSString *frontImg;
/** 平均价格*/
@property (nonatomic, assign) NSInteger avgPrice;

@property (nonatomic, copy) NSString *poiid;
/** 纬度*/
@property (nonatomic, assign) double lat;
/** 经度*/
@property (nonatomic, assign) double lng;
/** 店名*/
@property (nonatomic, copy) NSString *name;
/** 地区名称*/
@property (nonatomic, copy) NSString *areaName;

@end
