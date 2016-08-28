//
//  HMEmotionTabBar.m
//  0307-新浪微博
//
//  Created by whj on 16/6/5.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMEmotionTabBar.h"
#import "HMEmotionTabBarButton.h"

@interface HMEmotionTabBar ()
/**
 *  保存按钮的状态
 */
@property(nonatomic, weak) HMEmotionTabBarButton *btnSelected;
@end

@implementation HMEmotionTabBar

- (instancetype)init
{
    if (self = [super init]) {
        [self setupButton:@"最近" buttonType:HMEmotionTabBarButtonTypeRecent];
        [self setupButton:@"默认" buttonType:HMEmotionTabBarButtonTypeDefault];//让该按钮成为默认选中的按钮
//        [self btnClick:[self setupButton:@"默认" buttonType:HMEmotionTabBarButtonTypeDefault]];
        [self setupButton:@"Emoji" buttonType:HMEmotionTabBarButtonTypeEmoji];
        [self setupButton:@"浪小花" buttonType:HMEmotionTabBarButtonTypeLXHua];

    }
    return self;
}
/**
 *  创建按钮
 *
 *  @param title 按钮上的文字
 *
 *  @return HMEmotionTabBarButton的对象
 */
- (HMEmotionTabBarButton *)setupButton:(NSString *)title buttonType:(HMEmotionTabBarButtonType)buttonType
{
//    HMEmotionTabBarButton *btn = [HMEmotionTabBarButton buttonWithType:UIButtonTypeCustom];//自定义按钮最好不用这个方法创建
    HMEmotionTabBarButton *btn = [[HMEmotionTabBarButton alloc] init];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    btn.tag = buttonType;
    
    
    NSString *imageNormal = @"compose_emotion_table_mid_normal";
    NSString *imageSelected = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        imageNormal = @"compose_emotion_table_left_normal";
        imageSelected = @"compose_emotion_table_left_selected";
    }
    
    else if (self.subviews.count == 4) {
        imageNormal = @"compose_emotion_table_right_normal";
        imageSelected = @"compose_emotion_table_right_selected";
        
    }
    [btn setBackgroundImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageSelected] forState:UIControlStateDisabled];

    return btn;
}

/**
 *  设置按钮的尺寸和位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (int i=0; i<count; i++) {
        HMEmotionTabBarButton *btn = self.subviews[i];
        CGFloat x = i * btnW;
        CGFloat y = 0;
        CGFloat w = btnW;
        CGFloat h = btnH;
        btn.frame = CGRectMake(x, y, w, h);
    }
}
/**
 *  是因为在keyboard中默认选中默认表情时的listView是没有添加上去的（没有调用代理方法）；也就是创建按钮的时候keyboard还没有成为该类的代理，所以当成为代理的时候再去将默认的按钮成为选中状态
 */
- (void)setDelegate:(id<HMEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    
    //让默认的按钮成为选中按钮
    [self btnClick:[self viewWithTag:HMEmotionTabBarButtonTypeDefault]];

}

/**
 *  改变按钮的状态
 */
- (void)btnClick:(HMEmotionTabBarButton *)sender
{
    self.btnSelected.enabled = YES;//按钮被选中的时候该按钮就不能在被选中了
    sender.enabled = NO;
    self.btnSelected = sender;
    
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:ClickButtonType:)]) {
        [self.delegate emotionTabBar:self ClickButtonType:(HMEmotionTabBarButtonType)sender.tag];
    }
    
}

@end
