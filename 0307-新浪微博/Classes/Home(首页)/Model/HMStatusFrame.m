//
//  HMStatusFrame.m
//  0307-新浪微博
//
//  Created by whj on 16/5/11.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMStatusFrame.h"
#import "HMStatus.h"
#import "HMUser.h"
#import "HMStatusPhotosView.h"

/**
 *  通过行数和列数计算控件（相册）的尺寸
 */
//第一种方法
//列数
//int col = count >= 3 ? 3 : count;
//CGFloat width = col * HMStatusPhotosWH + (col - 1) * HMStatusPhotosMargin;
////行数
//int row = 0;
//CGFloat height = 0;
//if (row % 3 == 0) {//能被3整除时
//    row = row / 3;
//    height = row * HMStatusPhotosWH + (row - 1) * HMStatusPhotosMargin;
//}
//else {//不能被3整除时
//    row = row / 3 + 1;
//    height = row * HMStatusPhotosWH + (row - 1) * HMStatusPhotosMargin;
//    
//}

//第二种方法
//    int rows = count / 3;
//    if (count % 3 != 0) {
//        rows += 1;
//    }


@implementation HMStatusFrame
/**
 *  该方法主要是为了计算文字的高度
 *  给定宽度，高度不确定，根据文字的字体计算高度，得到尺寸
 *
 *  @param text  文字内容
 *  @param font  文字字体
 *  @param width 给定的宽度
 *
 *  @return 根据定宽计算的尺寸
 */
//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width
//{
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = font;
//    
//    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}

/**
 *  该方法是为了计算文字的宽度
 *  根据字体来计算尺寸,width设置成无限大，就可以计算出文字的宽度
 *
 *  @param text 文字内容
 *  @param font 文字字体
 *
 *  @return 文字的尺寸
 */
//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
//{
//    return [self sizeWithText:text font:font width:MAXFLOAT];
//}



/**
 *  当给status赋值时就会调用该方法
 *
 *  @param status 微博的数据模型
 */
- (void)setStatus:(HMStatus *)status
{
    _status = status;
    
    HMUser *user = status.user;
    
    /** 原创微博整体*/
    /** 1.头像*/
    
    CGFloat iconX = HJStatusCellBorder;
    CGFloat iconY = HJStatusCellBorder;
    CGFloat iconWH = 35;
    self.iconImageViewFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 2.昵称*/
    CGFloat nameX = CGRectGetMaxX(self.iconImageViewFrame) + HJStatusCellBorder;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:HJStatusNameFont];
    //CGRect另一种赋值的方法
    self.nameLabelFrame = (CGRect){{nameX,nameY},nameSize};
    
    
    
    /** 3.会员图标*/
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelFrame) + HJStatusCellBorder;
        CGFloat vipY = nameY;
        CGFloat vipWidth = 15;
        CGFloat vipHeight = 15;
        self.vipImageViewFrame = CGRectMake(vipX, vipY, vipWidth, vipHeight);
    }

    /** 4.微博创建时间*/
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelFrame) + HJStatusCellBorder;
    CGSize timeSize = [status.created_at sizeWithFont:HJStatusTimeFont];
//    DLog(@"%@",status.created_at);
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    
    /** 5.微博来源*/
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelFrame) +HJStatusCellBorder;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:HJStatusSourceFont];
    self.sourceLabelFrame = (CGRect){{sourceX,sourceY},sourceSize};
    /** 6.微博内容*/
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconImageViewFrame), CGRectGetMaxY(self.timeLabelFrame)) + HJStatusCellBorder;
    CGSize contentSize = [status.text sizeWithFont:HJStatusContentFont width:ScreenWidth - 2*HJStatusCellBorder];
    self.contentLabelFrame = (CGRect){{contentX,contentY},contentSize};
    
    /** 7.配图*/
    //原创微博View的高度
    CGFloat originalViewH = 0;
    if (status.pic_urls.count) {// 有配图时
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelFrame) + HJStatusCellBorder;
        CGSize photoSize = [HMStatusPhotosView sizeWithPhotosCount:status.pic_urls.count];
        self.photoImageViewsFrame = (CGRect){{photoX,photoY},photoSize};
        
        originalViewH = CGRectGetMaxY(self.photoImageViewsFrame) + HJStatusCellBorder;
    }
    else { // 没有配图
        originalViewH = CGRectGetMaxY(self.contentLabelFrame) + HJStatusCellBorder;
    }
    
    
    /** 8.原创微博整体*/
    CGFloat originalViewX = 0;
    CGFloat originalViewY = 0;
    CGFloat originalViewW = ScreenWidth;
    self.originalViewFrame = (CGRect){originalViewX,originalViewY,originalViewW,originalViewH};
    
    CGFloat toolBarViewY = 0;
    /** 转发微博*/
    if (status.retweeted_status) { //有转发微博时
        HMStatus *retweet_status = status.retweeted_status;
        HMUser *retweet_status_user = retweet_status.user;
        
        /** 10.转发微博正文加昵称*/
        CGFloat retweetContentLabelX = HJStatusCellBorder;
        CGFloat retweetContentLabelY = HJStatusCellBorder;
        NSString *retweetContentName = [NSString stringWithFormat:@"@%@：%@",retweet_status_user.name,retweet_status.text];
        CGSize retweetContentLabelSize = [retweetContentName sizeWithFont:HJStatusRetweetStatusContentFont width:ScreenWidth - 2 * HJStatusCellBorder];
        self.retweetedContentLabelFrame = (CGRect){{retweetContentLabelX,retweetContentLabelY},retweetContentLabelSize};
        
        /** 11.转发微博配图*/
        CGFloat retweetViewH = 0;
        if (retweet_status.pic_urls.count) { //转发微博有配图
            CGFloat retweetPhotoX = retweetContentLabelX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetedContentLabelFrame) + HJStatusCellBorder;
            //计算配图整体控件的尺寸
            CGSize retweetPhotoSize = [HMStatusPhotosView sizeWithPhotosCount:retweet_status.pic_urls.count];
            self.retweetedPhotosImageViewFrame = (CGRect){{retweetPhotoX,retweetPhotoY},retweetPhotoSize};

            retweetViewH = CGRectGetMaxY(self.retweetedPhotosImageViewFrame) + HJStatusCellBorder;
            
        }
        else {//转发微博没有配图时
            retweetViewH = CGRectGetMaxY(self.retweetedContentLabelFrame) + HJStatusCellBorder;
        }
        
        /** 12.转发微博整体*/
        CGFloat retweetViewX = 0;
        CGFloat retweetViewY = CGRectGetMaxY(self.originalViewFrame);
        CGFloat retweetViewW = ScreenWidth;
        self.retweetedViewFrame = (CGRect){{retweetViewX,retweetViewY},{retweetViewW,retweetViewH}};
        
        /** 工具条的Y值*/
        toolBarViewY = CGRectGetMaxY(self.retweetedViewFrame);
        
    }
    
    else {
        /** 工具条的Y值*/
        toolBarViewY = CGRectGetMaxY(self.originalViewFrame);

    }
    
    /** 13.工具条整体*/
    CGFloat toolBarViewX = 0;
    CGFloat toolBarViewW = ScreenWidth;
    CGFloat toolBarViewH = 35;
    self.toolBarViewFrame = CGRectMake(toolBarViewX, toolBarViewY, toolBarViewW, toolBarViewH);
    
    /** 14.无转发微博时cell的高度*/
    self.cellHeight = CGRectGetMaxY(self.toolBarViewFrame) + HJStatusCellMargin;

   
}

@end
