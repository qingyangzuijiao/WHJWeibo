//
//  HMPageView.h
//  0307-新浪微博
//
//  Created by whj on 16/7/3.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  每一页上显示按钮的控件：负责显示按钮的

#import <UIKit/UIKit.h>

@interface HMPageView : UIView
/** 每页上显示的按钮数组*/
@property(nonatomic, strong) NSArray *emotions;
@end
