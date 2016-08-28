//
//  HMDropMenu.h
//  0307-新浪微博
//
//  Created by whj on 16/3/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMDropMenu;
@protocol HMDropMenuDelegate <NSObject>

@optional

- (void)dropMenuDidDismiss:(HMDropMenu *)menu;
- (void)dropMenuDidShow:(HMDropMenu *)menu;

@end

@interface HMDropMenu : UIView

@property (nonatomic, weak) id<HMDropMenuDelegate> delegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;


@end
