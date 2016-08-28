//
//  HMPageView.m
//  0307-新浪微博
//
//  Created by whj on 16/7/3.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  
#define HMEmotionMaxCols 7
#define HMEmotionMaxRows 3

#import "HMPageView.h"
#import "HMEmotion.h"
#import "NSString+Emoji.h"
#import "HMEmotionMagnifyView.h"
#import "HMEmotionButton.h"
#import "HMEmotionTool.h"

@interface HMPageView ()
/** 放大镜控件*/
@property(nonatomic, strong) HMEmotionMagnifyView *magnifyView;
/** 删除按钮*/
@property(nonatomic, weak) UIButton *deleteButton;
@end

@implementation HMPageView

- (HMEmotionMagnifyView *)magnifyView
{
    if (!_magnifyView) {
        _magnifyView = [HMEmotionMagnifyView magnifyView];
    }
    return _magnifyView;
}

/**
 *  初始化时创建删除按钮
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.userInteractionEnabled = YES;
        //删除按钮
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        //添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
        
        
    }
    return self;
}

/**
 *  根据手指所在的位置返回相对应的按钮
*/
- (HMEmotionButton *)buttonWithLocation:(CGPoint)point
{
    for (int i=0; i<self.emotions.count; i++) {
        HMEmotionButton *emotionBtn = self.subviews[i + 1];
        
        if (CGRectContainsPoint(emotionBtn.frame, point)) {
            return emotionBtn;
        }
    }
    return nil;
}


/**
 *  在pageView长按时调用
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    
    //获取手指在pageView中的位置
    CGPoint point = [recognizer locationInView:recognizer.view];
    HMEmotionButton *btn = [self buttonWithLocation:point];
    
    switch (recognizer.state) {
            /**
             *  手势结束或者被结束的时候
             */
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
            {
                //手势结束时让放大镜消失
                [self.magnifyView removeFromSuperview];
                if (btn) {   //手势结束时如果手指是在按钮上消失的那么就要发送一个通知
                    
                    [HMEmotionTool addRecentEmotion:btn.emotion];
//                    [HMNotificationCenter postNotificationName:HMEmotionDidSelectedNotification object:self userInfo:@{HMEmotionBtnKey:btn.emotion}];
                }
                break;
            }
                
            /**
             *  手势开始被识别和改变的时候
             */
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
            {
                
                [self.magnifyView showFrom:btn];
                break;
                //获取手指在pageView中的位置
//                CGPoint point = [recognizer locationInView:recognizer.view];
//                for (int i=0; i<self.emotions.count; i++) {
//                    HMEmotionButton *btn = self.subviews[i + 1];
//                    if (CGRectContainsPoint(btn.frame, point)) {
//                        [self.magnifyView showFrom:btn];
//                        //已经找到表情按钮了，就不用继续遍历下去了
//                        break;
//                    }
//                }
//                break;
            }
                
                
            default:
                break;
    }
}


/**
 *  set数据的时候创建表情按钮
 */
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    
    for (int i=0; i<count; i++) {
        //使用自定义button一是为了将按钮中的文字或者图片传给放大镜控件中的button（或者使用tag进行传递）；二是为了放大镜中的button也可以使用
        HMEmotionButton *button = [[HMEmotionButton alloc] init];
        [self addSubview:button];
        
        // 设置表情数据
        HMEmotion *emotion = self.emotions[i];
        button.emotion = emotion;//
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        
//        [button setTitle:emotion.code forState:UIControlStateNormal];
//        button.backgroundColor = HMRandomColor;
    }

}

/**
 *  设置表情页上所有表情和删除按钮的位置和尺寸
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.emotions.count;
    CGFloat padding = 10;//内边距(四周)
    CGFloat btnW = (self.width - 2 * padding) / HMEmotionMaxCols;
    CGFloat btnH = (self.height - padding) / HMEmotionMaxRows;
    
    
    for (int i=0; i<count; i++) {
        //因为在创建表情按钮之前就已经存在删除按钮了
        UIButton *btn = self.subviews[i + 1];

        btn.width = btnW;
        btn.height = btnH;
        btn.x = padding + btnW*(i % HMEmotionMaxCols);
        btn.y = padding + btnH*(i / HMEmotionMaxCols);
    }
    
    //删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - btnW - padding;
    
    
    
}


//删除按钮的监听方法
- (void)deleteClick
{
    [HMNotificationCenter postNotificationName:HMEmotionDidDeleteNotification object:self];
}


/**
 *  按钮的点击事件
 */
- (void)btnClick:(HMEmotionButton *)btn
{
    
    /**
     *  显示放大镜控件
     */
    [self.magnifyView showFrom:btn];
      
    //等会让magnifyView消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.magnifyView removeFromSuperview];
    });
    
    
    //发送通知
    [self selectedEmotion:btn.emotion];

}

/**
 *  在发通知的时候代表已经选中了某个表情，所以此时将表情存放到沙盒中
 */
- (void)selectedEmotion:(HMEmotion *)emotion
{
    //将选中的表情模型存放到沙盒中
    [HMEmotionTool addRecentEmotion:emotion];
    
    //发送通知
    [HMNotificationCenter postNotificationName:HMEmotionDidSelectedNotification object:self userInfo:@{HMEmotionBtnKey:emotion}];
}


@end
