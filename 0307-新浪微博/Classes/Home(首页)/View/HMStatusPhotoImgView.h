//
//  HMStatusPhotoImgView.h
//  0307-新浪微博
//
//  Created by whj on 16/5/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  一张配图

#import <UIKit/UIKit.h>
@class HMPhoto;
@interface HMStatusPhotoImgView : UIImageView
/** photo模型*/
@property (nonatomic, strong)HMPhoto *photo;
@end
