//
//  HMHttpRequestTool.h
//  0307-新浪微博
//
//  Created by whj on 16/8/28.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface HMHttpRequestTool : NSObject

+ (void)get:(NSString *)urlStr parameters:(NSMutableDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)urlStr parameters:(NSMutableDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)urlStr parameters:(NSMutableDictionary *)parameters requestSerializerValue:(NSString *)value httpHeaderField:(NSString *)headerField constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
