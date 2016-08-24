//
//  MeiTuanPaoPaoView.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/24.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import "MeiTuanPaoPaoView.h"
#import "MeiTuanModel.h"

#import "UIImageView+WebCache.h"
@interface MeiTuanPaoPaoView()


@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLable;

@property (weak, nonatomic) IBOutlet UILabel *areaNameLable;


@end


@implementation MeiTuanPaoPaoView

+ (MeiTuanPaoPaoView *)paoPaoView{


    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    
}



- (void)setModel:(MeiTuanModel *)model{


    _model = model;
    
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.frontImg] placeholderImage:[UIImage imageNamed:@"category_3"]];
    
    self.shopNameLable.text = model.name;
    
    self.areaNameLable.text = model.areaName;

}
- (IBAction)paoPaoButtonClick:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(paopaoView:buttonClick:)]) {
        
        [self.delegate paopaoView:self buttonClick:self.model];
    }
}
@end
