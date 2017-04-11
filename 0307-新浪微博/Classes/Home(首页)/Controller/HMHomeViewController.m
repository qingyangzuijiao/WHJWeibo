//
//  HMHomeViewController.m
//  0307-新浪微博
//
/***********************************************************************************************
                          今天是母亲节，祝妈妈节日快乐！身体健康   2016.5.8
***********************************************************************************************/


//  Created by whj on 16/3/9.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  2016.8.29完成，只有图文混排没有集成进去


#import "HMHomeViewController.h"
#import "HMHttpRequestTool.h"
#import "HMAccountTool.h"
#import "HMTitleButton.h"
#import "HMTitleMenuVC.h"
#import <UIImageView+WebCache.h>
#import "HMUser.h"
#import "HMStatus.h"
#import <MJExtension.h>
#import "HMLoadMoreFooter.h"
#import "HMStatusCell.h"
#import "HMStatusFrame.h"


@interface HMHomeViewController () <HMDropMenuDelegate>
/**
 *  微博数组（里面放的都是HMStatusFrame对象，一个HMStatusFrame对象代表一个微博）
 */
@property(strong, nonatomic) NSMutableArray *statusesFrame;
@end

@implementation HMHomeViewController

- (NSMutableArray *)statusesFrame
{
    if (_statusesFrame == nil) {
        _statusesFrame = [NSMutableArray array];
    }
    return _statusesFrame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    DLog(@"viewDidAppear----%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

// 得到当前屏幕的Retina系数
//    HMLog(@"%f",[UIScreen mainScreen].scale);

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HMColor(211, 211, 211);
    //设置tableView整体缩进:为了让tableView最上方留出一个距离
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
//    DLog(@"viewDidLoad----%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
//    HMLog(@"ScreenHeight = %f,ScreenWidth = %f",ScreenHeight,ScreenWidth);
//    HMLog(@"view.frame.height = %f,view.frame.width = %f",self.tableView.height,self.tableView.width);
    // 设置导航栏的内容
    [self setupNav];
    
    // 获取用户信息（用户信息）
    [self setupUserInfo];
    
    // 加载微博数据
//    [self loadNewStatues];
    
    //集成下拉刷新控件
    [self setupDownRefresh];
    
    //集成上拉刷新控件
    [self setupUpRefresh];
    
    //获取未读数,10s获取一次
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadUnreadMessageCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  集成下拉刷新
 */
#pragma mark 集成下拉刷新控件
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    // 只有用户通过手动下拉刷新，才会触发UIControlEventValueChanged事件
    [refreshControl addTarget:self action:@selector(refreshDidChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
    // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [refreshControl beginRefreshing];
    
    // 3.马上加载数据
    [self refreshDidChange:refreshControl];
}
/**
 *  下拉刷新时调用的方法
 */
#pragma mark refresh改变
- (void)refreshDidChange:(UIRefreshControl *)refresh
{
    HMAccount *account = [HMAccountTool account];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;

    // 取出最前面的微博（最新的微博，ID最大的微博）
    HMStatusFrame *firstStatusFrame = [self.statusesFrame firstObject];
    if (firstStatusFrame) {
        //若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        parameters[@"since_id"] = firstStatusFrame.status.idstr;
    }


    //    parameters[@"count"] = @(2);

    [HMHttpRequestTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters success:^(id json) {
        //字典数组转换成模型数组
        NSArray *newStatus = [HMStatus mj_objectArrayWithKeyValuesArray:json[@"statuses"]];
            //从服务器返回的字典直接转换成想要的plist格式保存下来
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"statuses"] = [HMStatus mj_keyValuesArrayWithObjectArray:newStatus];//通过模型数组转换成字典数组
//        dict[@"total_number"] = json[@"total_number"];
//        [dict writeToFile:@"Users/whj/Desktop/fakeStatus.plist" atomically:YES];
//        return ;
        HMLog(@"本次更新%ld条微博",newStatus.count);
        //        HMLog(@"%@",responseObject);
        //将数据模型HMStatus数组转换成HMStatusFrame模型数组
        NSMutableArray *newStatusFrameArray = [self statusesFrameFromStatusArray:newStatus];

        //将新的数组插入到数组的最前面
        NSRange range = NSMakeRange(0, newStatus.count);
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
        [self.statusesFrame insertObjects:newStatusFrameArray atIndexes:indexSet];
        //刷新表格
        [self.tableView reloadData];

        //隐藏refresh
        [refresh endRefreshing];

        [self showNewStatusLabel:newStatus.count];

    } failure:^(NSError *error) {
        //隐藏refresh
        [refresh endRefreshing];
        HMLog(@"%@",error);
    }];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    
//    HMAccount *account = [HMAccountTool account];
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"access_token"] = account.access_token;
//    
//    // 取出最前面的微博（最新的微博，ID最大的微博）
//    HMStatusFrame *firstStatusFrame = [self.statusesFrame firstObject];
//    if (firstStatusFrame) {
//        //若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
//        parameters[@"since_id"] = firstStatusFrame.status.idstr;
//    }
//    
//    
//    //    parameters[@"count"] = @(2);
//    
//    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
////        HMLog(@"downloadProgress = %@",downloadProgress);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //字典数组转换成模型数组
//        NSArray *newStatus = [HMStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//        HMLog(@"本次更新%ld条微博",newStatus.count);
////        HMLog(@"%@",responseObject);
//        //将数据模型HMStatus数组转换成HMStatusFrame模型数组
//        NSMutableArray *newStatusFrameArray = [self statusesFrameFromStatusArray:newStatus];
//        
//        //将新的数组插入到数组的最前面
//        NSRange range = NSMakeRange(0, newStatus.count);
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
//        [self.statusesFrame insertObjects:newStatusFrameArray atIndexes:indexSet];
//        //刷新表格
//        [self.tableView reloadData];
//   
//        //隐藏refresh
//        [refresh endRefreshing];
//        
//        [self showNewStatusLabel:newStatus.count];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //隐藏refresh
//        [refresh endRefreshing];
//        HMLog(@"%@",error);
//    }];

}

/**
 *  将数据模型HMStatus转换成HMStatusFrame模型
 */
- (NSMutableArray *)statusesFrameFromStatusArray:(NSArray *)statusArray
{
    NSMutableArray *newStatusFrameArray = [NSMutableArray array];
    //将数据模型HMStatus转换成HMStatusFrame模型
    for (HMStatus *status in statusArray) {
        HMStatusFrame *frame = [[HMStatusFrame alloc] init];
        frame.status = status;
        [newStatusFrameArray addObject:frame];
    }
    return newStatusFrameArray;
}


/**
 *  集成上拉刷新
 */
#pragma mark 集成上拉刷新
- (void)setupUpRefresh
{
    HMLoadMoreFooter *footer = [[HMLoadMoreFooter alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}
/**
 *  加载更多微博
 */
- (void)loadMoreStatuses
{
    
    HMAccount *account = [HMAccountTool account];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;

    // // 取出最后面的微博（最新的微博，ID最大的微博）
    HMStatusFrame *lastStatusFrame = [self.statusesFrame lastObject];
    if (lastStatusFrame) {
        //max_id 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        long long maxId = lastStatusFrame.status.idstr.longLongValue - 1;
        parameters[@"max_id"] = @(maxId);
    }
    
    
    [HMHttpRequestTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters success:^(id json) {
        //字典数组转换成模型数组
        NSArray *newStatus = [HMStatus mj_objectArrayWithKeyValuesArray:json[@"statuses"]];
        HMLog(@"加载了%ld条微博",newStatus.count);

        NSMutableArray *newStatusFrameArray = [self statusesFrameFromStatusArray:newStatus];

        //将新的数组插入到数组的最后面
        [self.statusesFrame addObjectsFromArray:newStatusFrameArray];

        //刷新表格
        [self.tableView reloadData];

        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;

    } failure:^(NSError *error) {
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        HMLog(@"%@",error);

    }];
    
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    
//    HMAccount *account = [HMAccountTool account];
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"access_token"] = account.access_token;
//    
//    // // 取出最后面的微博（最新的微博，ID最大的微博）
//    HMStatusFrame *lastStatusFrame = [self.statusesFrame lastObject];
//    if (lastStatusFrame) {
//        //max_id 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
//        long long maxId = lastStatusFrame.status.idstr.longLongValue - 1;
//        parameters[@"max_id"] = @(maxId);
//    }
//    
//    
//    //    parameters[@"count"] = @(2);
//    // 发送请求
//    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//        //        HMLog(@"downloadProgress = %@",downloadProgress);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //字典数组转换成模型数组
//        NSArray *newStatus = [HMStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//        HMLog(@"加载了%ld条微博",newStatus.count);
//        
//        NSMutableArray *newStatusFrameArray = [self statusesFrameFromStatusArray:newStatus];
//        
//        //将新的数组插入到数组的最后面
//        [self.statusesFrame addObjectsFromArray:newStatusFrameArray];
//        
//        //刷新表格
//        [self.tableView reloadData];
//        
//        // 结束刷新(隐藏footer)
//        self.tableView.tableFooterView.hidden = YES;
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        // 结束刷新(隐藏footer)
//        self.tableView.tableFooterView.hidden = YES;
//        HMLog(@"%@",error);
//        
//    }];

}

#pragma mark 获取未读消息个数
- (void)loadUnreadMessageCount
{
    //1.请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    HMAccount *account = [HMAccountTool account];
    //    access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    parameters[@"access_token"] = account.access_token;
    //    uid	true	int64	需要获取消息未读数的用户UID，必须是当前登录用户。
    parameters[@"uid"] = account.uid;
    
    [HMHttpRequestTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:parameters success:^(id json) {
        // 微博的未读数
        //        int status = [responseObject[@"status"] intValue];
        // 设置提醒数字
        //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];

        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数) description  能够将数字对象转换成字符串
        NSString *status = [json[@"status"] description];

        if ([status isEqualToString:@"0"]) {//没有未读消息时
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        else {// 非0情况

            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }

    } failure:^(NSError *error) {
        HMLog(@"请求失败:%@",error);
    }];

//    //1.请求管理者
//    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
//    //2.请求参数
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    HMAccount *account = [HMAccountTool account];
////    access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
//    parameters[@"access_token"] = account.access_token;
////    uid	true	int64	需要获取消息未读数的用户UID，必须是当前登录用户。
//    parameters[@"uid"] = account.uid;
//    
//    //3.发送请求
//    [sessionMgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
////        status	int	新微博未读数
////        follower	int	新粉丝数
////        cmt	int	新评论数
////        dm	int	新私信数
////        mention_status	int	新提及我的微博数
////        mention_cmt	int	新提及我的评论数
////        HMLog(@"%@",responseObject);
////        HMLog(@"statusCount = %@",responseObject[@"status"]);
//        //        // 微博的未读数
//        //        int status = [responseObject[@"status"] intValue];
//        // 设置提醒数字
//        //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];
//        
//        // @20 --> @"20"
//        // NSNumber --> NSString
//        // 设置提醒数字(微博的未读数) description  能够将数字对象转换成字符串
//        NSString *status = [responseObject[@"status"] description];
//        
//        if ([status isEqualToString:@"0"]) {//没有未读消息时
//            self.tabBarItem.badgeValue = nil;
//            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//        }
//        else {// 非0情况
//            
//            self.tabBarItem.badgeValue = status;
//            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        HMLog(@"请求失败:%@",error);
//        
//    }];
}


/**
 *  显示更新微博的状态栏
*/
#pragma mark 显示更新微博的状态栏
- (void)showNewStatusLabel:(NSInteger)count
{
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    UILabel *label = [[UILabel alloc] init];
    label.width = ScreenWidth;
    label.height = 30;
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    label.x = 0;
    label.y = 64 - label.height;
    NSString *text = [NSString stringWithFormat:@"%ld 条新微博",count];
    label.text = (count!=0)?text:@"暂时没有新的动态";
    label.textAlignment = NSTextAlignmentCenter;
    //设置动画
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        
//        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
        
    } completion:^(BOOL finished) {
        
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            
//            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            [label removeFromSuperview];
            
        }];
    }];
}

