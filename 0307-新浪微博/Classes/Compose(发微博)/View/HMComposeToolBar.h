//
//  HMComposeToolBar.h
//  0307-新浪微博
//
//  Created by whj on 16/5/31.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMComposeToolBar;
//typedef enum  {
//    ComposeButtonTypePicture, //相册
//    ComposeButtonTypeCamera, //相机
//    ComposeButtonTypeTrend, //热门话题
//    ComposeButtonTypeMention, //@ 提到某人
//    ComposeButtonTypeEmotion //表情
//
//} ComposeButtonType;

typedef NS_ENUM (NSInteger,ComposeButtonType) {
    ComposeButtonTypePicture, //相册
    ComposeButtonTypeCamera, //相机
    ComposeButtonTypeTrend, //热门话题
    ComposeButtonTypeMention, //@ 提到某人
    ComposeButtonTypeEmotion //表情

};

@protocol HMComposeToolBarDelegate <NSObject>

@optional

- (void)composeToolBar:(HMComposeToolBar *)toolBar ClickButtonType:(ComposeButtonType)btnType;

@end

@interface HMComposeToolBar : UIView

+ (instancetype)toolBar;

@property (weak, nonatomic) id <HMComposeToolBarDelegate>delegate;
/**
 *  是否显示键盘按钮
 */
@property (assign, nonatomic) BOOL showKeyboardButton;
@end
