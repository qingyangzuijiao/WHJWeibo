//
//  HMEmotionMagnifyView.h
//  0307-新浪微博
//
//  Created by whj on 16/7/18.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  表情放大镜

//  warning：当xib中拖入buttton时最好调整button的属性为custom（默认是systerm）；当为systerm系统将会渲染图片导致图片显示错误

#import <UIKit/UIKit.h>

@class HMEmotionButton,HMEmotion;
@interface HMEmotionMagnifyView : UIView


//@property (nonatomic, strong) HMEmotion *emotion;
+ (instancetype)magnifyView;

- (void)showFrom:(HMEmotionButton *)button;

@end
