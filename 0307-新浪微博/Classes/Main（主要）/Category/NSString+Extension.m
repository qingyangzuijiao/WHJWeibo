//
//  NSString+Extension.m
//  0307-新浪微博
//
//  Created by whj on 16/5/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font width:MAXFLOAT];
}


@end
