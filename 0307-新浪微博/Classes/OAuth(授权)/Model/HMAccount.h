//
//  HMAccount.h
//  0307-新浪微博
//
//  Created by whj on 16/4/20.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMAccount : NSObject <NSCoding>
/**　string	用于调用access_token，接口获取授权后的access token。*/
@property(nonatomic, copy)NSString *access_token;

/**　string	access_token的生命周期，单位是秒数。*/
@property(nonatomic, copy)NSNumber *expires_in;

/**remind_in	string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）*/


/**　string	当前授权用户的UID。*/
@property(nonatomic, copy)NSString *uid;

/** 账号创建时间 */
@property(nonatomic, strong) NSDate *created_time;

/** 用户昵称 */
@property(nonatomic, copy) NSString *name;


+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
