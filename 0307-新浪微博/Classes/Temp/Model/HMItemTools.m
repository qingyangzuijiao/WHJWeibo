//
//  HMItemTools.m
//  0307-新浪微博
//
//  Created by whj on 16/3/20.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMItemTools.h"

@implementation HMItemTools
#pragma mark 创建UIBarButtonItem
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage 
{
    //设置左边的返回按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //给按钮添加图片
    [leftButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    //使用UIView的分类方法,设置尺寸
    leftButton.size = leftButton.currentBackgroundImage.size;
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
}

@end