/**
 *  设置导航栏内容
 */
#pragma mark 设置导航栏内容
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    //设置左边的返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted" ];
    //设置右边的更多按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted" ];
    HMLog(@"HMHomeViewController-viewDidLoad");
    
    //创建标题的中间按钮
    HMTitleButton *titleButton = [[HMTitleButton alloc] init];
    NSString *name= [HMAccountTool account].name;
    
    //设置图片和文字
    [titleButton setTitle:(name)?name:@"首页" forState:UIControlStateNormal];
//    HMLog(@"%f %f",titleButton.titleLabel.x,titleButton.imageView.x);
//    [titleButton layoutSubviews];
    
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.titleView = titleButton;
    
    /**
     * 
     * 如果图片的某个方向上不规则，比如有突起，那么这个方向就不能拉伸
     * 什么情况下建议使用imageEdgeInsets、titleEdgeInsets
     * 如果按钮内部的图片、文字固定，用这2个属性来设置间距，会比较简单

     */
    //    titleButton.titleLabel.alpha = 0.3;
    //    CGFloat titleLabelWidth = titleButton.titleLabel.width;
    //    CGFloat imageViewWidth = titleButton.imageView.width;
    //    HMLog(@"titleLabelWidth = %f,imageViewWidth = %f ",titleLabelWidth,imageViewWidth);
    //    //乘上scale系数，保证retina屏幕上的图片宽度是正确的
    //    CGFloat left = imageViewWidth * [UIScreen mainScreen].scale + titleLabelWidth * [UIScreen mainScreen].scale;// 向左的偏移量，因为imageEdgeInsets里面接收的是像素
    //    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);//top, left, bottom, right
    //    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageViewWidth);

}

