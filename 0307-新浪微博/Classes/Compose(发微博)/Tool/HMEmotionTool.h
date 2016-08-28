//
//  HMEmotionTool.h
//  0307-新浪微博
//
//  Created by whj on 16/8/21.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMEmotion;
@interface HMEmotionTool : NSObject
/**
 *  将表情存入到沙盒中
 */
+ (void)addRecentEmotion:(HMEmotion *)emotion;
/**
 *  取出沙盒中的表情数组
 */
+ (NSArray *)recentEmotion;
@end
