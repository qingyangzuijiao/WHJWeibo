//
//  HMUser.h
//  0307-新浪微博
//
//  Created by whj on 16/4/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  账号模型

#import <Foundation/Foundation.h>

typedef enum {
    HMUserVerifiedNone = -1,//没有任何认证
    
    HMUserVerifiedPersonal = 0,//个人认证
    
    HMUserVerifiedOrgEnterprice = 2,//企业官方：CSDN、EOE、搜狐新闻客户端
    HMUserVerifiedOrgMedia = 3,// 媒体官方：程序员杂志、苹果汇
    HMUserVerifiedOrgWebsite = 5,// 网站官方：猫扑
    
    HMUserVerifiedDaren = 220 // 微博达人

} HMUserVerifiedtype;

@interface HMUser : NSObject
/**	string	字符串型的用户UID*/
@property(nonatomic, copy) NSString *idstr;

/**	string	好友显示名称*/
@property(nonatomic, copy) NSString *name;

/**	string	用户头像地址（中图），50×50像素*/
@property(nonatomic, copy) NSString *profile_image_url;

/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;

/** 获取是否是vip*/
@property (nonatomic, assign, getter=isVip) BOOL vip;


/** 认证类型*/
@property (nonatomic, assign) HMUserVerifiedtype verified_type;

//+(instancetype)userWithDict:(NSDictionary *)dict;

@end
