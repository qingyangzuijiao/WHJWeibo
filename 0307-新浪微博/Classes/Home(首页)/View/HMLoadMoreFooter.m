//
//  HMLoadMoreFooter.m
//  0307-新浪微博
//
//  Created by whj on 16/4/27.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMLoadMoreFooter.h"

@implementation HMLoadMoreFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        [label setText:@"正在加载更多"];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.centerX = ScreenWidth/2;
        label.centerY = frame.size.height/2;
        [self addSubview:label];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.size = CGSizeMake(20, 20);
        indicatorView.x = CGRectGetMaxX(label.frame) + 5;
        indicatorView.centerY = label.centerY;
//        indicatorView.hidden = NO;
        [indicatorView startAnimating];//出现时就是在转圈
        [self addSubview:indicatorView];


    }
    return self;
}

@end
