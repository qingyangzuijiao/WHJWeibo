//
//  HMOAuthVC.m
//  0307-新浪微博
//
//  Created by whj on 16/4/19.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  授权
//  url：https://api.weibo.com/oauth2/authorize(用UIWebView访问)
//  App Key：3863840559(应用的唯一标识)
//  App Secret：53bf05b6b5a90b583895371e6c7bb1a0

#import "HMOAuthVC.h"
#import "HMHttpRequestTool.h"
#import "MBProgressHUD+MJ.h"
#import "HMAccountTool.h"

@interface HMOAuthVC () <UIWebViewDelegate>

@end

@implementation HMOAuthVC

- (void)viewDidLoad
{
    
    //创建一个webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    // 2.用webView加载登录页面（新浪提供的）
    //url : https://api.weibo.com/oauth2/authorize
    /* 请求参数：
     client_id	true	string	申请应用时分配的AppKey。
     redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址
     */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",HMAppKey,HMRedirectURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate = self;
}

#pragma mark - webView代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    HMLog(@"HMOAuthVCstart");
    [MBProgressHUD showMessage:@"正在加载..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    HMLog(@"HMOAuthVCFinishLoad");
    [MBProgressHUD hideHUD];
}
/**  webView加载失败的时候调用 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

/**
 *  webView每访问一次网址时就会调用改方法
 *
 *  @param webView
 *  @param request        每次webView加载时发出的请求
 *  @param navigationType 导航的类型
 *
 *  @return 
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得url
    NSString *urlStr = request.URL.absoluteString;
    HMLog(@"shouldStartLoadWithRequest-----%@",urlStr);//absolute:完全的
    
    NSRange range = [urlStr rangeOfString:@"code="];
    // 2.判断是否为回调地址
    if (range.length != 0) { // 是回调地址
        
        // 截取code=后面的参数值
        NSInteger index = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:index];
        HMLog(@"code = %@",code);
        
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        
        // 禁止加载回调地址
        return NO;
        
    }
    
    return YES;
}
/**
 client_id	true	string	申请应用时分配的AppKey。
 client_secret	true	string	申请应用时分配的AppSecret。
 grant_type	true	string	请求的类型，填写authorization_code
 
 grant_type为authorization_code时
 必选	类型及范围	说明
 code	true	string	调用authorize获得的code值。
 redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。

 */

//https://api.weibo.com/oauth2/access_token

- (void)accessTokenWithCode:(NSString *)code
{
    // 1.拼接请求参数
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    parametersDict[@"client_id"] = HMAppKey;
    parametersDict[@"client_secret"] = HMAppSecret;
    parametersDict[@"grant_type"] = @"authorization_code";
    parametersDict[@"code"] = code;
    parametersDict[@"redirect_uri"] = HMRedirectURL;

    //2.发送请求
    [HMHttpRequestTool post:@"https://api.weibo.com/oauth2/access_token" parameters:parametersDict success:^(id json) {
        DLog(@"success---->%@",json);
        [MBProgressHUD hideHUD];
        //存储账号信息
        HMAccount *account = [HMAccount accountWithDict:json];
        [HMAccountTool saveAccount:account];

        //设置根控制器(切换)
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];

    } failure:^(NSError *error) {

        [MBProgressHUD hideHUD];
        HMLog(@"failure----->%@",error);

    }];
//    //创建一个manager
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
////    manager.responseSerializer = [AFJSONResponseSerializer serializer];//默认的就是json解析器
//    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
//
//    // 2.拼接请求参数
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    parametersDict[@"client_id"] = HMAppKey;
//    parametersDict[@"client_secret"] = HMAppSecret;
//    parametersDict[@"grant_type"] = @"authorization_code";
//    parametersDict[@"code"] = code;
//    parametersDict[@"redirect_uri"] = HMRedirectURL;
//
//    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        HMLog(@"success---->%@",responseObject);
//        [MBProgressHUD hideHUD];
//        //存储账号信息
//        HMAccount *account = [HMAccount accountWithDict:responseObject];
//        [HMAccountTool saveAccount:account];
//        
//        //设置根控制器(切换)
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window switchRootViewController];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        [MBProgressHUD hideHUD];
//        HMLog(@"failure----->%@",error);
//    }];
}

@end
