
//
//  HMTextAttachment.m
//  0307-新浪微博
//
//  Created by whj on 16/8/14.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMTextAttachment.h"
#import "HMEmotion.h"

@implementation HMTextAttachment

- (void)setEmotion:(HMEmotion *)emotion
{
    _emotion = emotion;
    
    //加载图片:创建附件，用来显示图片
    self.image = [UIImage imageNamed:emotion.png];

}

@end
