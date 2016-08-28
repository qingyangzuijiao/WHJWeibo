//
//  HMStatus.h
//  0307-新浪微博
//
//  Created by whj on 16/4/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMUser;
@interface HMStatus : NSObject

/**	string	微博创建时间*/
@property(nonatomic, copy) NSString *created_at;
/**	string	字符串型的微博ID*/
@property(nonatomic, copy) NSString *idstr;
/**	string	微博信息内容*/
@property(nonatomic, copy) NSString *text;
/**	string	微博来源*/
@property(nonatomic, copy) NSString *source;
/**object 微博作者的用户信息字段 详细*/
@property(nonatomic, strong) HMUser *user;
/** 存放配图地址的集合*/
@property(nonatomic, strong) NSArray *pic_urls;

/** object	被转发的原微博信息字段，当该微博为转发微博时返回*/
@property(nonatomic, strong) HMStatus *retweeted_status;

/**	int	转发数*/
@property(nonatomic, assign) int reposts_count;
/**	int	评论数*/
@property(nonatomic, assign) int comments_count;
/**	int	表态数*/
@property(nonatomic, assign) int attitudes_count;

//因为用到MJExtension所以就不用自己字典转模型了
//+ (instancetype)statusWithDict:(NSDictionary *)dict;

@end
