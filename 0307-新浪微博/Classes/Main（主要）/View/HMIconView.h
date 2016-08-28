//
//  HMIconView.h
//  0307-新浪微博
//
//  Created by whj on 16/5/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  微博头像视图

#import <UIKit/UIKit.h>
@class HMUser;
@interface HMIconView : UIImageView
/** 用户模型*/
@property (nonatomic, strong) HMUser *user;

@end
