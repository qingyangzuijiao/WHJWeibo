//
//  AppDelegate.m
//  0307-新浪微博
//
//  Created by whj on 16/3/7.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "AppDelegate.h"
#import "HMOAuthVC.h"
#import "HMAccountTool.h"
#import <SDWebImageManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //    NSLog(@"%@",path);
    
    if (@available(iOS 13.0, *)) {
        
    } else {
        //创建窗口
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //获取账号信息
        HMAccount *account = [HMAccountTool account];
                if (account) {// 之前已经登录成功过
            //设置根控制器
            [self.window switchRootViewController];
        }
        
        else {//没有登陆过
            self.window.rootViewController = [[HMOAuthVC alloc] init];//授权
        }
        //显示窗口
        [self.window makeKeyAndVisible];
    }
    return YES;
}

#pragma mark - UISceneSession lifecycle
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
/**
 *  程序进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        
        // 赶紧结束任务
        [application endBackgroundTask:task];
        
    }];
    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay；  是为了能够让程序长时间的在后台运行
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    /**
     *   以前的后台模式只有3种
     *   保持网络连接
     *   多媒体应用
     *   VOIP:网络电话
     */
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark 内存警告时
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // 1.取消下载
    [manager cancelAll];
    // 2.清除内存中的所有图片
    [manager.imageCache clearMemory];
}

//    UIViewController *viewcontroller1=[[UIViewController alloc] init];
//    viewcontroller1.view.backgroundColor = HMRandomColor;//宏定义
//    viewcontroller1.tabBarItem.title=@"首页";
//    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = HMColor(123, 123, 123);
//    [viewcontroller1.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    NSMutableDictionary *selectedAttrs=[NSMutableDictionary dictionary];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    [viewcontroller1.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//    viewcontroller1.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
//    UIImage *homeSelectedImage=[UIImage imageNamed:@"tabbar_home_selected"];
//    homeSelectedImage =[homeSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//不要渲染图片
//    viewcontroller1.tabBarItem.selectedImage = homeSelectedImage;
//
//    UIViewController *viewcontroller2=[[UIViewController alloc] init];
//    viewcontroller2.view.backgroundColor = HMRandomColor;//宏定义
//    viewcontroller2.tabBarItem.title = @"消息";
//    [viewcontroller2.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [viewcontroller2.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//    viewcontroller2.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_center"];
//    viewcontroller2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_message_center_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    UIViewController *viewcontroller3=[[UIViewController alloc] init];
//    viewcontroller3.view.backgroundColor = HMRandomColor;//宏定义
//    viewcontroller3.tabBarItem.title = @"发现";
//    [viewcontroller3.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [viewcontroller3.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//    viewcontroller3.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
//    viewcontroller3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//
//    UIViewController *viewcontroller4=[[UIViewController alloc] init];
//    viewcontroller4.view.backgroundColor = HMRandomColor;//宏定义
//    viewcontroller4.tabBarItem.title = @"我";
//    [viewcontroller4.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [viewcontroller4.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//    viewcontroller4.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
//    viewcontroller4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    //  重复代码抽取到一个方法中
//    // 1.相同的代码放到一个方法中
//    // 2.不同的代码变成参数
//    // 3.使用这段代码的时候调用方法并设置参数




//子控制器
//    HMHomeViewController *home= [[HMHomeViewController alloc] init];
//    [self addChildVC:home Title:@"首页" andImageName:@"tabbar_home" andSelectedImageName:@"tabbar_home_selected"];
//    HMMessageCenterViewController *messageCenter= [[HMMessageCenterViewController alloc] init];
//    [self addChildVC:messageCenter Title:@"消息" andImageName:@"tabbar_message_center" andSelectedImageName:@"tabbar_message_center_selected"];
//    HMDiscoverViewController *discover = [[HMDiscoverViewController alloc] init];
//    [self addChildVC:discover Title:@"发现" andImageName:@"tabbar_discover" andSelectedImageName:@"tabbar_discover_selected"];
//    HMProfileViewController *profile= [[HMProfileViewController alloc] init];
//    [self addChildVC:profile Title:@"我" andImageName:@"tabbar_profile" andSelectedImageName:@"tabbar_profile_selected"];
//
//    [tabbar addChildViewController:home];
//    [tabbar addChildViewController:messageCenter];
//    [tabbar addChildViewController:discover];
//    [tabbar addChildViewController:profile];
//    //tabbar.viewControllers = @[vc1, vc2, vc3, vc4];




//#pragma mark 创建子控制器
//- (void)addChildVC:(UIViewController *)childVC Title:(NSString *)title andImageName:(NSString *)imageStr andSelectedImageName:(NSString *)selectedImageStr
//{
//
//    //设置子控制器的文字和图片
//    childVC.view.backgroundColor = HMRandomColor;//宏定义
//    childVC.tabBarItem.title= title;
//    //设置样式
//    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = HMColor(123, 123, 123);
//    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    //设置样式
//    NSMutableDictionary *selectedAttrs=[NSMutableDictionary dictionary];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    [childVC.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//
//    childVC.tabBarItem.image = [UIImage imageNamed:imageStr];
//    childVC.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//不要渲染图片
//
//}


@end
