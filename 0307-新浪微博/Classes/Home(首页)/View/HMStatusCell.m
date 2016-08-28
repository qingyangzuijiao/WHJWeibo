//
//  HMStatusCell.m
//  0307-新浪微博
//
//  Created by whj on 16/5/11.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMStatusCell.h"
#import "HMStatusFrame.h"
#import "HMStatus.h"
#import "HMUser.h"
#import <UIImageView+WebCache.h>
#import "HMPhoto.h"
#import "HMStatusToolBar.h"
#import "HMStatusPhotosView.h"
#import "HMIconView.h"

@interface HMStatusCell ()
/** 原创微博整体*/
@property (nonatomic, weak) UIView *originalView;
/** 头像*/
@property (nonatomic, weak) HMIconView *iconImageView;
/** 配图*/
@property (nonatomic, weak) HMStatusPhotosView *photosImageView;
/** 会员图标*/
@property (nonatomic, weak) UIImageView *vipImageView;
/** 昵称*/
@property (nonatomic,weak) UILabel *nameLabel;
/** 微博发送时间*/
@property (nonatomic,weak) UILabel *timeLabel;
/** 微博来源*/
@property (nonatomic,weak) UILabel *sourceLabel;
/** 微博内容*/
@property (nonatomic,weak) UILabel *contentLabel;

/** 转发微博*/
/** 转发微博整体*/
@property (nonatomic, weak) UIView *retweetedView;
/** 转发微博正文加昵称*/
@property (nonatomic, weak) UILabel *retweetedContentLabel;
/** 转发微博配图*/
@property (nonatomic, weak) HMStatusPhotosView *retweetedPhotosImageView;

/** 工具条整体*/
@property (nonatomic, weak) HMStatusToolBar *toolBarView;
@end

@implementation HMStatusCell
/**
 *  创建cell
 */
+ (instancetype)statusCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"statuses";
    HMStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[HMStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
#pragma mark cell的初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        /**
         *  设置cell选中时的背景颜色
         */
//        self.selectionStyle = UITableViewCellSelectionStyleNone;//选中不变色
        
//        UIView *bgView = [[UIView alloc] init];
//        bgView.backgroundColor = [UIColor yellowColor];
//        self.selectedBackgroundView = bgView;
        
        //原创微博
        [self setupOriginalStatues];
        //转发微博
        [self setupRetweetedStatues];
        //工具条
        [self setupToolBar];
    }
    
    return self;
}

/**
 *  初始化工具条
 */
#pragma mark 初始化工具条
- (void)setupToolBar
{
    /** 工具条整体*/
    HMStatusToolBar *toolBarView = [HMStatusToolBar tooBar];
    [self.contentView addSubview:toolBarView];
    self.toolBarView = toolBarView;

}

/**
 *  初始化原创微博
 */
#pragma mark 初始化原创微博
- (void)setupOriginalStatues
{
    /** 原创微博整体*/
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 配图*/
    HMStatusPhotosView *photosImageView = [[HMStatusPhotosView alloc] init];
    [originalView addSubview:photosImageView];
    self.photosImageView = photosImageView;
    
    /** 头像*/
    HMIconView *iconImageView = [[HMIconView alloc] init];
    [originalView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    /** 会员图标*/
    UIImageView *vipImageView = [[UIImageView alloc] init];
    vipImageView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipImageView];
    self.vipImageView = vipImageView;
    
    /** 昵称*/
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = HJStatusNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 微博创建时间*/
    UILabel *timeLabel = [[UILabel alloc] init];
//    timeLabel.backgroundColor = [UIColor redColor];
    timeLabel.font = HJStatusTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 微博来源*/
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = HJStatusSourceFont;
    sourceLabel.textColor = [UIColor darkGrayColor];
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 微博内容*/
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = HJStatusContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;

}
/**
 *  初始化转发微博
 */
#pragma mark 初始化转发微博
- (void)setupRetweetedStatues
{
    /** 转发微博整体*/
    UIView *retweetedView = [[UIView alloc] init];
//    retweetedView.backgroundColor = [UIColor whiteColor];
    retweetedView.backgroundColor = HMColor(247, 247, 247);
    [self.contentView addSubview:retweetedView];
    self.retweetedView = retweetedView;
    
    /** 转发微博正文加昵称*/
    UILabel *retweetedContentLabel = [[UILabel alloc] init];
    retweetedContentLabel.font = HJStatusRetweetStatusContentFont;
    retweetedContentLabel.numberOfLines = 0;
    [retweetedView addSubview:retweetedContentLabel];
    self.retweetedContentLabel = retweetedContentLabel;
    
    /** 转发微博配图*/
    HMStatusPhotosView *retweetedPhotosImageView = [[HMStatusPhotosView alloc] init];
    [retweetedView addSubview:retweetedPhotosImageView];
    self.retweetedPhotosImageView = retweetedPhotosImageView;

}


/**
 *  设置cell中控件的frame并给控件设置内容
 */
