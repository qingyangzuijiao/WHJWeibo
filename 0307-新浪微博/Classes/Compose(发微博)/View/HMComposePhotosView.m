//
//  HMComposePhotosView.m
//  0307-新浪微博
//
//  Created by whj on 16/6/1.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMComposePhotosView.h"

@interface HMComposePhotosView ()
//@property (nonatomic, strong) NSMutableArray *addedPhotos;
@end

@implementation HMComposePhotosView

//- (NSMutableArray *)images
//{
//    if (_images == nil) {
//        _images = [NSMutableArray array];
//    }
//    return _images;
//}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}
/**
 *  添加图片
 */
- (void)addPhoto:(UIImage *)image
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    
    [_photos addObject:image];
    
//    DLog(@"%@",_photos);
    
    [self addSubview:imgView];
}
/**
 *  设置所有子控件的位置和大小
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    NSUInteger maxCol = 3;
    CGFloat margin = 10;
    CGFloat imageViewWH = (self.width - margin * (maxCol + 1)) / 3;
    for (int i=0; i<count; i++) {
        UIImageView *imageView = self.subviews[i];
        int col = i % maxCol;
        int row = i / maxCol;
        
        CGFloat imageViewX = margin + (margin + imageViewWH) * col;
        CGFloat imageViewY = margin + (margin + imageViewWH) * row;
               imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWH, imageViewWH);
    }
    
}

//- (NSArray *)photos
//{
//    
//    for (UIImageView *imageView in self.subviews) {
//        UIImage *image = imageView.image;
//        [_images addObject:image];
//    }
//    return _images;
//}

@end
