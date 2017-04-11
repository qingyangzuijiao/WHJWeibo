//
//  HMTest1ViewController.m
//  0307-新浪微博
//
//  Created by whj on 16/3/10.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMTest1ViewController.h"
#import "HMTest2ViewController.h"
@interface HMTest1ViewController ()

@end

@implementation HMTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark 跳到下一个控制器
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HMTest2ViewController *test2VC = [[HMTest2ViewController alloc] init];
    test2VC.title = @"测试2控制器";
    [self.navigationController pushViewController:test2VC animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //给按钮添加图片
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
//    //设置按钮的尺寸
////    CGSize size = leftButton.currentBackgroundImage.size;
////    leftButton.frame = CGRectMake(0, 0, size.width, size.height);
//    leftButton.size = leftButton.currentBackgroundImage.size;//使用UIView的分类方法
//
//    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];//给按钮添加一个点击事件
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//
//
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //给按钮添加图片
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] forState:UIControlStateHighlighted];
//    //设置按钮的尺寸
//    rightBtn.size = rightBtn.currentBackgroundImage.size;//使用UIView的分类方法
//    //给按钮添加一个点击事件
//    [rightBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//
//}
//#pragma mark 跳到根控制器的方法
//- (void)more
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//#pragma mark 返回按钮
//- (void)back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//



@end
