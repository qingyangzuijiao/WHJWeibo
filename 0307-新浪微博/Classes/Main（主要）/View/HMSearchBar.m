//
//  HMSearchBar.m
//  0307-新浪微博
//
//  Created by whj on 16/3/22.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

//  继承于UITextField

#import "HMSearchBar.h"

@implementation HMSearchBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:13];
        self.placeholder = @"搜索";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.height = 30;
        searchIcon.width = 30;
        searchIcon.contentMode = UIViewContentModeCenter;////让图标居中显示default is UIViewContentModeScaleToFill
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;//default is UITextFieldViewModeNever

        
    }
    
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}


@end
