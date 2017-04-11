//
//  HMMessageCenterViewController.m
//  0307-新浪微博
//
//  Created by whj on 16/3/9.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMMessageCenterViewController.h"
#import "HMTest1ViewController.h"
@interface HMMessageCenterViewController ()

@end

@implementation HMMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //style：是用来设置背景的，在iOS7之前比较明显
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
    //这个item不能点击（就能显示disable状态下的主题）
    self.navigationItem.rightBarButtonItem.enabled = NO;
    HMLog(@"HMMessageCenterViewController-viewDidLoad");

   
}


- (void)composeMsg
{
    HMLog(@"composeMsg");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"hm";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.textLabel.text= [NSString stringWithFormat:@"test----%ld",indexPath.row];
    
    return cell;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTest1ViewController *test1=[[HMTest1ViewController alloc] init];
    test1.title = @"测试一";
   // test1.hidesBottomBarWhenPushed = YES;//当test1控制器被push的时候，test1所在的tabbaController的tabbar会自动隐藏；当test1控制器被pop的时候，test1所在的tabbaController的tabbar会自动显示
    
    NSLog(@"navigationController=%@",self.navigationController);
    [self.navigationController pushViewController:test1 animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
