//
//  UITextView+Extension.h
//  0307-新浪微博
//
//  Created by whj on 16/8/13.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)

- (void)insertAttributeString:(NSAttributedString *)text;

- (void)insertAttributeString:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *attributeText))settingBlock;


@end
