//
//  HMEmotionTabBar.h
//  0307-新浪微博
//
//  Created by whj on 16/6/5.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  表情键盘下面的tabBar

#import <UIKit/UIKit.h>

typedef enum {
    HMEmotionTabBarButtonTypeRecent,//最近
    HMEmotionTabBarButtonTypeDefault,//默认
    HMEmotionTabBarButtonTypeEmoji,//emoji
    HMEmotionTabBarButtonTypeLXHua //浪小花

}HMEmotionTabBarButtonType;

@class HMEmotionTabBar;
@protocol HMEmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(HMEmotionTabBar *)emotionTabBar ClickButtonType:(HMEmotionTabBarButtonType)buttonType;

@end

@interface HMEmotionTabBar : UIView
@property (weak, nonatomic) id <HMEmotionTabBarDelegate>delegate;
@end
