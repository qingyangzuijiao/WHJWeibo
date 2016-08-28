//
//  HMTextAttachment.h
//  0307-新浪微博
//
//  Created by whj on 16/8/14.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMEmotion;
@interface HMTextAttachment : NSTextAttachment
/** 表情模型*/
@property(nonatomic, strong) HMEmotion *emotion;
@end
