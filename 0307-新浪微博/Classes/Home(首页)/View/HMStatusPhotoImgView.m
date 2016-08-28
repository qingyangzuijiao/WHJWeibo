//
//  HMStatusPhotoImgView.m
//  0307-新浪微博
//
//  Created by whj on 16/5/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMStatusPhotoImgView.h"
#import <UIImageView+WebCache.h>
#import "HMPhoto.h"

@interface HMStatusPhotoImgView ()
@property (nonatomic, weak) UIImageView *imgView;
@end

@implementation HMStatusPhotoImgView
/**
 *  gif控件
 */
- (UIImageView *)imgView
{
    if (!_imgView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        self.imgView = imgView;
        [self addSubview:self.imgView];
    }
    return _imgView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /**
         UIViewContentModeScaleToFill : 图片拉伸至填充整个UIImageView（图片可能会变形）
         
         UIViewContentModeScaleAspectFit : 图片拉伸至完全显示在UIImageView里面为止（图片不会变形）
         
         UIViewContentModeScaleAspectFill :
         图片拉伸至 图片的宽度等于UIImageView的宽度 或者 图片的高度等于UIImageView的高度 为止
         
         UIViewContentModeRedraw : 调用了setNeedsDisplay方法时，就会将图片重新渲染
         
         UIViewContentModeCenter : 居中显示
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         
         经验规律：
         1.凡是带有Scale单词的，图片都会拉伸
         2.凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形
         */
        
        //内容模式，让图片不会拉伸难看，按照原来的宽高比，充斥整个控件，超出的就要剪掉
        self.contentMode = UIViewContentModeScaleAspectFill;
        //超出边框范围就会被裁剪掉
        self.clipsToBounds = YES;
    }
    return self;
}
/**
 *  给配图控件下载,设置显示\隐藏gif标记
 */
- (void)setPhoto:(HMPhoto *)photo
{
    _photo = photo;
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    
//    if ([photo.thumbnail_pic hasSuffix:@"gif"]) {
//        self.imgView.hidden = NO;
//    }
//    else {
//        self.imgView.hidden = YES;
//    }
    //无论是GIF还是gif结尾的都能正确的判断显示／隐藏gif控件
    self.imgView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}


/**
 *  给gif控件设置位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.x = self.width - self.imgView.width;
    self.imgView.y = self.height - self.imgView.height;
}

@end
