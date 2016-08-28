//
//  HMStatusFrame.h
//  0307-新浪微博
//
//  Created by whj on 16/5/11.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

//  一个HWStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型HWStatus

#import <Foundation/Foundation.h>

/** 昵称的字体*/
#define HJStatusNameFont [UIFont systemFontOfSize:15]
/** 微博时间的字体*/
#define HJStatusTimeFont [UIFont systemFontOfSize:13]
/** 微博来源的字体*/
#define HJStatusSourceFont [UIFont systemFontOfSize:12]
/** 微博正文的字体*/
#define HJStatusContentFont [UIFont systemFontOfSize:15]
/** 转发微博正文的字体*/
#define HJStatusRetweetStatusContentFont [UIFont systemFontOfSize:15]
/** cell之间的间距*/
#define HJStatusCellMargin 10
/** cell四周的间距*/
#define HJStatusCellBorder 10


@class HMStatus;

@interface HMStatusFrame : NSObject
/** 微博数据模型*/
@property (nonatomic, strong) HMStatus *status;

/** 原创微博整体*/
@property (nonatomic, assign) CGRect originalViewFrame;
/** 头像*/
@property (nonatomic, assign) CGRect iconImageViewFrame;
/** 配图*/
@property (nonatomic, assign) CGRect photoImageViewsFrame;
/** vip头像*/
@property (nonatomic, assign) CGRect vipImageViewFrame;
/** 昵称*/
@property (nonatomic, assign) CGRect nameLabelFrame;
/** 微博发送时间*/
@property (nonatomic, assign) CGRect timeLabelFrame;
/** 微博来源*/
@property (nonatomic, assign) CGRect sourceLabelFrame;
/** 微博内容*/
@property (nonatomic, assign) CGRect contentLabelFrame;


/** 转发微博整体*/
@property (nonatomic, assign) CGRect retweetedViewFrame;
/** 转发微博正文加昵称*/
@property (nonatomic, assign) CGRect retweetedContentLabelFrame;
/** 转发微博配图*/
@property (nonatomic, assign) CGRect retweetedPhotosImageViewFrame;

/** 工具条整体*/
@property (nonatomic, assign) CGRect toolBarViewFrame;

/** cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;
@end
