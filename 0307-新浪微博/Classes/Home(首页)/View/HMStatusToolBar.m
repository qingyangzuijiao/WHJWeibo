//
//  HMStatusToolBar.m
//  0307-新浪微博
//
//  Created by whj on 16/5/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMStatusToolBar.h"
#import "HMStatus.h"


@interface HMStatusToolBar ()
/**
 *  存放按钮的数组
 */
@property (nonatomic, strong) NSMutableArray *btns;
/**
 *  存放分割线的数组
 */
@property (nonatomic, strong) NSMutableArray *separators;

/**	转发数按钮*/
@property(nonatomic, weak) UIButton *repostsBtn;
/**	评论数按钮*/
@property(nonatomic, weak) UIButton *commentsBtn;
/**	表态数按钮*/
@property(nonatomic, weak) UIButton *attitudesBtn;


@end

@implementation HMStatusToolBar

- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)separators
{
    if (!_separators) {
        _separators = [NSMutableArray array];
    }
    return _separators;
}

+ (instancetype)tooBar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor whiteColor];
        //以平铺的方式设置背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        //创建按钮
        self.repostsBtn = [self setupBtnWithTitle:@"转发" icon:@"timeline_icon_retweet"];
        self.commentsBtn = [self setupBtnWithTitle:@"评论" icon:@"timeline_icon_comment"];
        self.attitudesBtn = [self setupBtnWithTitle:@"赞" icon:@"timeline_icon_unlike"];
        
        //创建分割线
        [self setupSeparator];
        [self setupSeparator];
    }
    return self;
}
/**
 *  初始化创建按钮
 *
 *  @param title 按钮文字
 *  @param icon  按钮的图标
 */
- (UIButton *)setupBtnWithTitle:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    return btn;
}
/**
 *  初始化创建分割线
 */
- (void)setupSeparator
{
    UIImageView *separatorImgView = [[UIImageView alloc] init];
    separatorImgView.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:separatorImgView];
    
    [self.separators addObject:separatorImgView];
    
}

/**
 *  给按钮中的子控件布局
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.btns.count;
    CGFloat btnW = self.width/count;
    CGFloat btnH = self.height;
    //设置按钮的尺寸
    for (int i=0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = btnW * i;
        btn.height = btnH;
    }
    
    //设置分割线的尺寸
    
    for (int i = 0; i < self.separators.count; i++) {
        UIImageView *imgView = self.separators[i];
        imgView.y = 0;
        imgView.height = btnH;
        imgView.width = 1;
        imgView.x = (i+1) * btnW;
    }
}

/**
 *  为工具条中的控件设置内容
 */
- (void)setStatus:(HMStatus *)status
{
    _status = status;
    //    测试数据
    //    status.reposts_count = 10001;
    //    status.comments_count = 15500;
    //    status.attitudes_count = 17000;
    /**	转发数*/
    [self setupBtnWithCount:status.reposts_count btn:self.repostsBtn title:@"转发"];
    
    
    /**	评论数*/
    [self setupBtnWithCount:status.comments_count btn:self.commentsBtn title:@"评论"];
    
    /**	表态数*/
    [self setupBtnWithCount:status.attitudes_count btn:self.attitudesBtn title:@"赞"];
    
}

/**
 *  设置按钮上的数字
 */
- (void)setupBtnWithCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count) { // 有数字时
        if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d",count];
            [btn setTitle:title forState:UIControlStateNormal];
        }
        else {// 达到10000：显示xx.x万，不要有.0的情况
            double bigCount = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",bigCount];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            [btn setTitle:title forState:UIControlStateNormal];
        }
    }
    else {//数字为0时
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
