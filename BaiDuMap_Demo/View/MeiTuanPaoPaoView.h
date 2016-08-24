//
//  MeiTuanPaoPaoView.h
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/24.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeiTuanModel,MeiTuanPaoPaoView;

@protocol MeiTuanPaoPaoViewDelegate <NSObject>

@optional

- (void)paopaoView:(MeiTuanPaoPaoView *)pappaoView buttonClick:(MeiTuanModel *)model;


@end


@interface MeiTuanPaoPaoView : UIView




+ (MeiTuanPaoPaoView *)paoPaoView;


@property(nonatomic,strong)MeiTuanModel *model;


@property(nonatomic,weak)id <MeiTuanPaoPaoViewDelegate>delegate;

@end
