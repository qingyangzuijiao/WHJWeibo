//
//  HMDropMenu.m
//  0307-新浪微博
//
//  Created by whj on 16/3/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMDropMenu.h"

@interface HMDropMenu ()

/**
 *  将来用来显示具体内容的容器
 */
@property(weak, nonatomic) UIImageView *containerView;

@end

@implementation HMDropMenu

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];//清除颜色
    }
    return self;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}


/**
 *  显示,根据点击的控件确定位置
 */
- (void)showFrom:(UIView *)from
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    //// 4.调整灰色图片的位置
    /**
     *  1.默认情况下，frame是以父控件左上角为坐标原点 2.转换坐标系原点，改变frame的参照系
     3.为了得到传进来的控件相对于屏幕的左上角为坐标原点
     */
    CGRect newFrame = [from.superview convertRect:from.frame toView:window];//参数要分清楚
    self.containerView.y = CGRectGetMaxY(newFrame);
    self.containerView.centerX = CGRectGetMidX(newFrame);//获得传进来的控件在新坐标系下的中心点
    
    //通知自己要显示
    if ([self.delegate respondsToSelector:@selector(dropMenuDidShow:)]) {
        [self.delegate dropMenuDidShow:self];
    }
}


/*
 懒加载
 **/
- (UIImageView *)containerView
{
    if (_containerView == nil) {
        // // 添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
//        containerView.width = 217;
//        containerView.height = 217;
        
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;//开启交互
        [self addSubview:containerView];
        
        self.containerView =containerView;
    }
    return _containerView;
}




/**
 *  内容
 */
- (void)setContent:(UIView *)content
{
    _content = content;
    
    //设置内容的位置
    content.x = 10;
    content.y = 15;
    
    //设置灰色图片控件的高度
    self.containerView.height = CGRectGetMaxY(content.frame) + 10;
    //设置灰色图片控件的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    // 添加内容到灰色图片中
    [self.containerView addSubview:content];
}


/**
 *  内容控制器：当内容需要传送一个控制器时，获取控制器的view
 */
- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    self.content = contentController.view;
}

/**
 *  销毁
 */
- (void)dismiss
{
    [self removeFromSuperview];
    //通知代理方法调用代理方法
    if ([self.delegate respondsToSelector:@selector(dropMenuDidDismiss:)]) {
        [self.delegate dropMenuDidDismiss:self];
    }
}

/**
 *  监听遮盖的view点击事件，让视图消失
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}


@end
