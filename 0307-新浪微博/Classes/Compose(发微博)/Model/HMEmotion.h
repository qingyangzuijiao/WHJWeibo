//
//  HMEmotion.h
//  0307-新浪微博
//
//  Created by whj on 16/6/15.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMEmotion : NSObject
/** 表情的中文介绍*/
@property(copy, nonatomic) NSString *chs;
/** 表情的文件名*/
@property(copy, nonatomic) NSString *png;
/** 浪小花表情的16进制编码*/
@property(copy, nonatomic) NSString *code;

@end
