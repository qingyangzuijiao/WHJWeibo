//
//  UITextView+Extension.m
//  0307-新浪微博
//
//  Created by whj on 16/8/13.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)insertAttributeString:(NSAttributedString *)text
{
    [self insertAttributeString:text settingBlock:nil];
}

- (void)insertAttributeString:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *))settingBlock
{
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    [attributeText appendAttributedString:self.attributedText];
    
    //拼接字符串
    //        [attributeText appendAttributedString:imgString];
    NSInteger location = self.selectedRange.location;
//    [attributeText insertAttributedString:text atIndex:location];//插入图片
    
    [attributeText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    if (settingBlock) {
        settingBlock(attributeText);
    }
    
    self.attributedText = attributeText;
    
    //设置完文字，将光标移动到插入图片的后面
    self.selectedRange = NSMakeRange(location + 1, 0);
    
//    return attributeText;

}

@end
