//
//  HMHttpRequestTool.m
//  0307-新浪微博
//
//  Created by whj on 16/8/28.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMHttpRequestTool.h"


@implementation HMHttpRequestTool

+ (void)get:(NSString *)urlStr parameters:(NSMutableDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.发送请求
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //        HMLog(@"downloadProgress = %@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
    }];

}

+ (void)post:(NSString *)urlStr parameters:(NSMutableDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.发送请求
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //        HMLog(@"downloadProgress = %@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)post:(NSString *)urlStr parameters:(NSMutableDictionary *)parameters requestSerializerValue:(NSString *)value httpHeaderField:(NSString *)headerField constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //    创建一个manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:value forHTTPHeaderField:headerField];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];//默认的就是json解析器
    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
    
    
    //3.发送请求
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

    


}

@end
