//
//  ZZCustomAnnotationView.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/12.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import "ZZCustomAnnotationView.h"

@implementation ZZCustomAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        
        self.backgroundColor = [UIColor redColor];
        
        
        self.centerOffset = CGPointMake(0, 0);
        
        self.frame = CGRectMake(0, 0, 45, 45);
        
        
        self.backGroundImage = [[UIImageView alloc] initWithFrame:self.frame];
        self.backGroundImage.image = [UIImage imageNamed:@"icon_nav_bus"];
        
        [self addSubview:self.backGroundImage];
        
        
    }

    return self;

}
@end
