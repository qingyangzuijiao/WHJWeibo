//
//  UIWindow+Extension.m
//  0307-新浪微博
//
//  Created by whj on 16/4/21.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "HMMainViewController.h"
#import "HMNewFeatureVC.h"

@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
        
    if ([currentVersion isEqualToString:lastVersion]) {// 版本号相同：这次打开和上次打开的是同一个版本
        
        self.rootViewController = [[HMMainViewController alloc] init];
        
    }
    else {// 这次打开的版本和上一次不一样，显示新特性
        self.rootViewController = [[HMNewFeatureVC alloc] init];
        
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];//同步一下,立即同步内存数据
    }

}


@end