/**
 *  设置用户信息
 */
#pragma mark 设置用户信息
- (void)setupUserInfo
{
    // 得到账号,拼接参数
    HMAccount *account = [HMAccountTool account];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"access_token"] = account.access_token;
    parameter[@"uid"] = account.uid;

    [HMHttpRequestTool get:@"https://api.weibo.com/2/users/show.json" parameters:parameter success:^(id json) {
//        HMLog(@"%@",responseObject);

        //标题按钮
        UIButton *userNameBtn = (UIButton *)self.navigationItem.titleView;
//        NSString *name = responseObject[@"name"];
//        HMUser *user = [HMUser userWithDict:responseObject];
        //字典转模型
        HMUser *user = [HMUser mj_objectWithKeyValues:json];
        [userNameBtn setTitle:user.name forState:UIControlStateNormal];

        [userNameBtn layoutSubviews];

        //将昵称存入沙盒
        account.name = user.name;
        [HMAccountTool saveAccount:account];

    } failure:^(NSError *error) {
        HMLog(@"%@",error);
    }];
    
//    //1.请求管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    // 得到账号,拼接参数
//    HMAccount *account = [HMAccountTool account];
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    parameter[@"access_token"] = account.access_token;
//    parameter[@"uid"] = account.uid;
//    
//    //3.发送请求
//    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        HMLog(@"%@",responseObject);
//        
//        //标题按钮
//        UIButton *userNameBtn = (UIButton *)self.navigationItem.titleView;
////        NSString *name = responseObject[@"name"];
////        HMUser *user = [HMUser userWithDict:responseObject];
//        //字典转模型
//        HMUser *user = [HMUser mj_objectWithKeyValues:responseObject];
//        [userNameBtn setTitle:user.name forState:UIControlStateNormal];
//        
//        [userNameBtn layoutSubviews];
//        
//        //将昵称存入沙盒
//        account.name = user.name;
//        [HMAccountTool saveAccount:account];
//        
//    
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        HMLog(@"%@",error);
//    }];
}



