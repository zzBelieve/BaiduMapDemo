//
//  MeiTuanAnnotation.h
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/24.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//


#import <BaiduMapAPI_Map/BMKMapComponent.h>

@class MeiTuanModel;

@interface MeiTuanAnnotation : BMKPointAnnotation


@property(nonatomic,strong)MeiTuanModel *model;


@property(nonatomic,assign)int type;

@end
