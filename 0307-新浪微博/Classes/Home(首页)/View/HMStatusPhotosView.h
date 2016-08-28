//
//  HMStatusPhotosView.h
//  0307-新浪微博
//
//  Created by whj on 16/5/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  cell中的相册控件

#import <UIKit/UIKit.h>

@interface HMStatusPhotosView : UIView
/** 存放图片模型的数组*/
@property (nonatomic, strong) NSArray *photos;
/**
 *  根据图片的个数计算控件的尺寸
 *
 *  @param count 图片的个数
 *
 *  @return 控件（相册）的尺寸
 */
+ (CGSize)sizeWithPhotosCount:(NSUInteger)count;
@end
