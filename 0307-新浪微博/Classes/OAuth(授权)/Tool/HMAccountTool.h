//
//  HMAccountTool.h
//  0307-新浪微博
//
//  Created by whj on 16/4/21.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMAccount.h"

@class HMAccount;

@interface HMAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(HMAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，return nil）
 */
+ (HMAccount *)account;

@end
