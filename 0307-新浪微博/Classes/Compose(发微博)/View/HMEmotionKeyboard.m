//
//  HMEmotionKeyboard.m
//  0307-新浪微博
//
//  Created by whj on 16/6/5.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMEmotionKeyboard.h"
#import "HMEmotionListView.h"
#import "HMEmotionTabBar.h"
#import "HMEmotion.h"
#import <MJExtension.h>
#import "HMEmotionTool.h"

@interface HMEmotionKeyboard () <HMEmotionTabBarDelegate>
/** 容纳表情内容的控件，好处是可以让listView充斥整个自己，不用计算四个listView的frame；还能够管理四个view而不用一个view去管理四组表情 */
@property (nonatomic, weak) UIView *contentView;

/** 最近表情的控件 */
@property (nonatomic, strong) HMEmotionListView *recentListView;
/** 默认表情的控件 */
@property (nonatomic, strong) HMEmotionListView *defaultListView;
/** emoji表情的控件 */
@property (nonatomic, strong) HMEmotionListView *emojiListView;
/** 浪小花表情的控件 */
@property (nonatomic, strong) HMEmotionListView *lxhListView;

/** tabBar */
@property (nonatomic, weak) HMEmotionTabBar *emotionTabBar;

@end

@implementation HMEmotionKeyboard
/** 最近表情*/
- (HMEmotionListView *)recentListView
{
    if (!_recentListView) {
//        DLog(@"recentListView");

        _recentListView = [[HMEmotionListView alloc] init];
        _recentListView.emotions = [HMEmotionTool recentEmotion];//读取沙盒中的表情数据
//        _recentListView.backgroundColor = HMRandomColor;
    }
    return _recentListView;
}
/** 默认表情*/
- (HMEmotionListView *)defaultListView
{
    if (!_defaultListView) {
//        DLog(@"defaultListView");

        _defaultListView = [[HMEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"default.plist" ofType:nil];
        //字典数组转换成模型数组
        _defaultListView.emotions = [HMEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
//        DLog(@"default=%@",defaultEmotions);
//        _defaultListView.backgroundColor = HMRandomColor;
    }
    return _defaultListView;
}

/** emoji表情*/
- (HMEmotionListView *)emojiListView
{
    if (!_emojiListView) {
//        DLog(@"emojiListView");

        _emojiListView = [[HMEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
        //字典数组转换成模型数组
        _emojiListView.emotions = [HMEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
//        DLog(@"emoji=%@",emojiEmotions);
//        _emojiListView.backgroundColor = HMRandomColor;
    }
    return _emojiListView;
}

/** 浪小花表情*/
- (HMEmotionListView *)lxhListView
{
    if (!_lxhListView) {
//        DLog(@"lxhListView");
        self.lxhListView = [[HMEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lxh.plist" ofType:nil];
        //字典数组转换成模型数组
        self.lxhListView.emotions = [HMEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
//        DLog(@"lxh=%@",lxhEmotions);
//        self.lxhListView.backgroundColor = HMRandomColor;
    }
    return _lxhListView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.容纳表情内容的控件
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        //2.初始化tabbar
        HMEmotionTabBar *tabBar = [[HMEmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.emotionTabBar = tabBar;
        
        
        //监听表情点击，使点击表情可以刷新最近中的表情
        [HMNotificationCenter addObserver:self selector:@selector(emotionDidSelected) name:HMEmotionDidSelectedNotification object:nil];
    }
    return self;
}
/**
 *  监听表情被选中
 */
- (void)emotionDidSelected
{
    self.recentListView.emotions = [HMEmotionTool recentEmotion];
}

/**
 *  设置子控件的大小和位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    //tabbar
    self.emotionTabBar.height = 37;
    self.emotionTabBar.x = 0;
    self.emotionTabBar.y = self.height - self.emotionTabBar.height;
    self.emotionTabBar.width = self.width;
    
    //contentView
    self.contentView.x = self.contentView.y = 0;
    self.contentView.width = self.width;
    self.contentView.height = self.emotionTabBar.y;
    
    //contentView中的子控件
    UIView *childView = [self.contentView.subviews lastObject];
    childView.frame = self.contentView.bounds;
    
}

#pragma mark - HMEmotionTabBarDelegate
- (void)emotionTabBar:(HMEmotionTabBar *)emotionTabBar ClickButtonType:(HMEmotionTabBarButtonType)buttonType
{
    //移除contentView之前显示的控件
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (buttonType) {
        case HMEmotionTabBarButtonTypeRecent:{//最近
//            DLog(@"最近");
            [self.contentView addSubview:self.recentListView];
            break;
        }
            
        case HMEmotionTabBarButtonTypeDefault:{//默认
//            DLog(@"默认");
            [self.contentView addSubview:self.defaultListView];
            break;
        }
            
        case HMEmotionTabBarButtonTypeEmoji:{//emoji
//            DLog(@"emoji");
            [self.contentView addSubview:self.emojiListView];
            break;
        }
            
        case HMEmotionTabBarButtonTypeLXHua: {//浪小花
//            DLog(@"浪小花");
            [self.contentView addSubview:self.lxhListView];
            break;
        }
            
        default:
            break;
    }
    
    // 重新计算子控件的frame也就是重新调用layoutSubviews，(setNeedsLayout内部会在恰当的时刻，重新布局子控件)
    [self setNeedsLayout];
//    UIView *child = [self.contentView.subviews lastObject];
//    child.frame = self.contentView.frame;
    
}


@end