/**
 *  标题点击
 */
/**
 // 这样获得的窗口，是目前显示在屏幕最上面的窗口
 UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
 // 添加蒙板（用于拦截灰色图片外面的点击事件）
 UIView *cover = [[UIView alloc] init];
 cover.frame = window.bounds;
 cover.backgroundColor = [UIColor clearColor];
 [window addSubview:cover];
 
 // 添加带箭头的灰色图片
 UIImageView *dropdownMenu = [[UIImageView alloc] init];
 dropdownMenu.width = 217;
 dropdownMenu.height = 217;
 dropdownMenu.y = 48;
 dropdownMenu.x= (window.bounds.size.width-dropdownMenu.width)/2;
 dropdownMenu.image = [UIImage imageNamed:@"popover_background"];
 [window addSubview:dropdownMenu];
 **/
#pragma mark 标题点击
- (void)titleClick:(UIButton *)titleButton
{
    //1.显示下拉菜单
    HMDropMenu *menu = [HMDropMenu menu];
    
    menu.delegate = self;
    //2.设置内容
    HMTitleMenuVC *vc = [[HMTitleMenuVC alloc] initWithStyle:UITableViewStylePlain];
    vc.view.height = 44 * 4;
    vc.view.width = 150;//宽度要注意，不能拉神过度
    menu.contentController = vc;
    //3.显示：在点击的控件下显示
    [menu showFrom:titleButton];//根据点击的控件来确定显示的位置
        
    
}

