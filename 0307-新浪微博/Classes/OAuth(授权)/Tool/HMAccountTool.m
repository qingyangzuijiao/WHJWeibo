//
//  HMAccountTool.m
//  0307-新浪微博
//
//  Created by whj on 16/4/21.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  处理账号相关的所有操作：存储账号、取出账号、验证账号



//账号存储路径
#define HMAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.plist"]

#import "HMAccountTool.h"
#import "HMAccount.h"

@implementation HMAccountTool
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(HMAccount *)account
{
    //自定义对象的存储必须使用NSKeyedarchiver
    [NSKeyedArchiver archiveRootObject:account toFile:HMAccountPath];

}
/**
 *  返回账号信息
 *
 *  @return 账号模型
 */
+ (HMAccount *)account
{
    // 加载模型
    HMAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HMAccountPath];
    
    /** 验证账号是否过期*/
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    //当前时间
    NSDate *now = [NSDate date];
    //获取过期时间
    NSDate *expireDate = [account.created_time dateByAddingTimeInterval:expires_in];
    /**  NSOrderedAscending = -1L, 升序，左边<右边
     NSOrderedSame, 相等，左边＝右边
     NSOrderedDescending  降序，左边>右边
     */
    NSComparisonResult result = [expireDate compare:now];
//    HMLog(@"%@ ---- %@",now,expireDate);
    if (result != NSOrderedDescending) {// 过期
        return nil;
        
    }
    return account;
}


@end
