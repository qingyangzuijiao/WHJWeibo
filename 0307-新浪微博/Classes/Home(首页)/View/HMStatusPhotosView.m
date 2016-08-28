//
//  HMStatusPhotosView.m
//  0307-新浪微博
//
//  Created by whj on 16/5/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//
/** cell中图片的间距*/
#define HMStatusPhotosMargin 10
/** cell中图片的宽高*/
#define HMStatusPhotosWH 70

/** 根据图片的数量计算最大的列数，因为当是4个图片时要选择2*2的排列方式*/
#define HMStatusPhotosMaxCol(count) ((count == 4)?2:3)

#import "HMStatusPhotosView.h"
#import "HMStatusPhotoImgView.h"


@implementation HMStatusPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
/**
 *  根据图片个数创建imgView,并且为imgView设置图片，并且控制imgView的隐藏和显示
 */
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSInteger photoCount = photos.count;
    
    //创建足够数量的图片控件
    while (self.subviews.count < photoCount) { //当imgView不够用的时候
        HMStatusPhotoImgView *photoView = [[HMStatusPhotoImgView alloc] init];
        [self addSubview:photoView];
        
    }
    //当imgView足够用时
    for (int i=0; i<self.subviews.count; i++) {//这里遍历全部子控件是因为没用到的控件要去隐藏，因为考虑到cell的重用机制
        HMStatusPhotoImgView *photoView = self.subviews[i];

        if (i < photoCount) {//显示
            //给HMStatusPhotoImgView设置数据
            photoView.photo = photos[i];
            
            photoView.hidden = NO;
        }
        else {//隐藏
            photoView.hidden = YES;
        }
    }
}
/**
 *  设置子控件的位置，和尺寸
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger photoCount = self.photos.count;
    //计算控件的尺寸和位置
    for (int i =0; i < photoCount; i++) {
#warning 这个是计算位置，和前面的计算相册尺寸是不一样的所以这次可以用到九宫格的知识
        UIImageView *photoView = self.subviews[i];
        //列数
        int col = i % HMStatusPhotosMaxCol(photoCount);
        photoView.x = col * (HMStatusPhotosWH + HMStatusPhotosMargin);
        //行数
        int row = i / HMStatusPhotosMaxCol(photoCount);
        photoView.y = row * (HMStatusPhotosWH + HMStatusPhotosMargin);
        
        
        photoView.width = HMStatusPhotosWH;
        photoView.height = HMStatusPhotosWH;
        
    }
    
}

/**
 *  根据图片的个数计算控件(相册)的尺寸
 *
 *  @param count 图片的个数
 *
 *  @return 控件（相册）的尺寸
 */
+ (CGSize)sizeWithPhotosCount:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    NSUInteger maxCol = HMStatusPhotosMaxCol(count);
    //列数
    NSUInteger col = (count >= maxCol) ? maxCol : count;
    CGFloat width = col * HMStatusPhotosWH + (col - 1) * HMStatusPhotosMargin;
    //行数
#warning 计算行数的公式
    NSUInteger row = (count + maxCol - 1) / maxCol;//这个公式是计算行数的方法,很常用
    CGFloat height = row * HMStatusPhotosWH + (row - 1) * HMStatusPhotosMargin;;
    
    
    return CGSizeMake(width, height);
}


@end
