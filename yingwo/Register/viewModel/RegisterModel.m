//
//  RigisterModel.m
//  yingwo
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "RegisterModel.h"


@implementation RegisterModel

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)requestForRegisterWithUrl:(NSString *)url
                       parameters:(id)parameters
                          success:(void (^)(Register *reg))success
                          failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];

    [manager POST:fullUrl
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        Register *reg         = [Register mj_objectWithKeyValues:content];
        success(reg);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)requestForSMSWithUrl:(NSString *)url
                  paramaters:(id)paramaters
                     success:(void (^)(SmsMessage *sms))success
                     failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];

    YWHTTPManager *manager = [YWHTTPManager manager];

    [manager POST:fullUrl parameters:paramaters
                            progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        SmsMessage *sms       = [SmsMessage mj_objectWithKeyValues:content];

        success(sms);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)requestSMSForCheckMobleWithUrl:(NSString *)url
                            paramaters:(id)paramaters
                               success:(void (^)(SmsMessage *sms))success
                               failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              SmsMessage *sms       = [SmsMessage mj_objectWithKeyValues:content];
              
              success(sms);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(task,error);
          }];
}

@end
