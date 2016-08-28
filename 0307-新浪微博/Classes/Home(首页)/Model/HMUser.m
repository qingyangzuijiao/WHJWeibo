//
//  HMUser.m
//  0307-新浪微博
//
//  Created by whj on 16/4/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  账号模型

#import "HMUser.h"

@implementation HMUser
//+(instancetype)userWithDict:(NSDictionary *)dict
//{
//    HMUser *user = [[HMUser alloc] init];
//    user.idstr = dict[@"idstr"];
//    user.name = dict[@"name"];
//    user.profile_image_url = dict[@"profile_image_url"];
//    return user;
//    
//}

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

//- (BOOL)isVip
//{
//    return self.mbtype >2;
//}

@end
