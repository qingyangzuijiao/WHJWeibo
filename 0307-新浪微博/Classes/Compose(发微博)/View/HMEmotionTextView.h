//
//  HMEmotionTextView.h
//  0307-新浪微博
//
//  Created by whj on 16/8/11.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  可以插入表情的textView

#import "HMPlaceholderTextView.h"

@class HMEmotion;
@interface HMEmotionTextView : HMPlaceholderTextView

- (void)insertEmotion:(HMEmotion *)emotion;

- (NSString *)fullText;
@end
