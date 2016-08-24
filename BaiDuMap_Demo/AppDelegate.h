//
//  AppDelegate.h
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/12.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{

 BMKMapManager* _mapManager;

}
@property (strong, nonatomic) UIWindow *window;


@end

