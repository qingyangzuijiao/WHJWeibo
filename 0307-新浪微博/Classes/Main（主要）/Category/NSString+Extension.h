//
//  NSString+Extension.h
//  0307-新浪微博
//
//  Created by whj on 16/5/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/**
 *  该方法主要是为了计算文字的高度
 *  给定宽度，高度不确定，根据文字的字体计算高度，得到尺寸
 *
 *  @param text  文字内容
 *  @param font  文字字体
 *  @param width 给定的宽度
 *
 *  @return 根据定宽计算的尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width;

/**
 *  该方法是为了计算文字的宽度
 *  根据字体来计算尺寸,width设置成无限大，就可以计算出文字的宽度
 *
 *  @param text 文字内容
 *  @param font 文字字体
 *
 *  @return 文字的尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font;

@end
