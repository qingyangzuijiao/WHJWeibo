//
//  HMPlaceholderTextView.h
//  0307-新浪微博
//
//  Created by whj on 16/5/29.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  含有占位符的textView（加强）

#import <UIKit/UIKit.h>

@interface HMPlaceholderTextView : UITextView
/** 占位字符*/
@property (nonatomic, copy) NSString *placeholder;
/** 占位字符的颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;
@end
