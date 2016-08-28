//
//  HMEmotionTextView.m
//  0307-新浪微博
//
//  Created by whj on 16/8/11.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMEmotionTextView.h"
#import "HMEmotion.h"
#import "HMTextAttachment.h"

@implementation HMEmotionTextView

- (void)insertEmotion:(HMEmotion *)emotion
{
    if (emotion.code) { //当是emoji表情时
        //将emoji的表情文字插入到光标所在处
        [self insertText:emotion.code.emoji];
    }
    else if (emotion.png){
        
        //加载图片:创建附件，用来显示图片
        HMTextAttachment *attach  =[[HMTextAttachment alloc] init];
        attach.emotion = emotion;
        CGFloat attachWH = self.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachWH, attachWH);
        
        NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:attach];
        
        //插入属性文字到光标所在处
//        [self insertAttributeString:imgString];

        //block:想在外面写一行代码放到里面去执行，不会污染代码保证代码的纯洁性
        [self insertAttributeString:imgString settingBlock:^(NSMutableAttributedString *attributeText) {

            [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributeText.length)];

        }];

//        
    }

}

- (NSString *)fullText
{
    
    NSMutableString *fullText = [[NSMutableString alloc] init];
    
    //遍历所有的属性文字(图片、emoji、普通文本)
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        HMTextAttachment *attach = attrs[@"NSAttachment"];
        //截取
        if (attach) {//带图片的属性文字
            [fullText appendString:attach.emotion.chs];
        }
        
        else {
            
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
        
//        HMLog(@"%@   %@",attrs,NSStringFromRange(range));
    }];
    
    return fullText;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
