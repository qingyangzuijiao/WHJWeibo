//
//  HMTitleButton.m
//  0307-新浪微博
//
//  Created by whj on 16/4/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  自定义button

#import "HMTitleButton.h"

#define HJMargin 5

@implementation HMTitleButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
       
        
        // 测试用的
//        self.backgroundColor = [UIColor greenColor];
//        self.titleLabel.backgroundColor = [UIColor blueColor];
//        self.imageView.backgroundColor = [UIColor yellowColor];
}
    return self;
}


//目的：想再系统计算和设置完按钮的尺寸后，再修改一下尺寸
/**
 *  重写setFrame:方法的目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.width += HJMargin;
    [super setFrame:frame];
}

/**
 *  当对象的尺寸发生改变时就会调用此方法
 */
- (void)layoutSubviews
{
    [super layoutSubviews];

    // 计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    
    // 计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + HJMargin;

    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    //只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    //按钮尺寸自适应
    [self sizeToFit];
}


/**
 *  设置按钮内部imageView的frame
 *
 *  @param contentRect 按钮的buttons
 */
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat x= CGRectGetMaxX(self.titleLabel.frame);
//    CGFloat y= 0;
//    CGFloat width = 30;
//    CGFloat height = contentRect.size.height;
//    return CGRectMake(x, y, width, height);
//}
/**
 *  设置按钮内部titleLabel的frame
 *
 *  @param contentRect 按钮的buttons
 */
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat x= 0;
//    CGFloat y= 0;
//    CGFloat width = 100;
//    CGFloat height = contentRect.size.height;
//    return CGRectMake(x, y, width, height);
//
//    
//}


@end
