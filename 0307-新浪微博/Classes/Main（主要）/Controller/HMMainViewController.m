//
//  HMMainViewController.m
//  0307-新浪微博
//
//  Created by whj on 16/3/9.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//
/******************************************************************************
 
 爷爷，我想给您磕一个头，
 
 *******************************************************************************/

#import "HMMainViewController.h"
#import "HMHomeViewController.h"
#import "HMMessageCenterViewController.h"
#import "HMDiscoverViewController.h"
#import "HMProfileViewController.h"
#import "HMTabBar.h"
#import "HMComposeVC.h"

@interface HMMainViewController () <HMTabBarDelegate>

@end

@implementation HMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化子控制器
    HMHomeViewController *home= [[HMHomeViewController alloc] init];
    [self addChildVC:home Title:@"首页" andImageName:@"tabbar_home" andSelectedImageName:@"tabbar_home_selected"];
    HMMessageCenterViewController *messageCenter= [[HMMessageCenterViewController alloc] init];
    [self addChildVC:messageCenter Title:@"消息" andImageName:@"tabbar_message_center" andSelectedImageName:@"tabbar_message_center_selected"];
    HMDiscoverViewController *discover = [[HMDiscoverViewController alloc] init];
    [self addChildVC:discover Title:@"发现" andImageName:@"tabbar_discover" andSelectedImageName:@"tabbar_discover_selected"];
    HMProfileViewController *profile= [[HMProfileViewController alloc] init];
    [self addChildVC:profile Title:@"我" andImageName:@"tabbar_profile" andSelectedImageName:@"tabbar_profile_selected"];
    // 2.更换系统自带的tabbar
    HMTabBar *tabBar = [[HMTabBar alloc] init];//创建自定义类HMTabBar的对象
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];//kvc改变readonly的属性
    //self.tabBar = [[HMTabBar alloc] init];
    //3.设置tabbarButton
    /*
     [self setValue:tabBar forKeyPath:@"tabBar"];相当于self.tabBar = tabBar;
     [self setValue:tabBar forKeyPath:@"tabBar"];这行代码过后，tabBar的delegate就是HWTabBarViewController
     说明，不用再设置tabBar.delegate = self;
     */
    
    /*
     1.如果tabBar设置完delegate后，再执行下面代码修改delegate，就会报错
     tabBar.delegate = self;
     
     2.如果再次修改tabBar的delegate属性，就会报下面的错误
     错误信息：Changing the delegate of a tab bar managed by a tab bar controller is not allowed.
     错误意思：不允许修改TabBar的delegate属性(这个TabBar是被TabBarViewController所管理的)
     */

    
}

#pragma mark HMTabBarDelegate
- (void)tabBarDidClickPlusButton:(HMTabBar *)tabBar
{
    HMComposeVC *compVC = [[HMComposeVC alloc] init];
    HMNaviVC *naviVC = [[HMNaviVC alloc] initWithRootViewController:compVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

///**
// *  打印tabbar的subviews
// */
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //HMLog(@"%@",self.tabBar.subviews);
//    int count = (int)self.tabBar.subviews.count;
//    for (int i =0; i< count; i++) {
//        UIView *childView = self.tabBar.subviews[i];
//        Class class = NSClassFromString(@"UITabBarButton");//将字符串变成类
//        if ([childView isKindOfClass:class]) {
//            HMLog(@"%d",i);
//        }
//    }
//}
//
#pragma mark 创建子控制器
- (void)addChildVC:(UIViewController *)childVC Title:(NSString *)title andImageName:(NSString *)imageStr andSelectedImageName:(NSString *)selectedImageStr
{

    //设置子控制器的文字和图片
//    childVC.tabBarItem.title= title;//设置tabbar的title
//    childVC.navigationItem.title = title;//设置navigationItem的title
    childVC.title = title;//同时设置tabbar的title和navigationItem的title
    //设置样式
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HMColor(123,123,123);
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //设置样式
    NSMutableDictionary *selectedAttrs=[NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVC.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    childVC.tabBarItem.image = [UIImage imageNamed:imageStr];
    if (IOS7) {
        childVC.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//不要渲染图片
    } else {
        childVC.tabBarItem.selectedImage=[UIImage imageNamed:selectedImageStr];
    }
    
     //childVC.view.backgroundColor = HMRandomColor;//宏定义
    //先给小控制器包装一个控制器
    HMNaviVC *nav=[[HMNaviVC alloc] initWithRootViewController:childVC];
    //添加为子控制器
    [self addChildViewController:nav];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
