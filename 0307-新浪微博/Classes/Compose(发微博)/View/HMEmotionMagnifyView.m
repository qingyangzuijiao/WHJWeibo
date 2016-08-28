//
//  HMEmotionMagnifyView.m
//  0307-新浪微博
//
//  Created by whj on 16/7/18.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMEmotionMagnifyView.h"
#import "HMEmotionButton.h"

@interface HMEmotionMagnifyView ()

@property (weak, nonatomic) IBOutlet HMEmotionButton *magnifyButton;

@end
@implementation HMEmotionMagnifyView

+ (instancetype)magnifyView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMEmotionMagnifyView" owner:nil options:nil] lastObject];
}

/**
 *  使用代码创建控件时就会调用该方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/**
 *  当从xib中加载时调用该方法
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
/**
 *  当从xib中加载时调用该方法
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)showFrom:(HMEmotionButton *)button
{
    if (button == nil) return;
    self.magnifyButton.emotion = button.emotion;
    
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    
    /**
     *  将btn所在的坐标系转换成以window为父视图的坐标系
     */
    //计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.centerX = CGRectGetMidX(btnFrame);
    self.y = CGRectGetMidY(btnFrame) - self.height;

}

//- (void)setEmotion:(HMEmotion *)emotion
//{
//    _emotion = emotion;
//    
//    self.magnifyButton.emotion = emotion;
//}

@end
