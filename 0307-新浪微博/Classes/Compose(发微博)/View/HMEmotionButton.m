//
//  HMEmotionButton.m
//  0307-新浪微博
//
//  Created by whj on 16/7/18.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  标准的创建自定义的方法可以当作参考

#import "HMEmotionButton.h"
#import "HMEmotion.h"

@implementation HMEmotionButton
/**
 *  当控件不是从xib、storyboard中创建时，就会调用这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
    }
    return self;
}

/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}
/**
 *  这个方法在initWithCoder:方法后调用
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
}
//初始化该控件，为了保证不管是从xib还是代码创建控件都会设置属性
- (void)setup
{
    
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    
    //按钮高亮的时候不让系统去调整图片（默认是灰色YES）
    self.adjustsImageWhenHighlighted = NO;
//    adjustsImageWhenDisabled
}

//不让按钮高亮显示
//- (void)setHighlighted:(BOOL)highlighted
//{
//
//}

- (void)setEmotion:(HMEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) {//有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    }
    else if (emotion.code) {//是emoji表情
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }

    
}

@end
