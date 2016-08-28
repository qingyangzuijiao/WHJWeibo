//
//  HMTitleMenuVC.m
//  0307-新浪微博
//
//  Created by whj on 16/4/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  下拉菜单的VC

#import "HMTitleMenuVC.h"

@implementation HMTitleMenuVC

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"首页";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"好友圈";
    }

    else if (indexPath.row == 2) {
        cell.textLabel.text = @"特别关注";
    }

    else {
        cell.textLabel.text = @"群微博";
    }
    return cell;
}

@end
