//
//  HMIconView.m
//  0307-新浪微博
//
//  Created by whj on 16/5/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMIconView.h"
#import "HMUser.h"
#import <UIImageView+WebCache.h>

@interface HMIconView ()
/** 认证的小图标*/
@property (nonatomic, weak) UIImageView *verifiedView;
@end

@implementation HMIconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        self.verifiedView = imgView;
    }
    return _verifiedView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       //        self.layer.masksToBounds= YES;
    }
    return self;
}
/**
 *  根据HMUser模型下载头像和给下标设置图片
 */
- (void)setUser:(HMUser *)user
{
    _user = user;
    
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    // 2.设置加V图片
    switch (user.verified_type) {
            
            case HMUserVerifiedPersonal:// 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
                
            case HMUserVerifiedOrgEnterprice:
            case HMUserVerifiedOrgMedia:
            case HMUserVerifiedOrgWebsite:// 官方认证
                self.verifiedView.hidden = NO;
                self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
                break;
                
                
            case HMUserVerifiedDaren:// 微博达人
                self.verifiedView.hidden = NO;
                self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
                break;
                
            default:// 当做没有任何认证
                self.verifiedView.hidden = YES;
                break;
    }
}
/**
 *  给下标设置位置和尺寸
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
    
    
    
    
}

@end