#pragma mark HMDropMenuDelegate
/**
 *  显示向上的箭头
 */
- (void)dropMenuDidShow:(HMDropMenu *)menu
{
    UIButton *button = (UIButton *)self.navigationItem.titleView;
    button.selected = YES;
    //[button setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];

}
/**
 *  显示向下的箭头
 */
- (void)dropMenuDidDismiss:(HMDropMenu *)menu
{
    UIButton *button = (UIButton *)self.navigationItem.titleView;
    button.selected = NO;
    //[button setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];

    
}

#pragma mark 首页左上角按钮的点击事件
- (void)friendSearch
{
    HMLog(@"friendSearch");
}
#pragma mark 首页右上角按钮的点击事件
- (void)pop
{
    HMLog(@"pop");
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.statusesFrame.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建cell
    HMStatusCell *cell = [HMStatusCell statusCellWithTableView:tableView];
    
    //给cell传递模型数据
    cell.statusFrame = self.statusesFrame[indexPath.row];
    
    
    return cell;
    
}

#pragma mark UITableViewDelegate
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMStatusFrame *statuesFrame = self.statusesFrame[indexPath.row];
    return statuesFrame.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    HMLog(@"scrollViewHeight = %f,scrollViewWidth = %f",scrollView.height,scrollView.width);
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusesFrame.count == 0 || self.tableView.tableFooterView.isHidden == NO) {
        return;
    }
    //
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - self.tableView.height - self.tableView.tableFooterView.height;
    
    if (offsetY >= judgeOffsetY) {// 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatuses];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DLog(@"didSelectRowAtIndexPath------%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
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

//#pragma mark 创建UIBarButtonItem
//- (UIBarButtonItem *)itemWithimage:(NSString *)image highImage:(NSString *)highImage action:(SEL)action
//{
//    //设置左边的返回按钮
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //给按钮添加图片
//    [leftButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [leftButton setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    //使用UIView的分类方法,设置尺寸
//    leftButton.size = leftButton.currentBackgroundImage.size;
//    [leftButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
//    return [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//
//}


@end
