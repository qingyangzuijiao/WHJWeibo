//
//  HMTabBar.m
//  0307-新浪微博
//
//  Created by whj on 16/3/25.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMTabBar.h"

@interface HMTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation HMTabBar

- (instancetype)init
{
    if (self = [super init]) {
        //添加一个按钮到tabar
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;//等于当前按钮背景图片的尺寸
        
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;

    }
    return self;
}

/**
 *  加号按钮的点击事件
 */
- (void)plusBtnClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];//让代理实现方法
    }
}
/**
 *  注意要在系统布局之后再去调整
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    //设置其他按钮的位置
    //int count = (int)self.subviews.count;//此时的subviews并不是5；
    int tabBarButtonIndex = 0;
    CGFloat tabBarButtonWidth = self.width/5;//
    
    for (UIView *childView in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");//将字符串变成类
        if ([childView isKindOfClass:class]) {
            childView.width = tabBarButtonWidth;
            childView.x = tabBarButtonIndex * tabBarButtonWidth;
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
    
        /**
     *  for (int i =0; i< count; i++) {
        UIView *childView = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");//将字符串变成类
        if ([childView isKindOfClass:class]) {
            //HMLog(@"%d",i);
            childView.width = tabBarButtonWidth;
            childView.x = tabBarButtonWidth * tabBarButtonIndex;
            tabBarButtonIndex ++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex ++;
            }
        }
    }

     */

}

@end
