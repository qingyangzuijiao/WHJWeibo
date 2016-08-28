//
//  HMNewFeatureVC.m
//  0307-新浪微博
//
//  Created by whj on 16/3/27.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMNewFeatureVC.h"
#import "HMMainViewController.h"
#define HMNewFeatureCount 4

@interface HMNewFeatureVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@end

@implementation HMNewFeatureVC

- (void)viewDidLoad
{
    //// 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i =0; i<HMNewFeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d",i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        //如果是最后一个imageView，就往里面添加控件
        if (i == HMNewFeatureCount - 1) {
            
            [self setupLastImageView:imageView];
        }
    }
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(HMNewFeatureCount * scrollW, 0);
    scrollView.bounces = NO;//// 去除弹簧效果
    scrollView.showsHorizontalScrollIndicator = NO;//
    scrollView.pagingEnabled = YES;//自动分页
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = HMNewFeatureCount;
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    //pageControl.userInteractionEnabled = NO;
    pageControl.currentPageIndicatorTintColor = HMColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = HMColor(189, 189, 189);
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    // UIPageControl就算没有设置尺寸，里面的内容还是照常显示的
    //    pageControl.width = 100;
    //    pageControl.height = 50;

}

#pragma mark 初始化最后一个imageView
- (void)setupLastImageView:(UIImageView *)imageView
{
    //使最后一个imageView能够交互
    imageView.userInteractionEnabled = YES;
    //1.分享给大家：checkbox
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareButton setTitle:@"分享到大家" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
    shareButton.width = 200;
    shareButton.height = 30;
    shareButton.centerX = imageView.width * 0.5;
    shareButton.centerY = imageView.height * 0.65;
    [shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareButton];
    //shareButton.backgroundColor = [UIColor redColor];
    // top left bottom right
    
    // EdgeInsets: 自切
    // contentEdgeInsets:会影响按钮内部的所有内容（里面的imageView和titleLabel）
    //    shareBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 100, 0, 0);
    
    // titleEdgeInsets:只影响按钮内部的titleLabel
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // imageEdgeInsets:只影响按钮内部的imageView
    //    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 50);


    //2.开始微博
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton setTitle:@"开始微博" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startButton.size = startButton.currentBackgroundImage.size;//等于背景图片的尺寸
    startButton.centerX = shareButton.centerX;
    startButton.centerY = shareButton.centerY + 35;
    [startButton addTarget:self action:@selector(beginClick) forControlEvents:UIControlEventTouchUpInside];

    [imageView addSubview:startButton];
    
}
#pragma mark开始微博
- (void)beginClick
{
    // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[HMMainViewController alloc] init];
    
}

-(void)dealloc
{
    HMLog(@"HMMainViewController-delloc");
}

#pragma mark 分享按钮
- (void)shareClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

/*
 1.程序启动会自动加载叫做Default的图片
 1> 3.5inch 非retain屏幕：Default.png
 2> 3.5inch retina屏幕：Default@2x.png
 3> 4.0inch retain屏幕: Default-568h@2x.png
 
 2.只有程序启动时自动去加载的图片, 才会自动在4inch retina时查找-568h@2x.png
 */


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //HMLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    double page = scrollView.contentOffset.x / scrollView.width;
    //四舍五入计算当前的页数
    self.pageControl.currentPage = (int)(page + 0.5);
}

- (instancetype)init
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

@end
