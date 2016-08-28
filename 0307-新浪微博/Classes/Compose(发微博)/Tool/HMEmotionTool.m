//
//  HMEmotionTool.m
//  0307-新浪微博
//
//  Created by whj on 16/8/21.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//
#define HMRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "HMEmotionTool.h"
#import "HMEmotion.h"

//注意：成员变量只能在对象中使用，类方法中要用到static

@implementation HMEmotionTool

static NSMutableArray *_recentEmotions;

/**
 *  使用这个方法的好处是只在第一次使用该类的时候才会调用一次，减少了I／O口的使用频率
 */
+ (void)initialize
{
    //从沙盒中获取表情数组
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:HMRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

/**
 *  将表情存放在数组中保存在沙盒中
 *  @param emotion 选中的表情
 */
+(void)addRecentEmotion:(HMEmotion *)emotion
{
    /**
     *  这种方法放在这里导致会频繁的读取文件，使I/O繁忙
     */
//    NSMutableArray *emotions = (NSMutableArray *)[self recentEmotion];
//    if (emotions == nil) {
//        emotions = [NSMutableArray array];
//    }

    
    //删除重复的表情：涉及到删除数组中的对象的知识，用到了isEqual的知识
//    [_recentEmotions removeObject:emotion];
//    for (int i=0; i<emotions.count; i++) {
//        HMEmotion *e = emotions[i];
//        if ([e.chs isEqualToString:emotion.chs] || [e.code isEqualToString:emotion.code]) {
//            [emotions removeObject:e];
//            break;
//        }
//    }
    
    for (HMEmotion *e in _recentEmotions) {
        if ([e.chs isEqualToString:emotion.chs] || [e.code isEqualToString:emotion.code]) {
            [_recentEmotions removeObject:e];
            break;
        }
    }
    
    [_recentEmotions insertObject:emotion atIndex:0];
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:HMRecentEmotionsPath];
}

/**
 *  返回沙盒中的表情数组
 */
+(NSArray *)recentEmotion
{
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:HMRecentEmotionsPath];
    //也是为了减少I/O操作，每次读取都是读取该数组中的数据，而不是从沙盒中取出
    return _recentEmotions;
}

@end