#pragma mark 设置cell中控件的frame并给控件设置内容
- (void)setStatusFrame:(HMStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    HMStatus *status = statusFrame.status;
    HMUser *user = status.user;
    
    /** 原创微博整体*/
    self.originalView.frame = statusFrame.originalViewFrame;
    
    
    /** 头像*/
    self.iconImageView.frame = statusFrame.iconImageViewFrame;
    self.iconImageView.user = user;
    
    /** 配图*/
    self.photosImageView.frame = statusFrame.photoImageViewsFrame;
    if (status.pic_urls.count) { // 有配图时
        //给相册view传入数据
        self.photosImageView.photos = status.pic_urls;
        
        //为了cell的循环引用考虑的
        self.photosImageView.hidden = NO;
        
    }
    else { // 没有配图时
        //为了cell的循环引用考虑的
        self.photosImageView.hidden = YES;
    }
    
    
    /** 会员图标*/
    if (user.isVip) {
        //为了cell的循环引用考虑的
        self.vipImageView.hidden = NO;
        self.vipImageView.frame = statusFrame.vipImageViewFrame;
        NSString *vipImageName = [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank];
        self.vipImageView.image = [UIImage imageNamed:vipImageName];
        self.nameLabel.textColor = [UIColor orangeColor];
    }
    else
    {
        //为了cell的循环引用考虑的
        self.vipImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];

    }
    
    
    /** 昵称*/
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelFrame;
    
    
    /** 微博创建时间*/
    //因为时间在变化，所以时间控件的尺寸也要重新算一次
//    NSString *newTime = status.created_at;
//    NSUInteger timeLength = self.timeLabel.text.length;
//    if (timeLength && newTime.length != timeLength) {// 判断是否第一次创建，或者长度不一样时，需要重新计算尺寸
//        /** 4.微博创建时间*/
//        CGFloat timeX = self.nameLabel.origin.x;
//        CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + HJStatusCellBorder;
//        CGSize timeSize = [newTime sizeWithFont:HJStatusTimeFont];
//        DLog(@"%@",newTime);
//        self.timeLabel.frame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
//        
//        
//        /** 5.微博来源*/
//        CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + HJStatusCellBorder;
//        CGFloat sourceY = timeY;
//        CGSize sourceSize = [status.source sizeWithFont:HJStatusSourceFont];
//        self.sourceLabel.frame = (CGRect){{sourceX,sourceY},sourceSize};
//
//    }
    
    NSString *newTime = status.created_at;
//    NSUInteger timeLength = self.timeLabel.text.length;

    
    self.timeLabel.text = newTime;
    statusFrame.status = status;//因为时间在变化，所以时间控件的尺寸也要重新算一次
    CGFloat timeX = self.nameLabel.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelFrame) + HJStatusCellBorder;
    CGSize timeSize = [newTime sizeWithFont:HJStatusTimeFont];
//    DLog(@"%@",newTime);
    self.timeLabel.frame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
//    self.timeLabel.frame = statusFrame.timeLabelFrame;

    /** 微博来源*/
    self.sourceLabel.text = status.source;
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + HJStatusCellBorder;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:HJStatusSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX,sourceY},sourceSize};
//    self.sourceLabel.frame = statusFrame.sourceLabelFrame;

    /** 微博正文*/
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelFrame;

    /** 转发微博*/
    if (status.retweeted_status) {// 有转发微博时
        
        HMStatus *retweet_status = status.retweeted_status;
        HMUser *retweet_status_user = retweet_status.user;
        
        /** 转发微博整体*/
        //为了cell的循环引用考虑的
        self.retweetedView.hidden = NO;
        self.retweetedView.frame = statusFrame.retweetedViewFrame;
        
        /** 转发微博正文加昵称*/
        NSString *retweetContentNameLabel = [NSString stringWithFormat:@"@%@：%@",retweet_status_user.name,retweet_status.text];
        self.retweetedContentLabel.text = retweetContentNameLabel;
        self.retweetedContentLabel.frame = statusFrame.retweetedContentLabelFrame;
        
        /** 转发微博配图*/
        if (status.retweeted_status.pic_urls.count) { //转发微博有配图时
            
            self.retweetedPhotosImageView.photos = retweet_status.pic_urls;
            
            //为了cell的循环引用考虑的
            self.retweetedPhotosImageView.hidden = NO;
            self.retweetedPhotosImageView.frame = statusFrame.retweetedPhotosImageViewFrame;
//            NSString *retweetImage = [[status.retweeted_status.pic_urls firstObject] thumbnail_pic];
//            [self.retweetedPhotosImageView sd_setImageWithURL:[NSURL URLWithString:retweetImage] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        }
        else { //转发微博没有配图时
            //为了cell的循环引用考虑的
            self.retweetedPhotosImageView.hidden = YES;
        }

    }
    else { //没有转发微博时
        //为了cell的循环引用考虑的
        self.retweetedView.hidden = YES;
    }
   
    /** 工具条整体*/
    self.toolBarView.frame = statusFrame.toolBarViewFrame;
    self.toolBarView.status = status;

    
    
}

/**
 *  第二种做法：让所有的cell的Y值都往下移一段距离，是为了让最上面的cell与navigationBar留一段距离
 *  第三种做法：让原创微博整体的y值往下移一段距离就行了，让cell的高度等于工具条最大的Y值就好了
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += HJStatusCellMargin;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
