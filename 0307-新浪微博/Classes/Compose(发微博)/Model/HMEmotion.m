//
//  HMEmotion.m
//  0307-新浪微博
//
//  Created by whj on 16/6/15.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMEmotion.h"
#import "MJExtension.h"
@interface HMEmotion () <NSCoding>

@end

@implementation HMEmotion

//MJCodingImplementation 
/**
 *  从文件中解析对象时调用
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.png = [decoder decodeObjectForKey:@"png"];
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.code = [decoder decodeObjectForKey:@"code"];
    }
    return self;
}

/**
 *  将对象写入文件时调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.code forKey:@"code"];

}

/**
 *  该方法是NSObject的方法：常用来比较两个HMEmotion对象是否一样
 *
 *  @param other 传进来的对象
 *
 *  @return YES：2个对象是一样；NO：2个对象不一样
 */
- (BOOL)isEqual:(HMEmotion *)other
{
    //如果2个对象的字段
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];

}

@end
