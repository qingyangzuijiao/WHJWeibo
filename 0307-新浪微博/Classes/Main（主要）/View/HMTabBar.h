//
//  HMTabBar.h
//  0307-新浪微博
//
//  Created by whj on 16/3/25.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMTabBar;
#warning 因为HWTabBar继承自UITabBar，所以成为HWTabBar的代理，也必须实现UITabBar的代理协议
@protocol  HMTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(HMTabBar *)tabBar;

@end


@interface HMTabBar : UITabBar
@property (nonatomic, assign) id<HMTabBarDelegate> delegate;
@end
