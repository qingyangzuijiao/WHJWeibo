//
//  HMEmotionListView.m
//  0307-新浪微博
//
//  Created by whj on 16/6/5.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//
/** 每页能够显示的最大表情数*/
#define HMPageMaxNumber 20

#import "HMEmotionListView.h"
#import "HMPageView.h"


@interface HMEmotionListView () <UIScrollViewDelegate>
/** 滚动视图*/
@property(nonatomic, weak) UIScrollView *scrollView;
/** 分页控制器*/
@property(nonatomic, weak) UIPageControl *pageCtrl;

@end

@implementation HMEmotionListView

//- (instancetype)init
//{
//    if (self = [super init]) {
//        self.backgroundColor = HMRandomColor;
//    }
//    return self;
//}
#pragma mark -init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //创建scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
//        scrollView.backgroundColor = [UIColor redColor];
        //去除水平滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        //去除垂直滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        //能否翻页
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        
        //创建分页控制器pagectrl
        UIPageControl *pageCtrl = [[UIPageControl alloc] init];
        //当pageCtrl只有一页时，隐藏下面的圆点
        pageCtrl.hidesForSinglePage = YES;
        pageCtrl.userInteractionEnabled = NO;
        //为pageControl的圆点设置自定义图片
        [pageCtrl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageCtrl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
//        pageCtrl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
//        pageCtrl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
        [self addSubview:pageCtrl];
        self.pageCtrl = pageCtrl;
        
    }
    return self;
}

/**
 *  根据emotions，创建相应个数的表情页
 */
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    //删除之前的控件
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    DLog(@"emotions");
    NSInteger emotionsCount = emotions.count;

    //1.设置pageCtrl的页数
    self.pageCtrl.numberOfPages = (emotionsCount + HMPageMaxNumber - 1) / HMPageMaxNumber;
    
    
    //2.创建每页按钮的容器,显示表情
    for (int i=0; i<self.pageCtrl.numberOfPages; i++) {
        HMPageView *containerView = [[HMPageView alloc] init];
//        containerView.backgroundColor = HMRandomColor;
        NSRange range;
        range.location = i * HMPageMaxNumber;
        //剩下的表情数量
        NSInteger remain = emotionsCount - range.location;
        if (remain >= HMPageMaxNumber) {
            range.length = HMPageMaxNumber;
        }
        else {
            range.length = remain;
        }
        
        //设置这一页的表情
        containerView.emotions = [emotions subarrayWithRange:range];
        
        [self.scrollView addSubview:containerView];
    }
    
    //重新计算尺寸
    [self setNeedsLayout];

    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1.pageCtrl
    self.pageCtrl.x = 0;
    self.pageCtrl.height = 35;
    self.pageCtrl.width = self.width;
    self.pageCtrl.y = self.height - self.pageCtrl.height;
    
    //2.scrollView
    self.scrollView.x = 0;
    self.scrollView.y = 0;
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageCtrl.y;
    
    
    NSInteger pageNumber = self.scrollView.subviews.count;
    //3.containerView,设置scrollView中每一页的尺寸
    for (int i=0; i<pageNumber; i++) {
        
        UIView *containerView = self.scrollView.subviews[i];
//        if ([containerView isKindOfClass:[UIImageView class]])  continue;//判断是否是滚动条视图
        containerView.y = 0;
        containerView.width = self.scrollView.width;
        containerView.height = self.scrollView.height;
        containerView.x = containerView.width * i;
        
    }
    
    //4.设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(pageNumber * self.scrollView.width, 0);
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNow = scrollView.contentOffset.x / self.scrollView.width;
    self.pageCtrl.currentPage = (int)(pageNow + 0.5);
}


@end
