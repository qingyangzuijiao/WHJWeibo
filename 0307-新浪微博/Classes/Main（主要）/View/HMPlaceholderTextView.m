//
//  HMPlaceholderTextView.m
//  0307-新浪微博
//
//  Created by whj on 16/5/29.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMPlaceholderTextView.h"

@implementation HMPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //通知
        // 当UITextView文字发生改变时，自己会发出一个UITextViewTextDidChangeNotification通知
        [HMNotificationCenter addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

/**
 *  监听文字改变
 */
- (void)textChange
{
    //重绘（重新调用）
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    //setNeedsDisplay是在下一个消息循环，调用drawRect方法
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    //setNeedsDisplay是在下一个消息循环，调用drawRect方法
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

//- (NSAttributedString *)attributedText
//{
//    if (!self.attributedText) {
//        self.attributedText = [[NSAttributedString alloc] initWithString:self.text];
//        
//    }
//    return self.attributedText;
//}

/**
 *  移除通知
 */
- (void)dealloc
{
    [HMNotificationCenter removeObserver:self];
}

- (void)drawRect:(CGRect)rect
{
//    [self.placeholderColor set];
    
    if (self.hasText) { //当有文字时就直接返回，不画占位文字
        return;
    }
    
    //文字属性
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    //设置placeholder 的字体大小
    attri[NSFontAttributeName] = self.font;
    attri[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor grayColor];
    
    //画文字（此时占位文字不会换行）
//    [self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attri];
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    //将文字画在矩形中，是为了让占位文字换行
    [self.placeholder drawInRect:placeholderRect withAttributes:attri];
    
}

@end
