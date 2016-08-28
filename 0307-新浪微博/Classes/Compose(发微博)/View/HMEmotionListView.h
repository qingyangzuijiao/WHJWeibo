//
//  HMEmotionListView.h
//  0307-新浪微博
//
//  Created by whj on 16/6/5.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  表情键盘中表情列表：（scrollView和pageControl）

#import <UIKit/UIKit.h>

@interface HMEmotionListView : UIView
/** 存放HMEmotion模型的数组*/
@property(nonatomic,strong) NSArray *emotions;
@end
