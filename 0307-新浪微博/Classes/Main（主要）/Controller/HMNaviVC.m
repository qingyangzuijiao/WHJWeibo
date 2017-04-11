//
//  HMNaviVC.m
//  0307-新浪微博
//
//  Created by whj on 16/3/20.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMNaviVC.h"

@implementation HMNaviVC

//load是只要类所在文件被引用就会被调用，而initialize是在类或者其子类的第一个方法被调用前调用。所以如果类没有被引用进项目，就不会有load调用；但即使类文件被引用进来，但是没有使用，那么initialize也不会被调用
+ (void)initialize
{
    //设置整个项目item的主题样式
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];//设置主题样式
    //UINavigationBar *naviBar = [UINavigationBar appearance];//
    //设置普通状态
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    textDict[NSForegroundColorAttributeName] = [UIColor orangeColor];//设置字体颜色
    textDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];//设置字体大小
    [barItem setTitleTextAttributes:textDict forState:UIControlStateNormal];
    
    //设置不可用状态
    NSMutableDictionary *disableTextDict = [NSMutableDictionary dictionary];
    disableTextDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];//R:127/255.0 G:127/255.0 B:127/255.0
    disableTextDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];//设置字体大小
    [barItem setTitleTextAttributes:disableTextDict forState:UIControlStateDisabled];
    
    //每一个像素都有自己的颜色，每一个颜色都能由RGB三色组成
    //12bit #f00, #0f0, #00f
    //24bit #ff0000, #00ff00, #000000
    //#ff0000 (R:255 G:0 B:0)
    //RGBA(A:alpha)
    //32bit #ff 00 00 ff
    
    
}


//重写push方法，拦截push进来的所有控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >0) {//判断此时的控制器不是第一个控制器时
        /*
         隐藏和显示BottomBar
         **/
        viewController.hidesBottomBarWhenPushed = YES;
        //设置左边的返回按钮
        
        /**
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //给按钮添加图片
        [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
        //使用UIView的分类方法
        leftButton.size = leftButton.currentBackgroundImage.size;
        [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        //设置右边的更多按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //给按钮添加图片
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] forState:UIControlStateHighlighted];
        //设置按钮的尺寸
        rightBtn.size = rightBtn.currentBackgroundImage.size;
        //给按钮添加一个点击事件
        [rightBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
         **/
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }

    //NSLog(@"viewController=%@",viewController);
    [super pushViewController:viewController animated:YES];
    
    


}
#pragma mark 跳到根控制器的方法
- (void)more
{
//    DLog(@"more");

#warning 这里是self不是self.navigationController,因为self就是navigationController
    [self popToRootViewControllerAnimated:YES];
}

#pragma mark 跳转到上个控制器的方法
- (void)back
{
//    DLog(@"back");
    [self popViewControllerAnimated:YES];
}

@end
