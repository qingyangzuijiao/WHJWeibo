//
//  HMEmotionTabBarButton.m
//  0307-新浪微博
//
//  Created by whj on 16/6/6.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMEmotionTabBarButton.h"

@implementation HMEmotionTabBarButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置标题的字体颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        
        //设置按钮上的字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:15];

        }
    return self;
}

/**
 *  重写highlighted方法，让该方法失效
 */
- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
