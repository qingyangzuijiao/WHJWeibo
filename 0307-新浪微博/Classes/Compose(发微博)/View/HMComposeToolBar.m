//
//  HMComposeToolBar.m
//  0307-新浪微博
//
//  Created by whj on 16/5/31.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMComposeToolBar.h"

@interface HMComposeToolBar ()
/**
 *  表情按钮
 */
@property (weak, nonatomic) UIButton *emotionButton;
@end

@implementation HMComposeToolBar

+ (instancetype)toolBar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //初始化按钮
        [self setupBtnWithImage:@"compose_toolbar_picture" highlightedImage:@"compose_toolbar_picture_highlighted" WithBtnType:ComposeButtonTypePicture];
        
        [self setupBtnWithImage:@"compose_camerabutton_background" highlightedImage:@"compose_camerabutton_background_highlighted" WithBtnType:ComposeButtonTypeCamera];

        [self setupBtnWithImage:@"compose_mentionbutton_background" highlightedImage:@"compose_mentionbutton_background_highlighted" WithBtnType:ComposeButtonTypeMention];

        [self setupBtnWithImage:@"compose_trendbutton_background" highlightedImage:@"compose_trendbutton_background_highlighted" WithBtnType:ComposeButtonTypeTrend];
        
        self.emotionButton =  [self setupBtnWithImage:@"compose_emoticonbutton_background" highlightedImage:@"compose_emoticonbutton_background_highlighted" WithBtnType:ComposeButtonTypeEmotion];
        
    }
    return self;
}

/**
 *  是否显示键盘按钮
 */
- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    //默认的图片
    NSString *imageNormal = @"compose_emoticonbutton_background";
    NSString *imageHighlight = @"compose_emoticonbutton_background_highlighted";
    
    //键盘按钮的图片
    if (showKeyboardButton) {
        imageNormal = @"compose_keyboardbutton_background";
        imageHighlight = @"compose_keyboardbutton_background_highlighted";
    }
    
    [self.emotionButton setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:imageHighlight] forState:UIControlStateHighlighted];

}

/**
 *  初始化按钮
 *
 *  @param image            正常状态下的image
 *  @param highlightedImage 高亮状态下的image
 */
- (UIButton *)setupBtnWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage WithBtnType:(ComposeButtonType)btnType;
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    
    btn.tag = btnType;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}
/**
 *  设置子控价的位置和尺寸
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        CGFloat x = i * btnW;
        CGFloat y = 0;
        CGFloat w = btnW;
        CGFloat h = btnH;
        btn.frame = CGRectMake(x, y, w, h);
        
    }
    
}

- (void)btnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(composeToolBar:ClickButtonType:)]) {
        
        [self.delegate composeToolBar:self ClickButtonType:sender.tag];
    }
}

@end
