//
//  HMStatusToolBar.h
//  0307-新浪微博
//
//  Created by whj on 16/5/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  cell上的工具条

#import <UIKit/UIKit.h>
@class HMStatus;

@interface HMStatusToolBar : UIView
/**
 *  初始化创建toolBar
 */
+ (instancetype)tooBar;

/**
 *  包含的属性
 */
@property (nonatomic, strong) HMStatus *status;
@end
