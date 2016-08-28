//
//  HMComposePhotosView.h
//  0307-新浪微博
//
//  Created by whj on 16/6/1.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  存放拍照或者在相册中选中图片的View

#import <UIKit/UIKit.h>

@interface HMComposePhotosView : UIView
/**
 *  为相册中添加图片
 */
- (void)addPhoto:(UIImage *)image;

//系统会自动创建setterr和getter的生命和实现，和_开头的成员变量；但是当自己重写了setter方法它就会有getter的生命和实现，和_开头的成员变量；一旦重写了setter和getter方法那么系统就不会自动生成任何方法和成员变量了
//@property (nonatomic, strong) NSArray *photos;


//相当于只有getter方法，当然系统也会给_开头的成员变量;一旦重写了getter方法，那么就不会有成员变量了
@property (nonatomic, strong, readonly) NSMutableArray *photos;

//- (NSArray *)photos;

@end
