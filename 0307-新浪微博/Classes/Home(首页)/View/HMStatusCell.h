//
//  HMStatusCell.h
//  0307-新浪微博
//
//  Created by whj on 16/5/11.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  微博cell

#import <UIKit/UIKit.h>
@class HMStatusFrame;

@interface HMStatusCell : UITableViewCell
/**
 *  类方法创建cell
 */
+ (instancetype)statusCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) HMStatusFrame *statusFrame;

@end
