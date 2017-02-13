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

- (void)requestForUpdatePwdWithUrl:(NSString *)url
                       parameters:(id)parameters
                          success:(void (^)(UpdatePwdEntity *update))success
                          failure:(ErrorBlock)failure {
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:parameters
                           successBlock:^(id content) {
                               UpdatePwdEntity *update         = [UpdatePwdEntity mj_objectWithKeyValues:content];
                               success(update);
    } errorBlock:^(id error) {
        failure(error);
    }];
    
}



- (void)requestForRegisterWithUrl:(NSString *)url
                       parameters:(id)parameters
                          success:(void (^)(Register *reg))success
                          failure:(ErrorBlock)failure {
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:parameters
                           successBlock:^(id content) {
                               Register *reg         = [Register mj_objectWithKeyValues:content];
                               success(reg);
    } errorBlock:^(id error) {
        failure(error);
    }];
    
}

- (void)requestForSMSWithUrl:(NSString *)url
                  paramaters:(id)paramaters
                     success:(void (^)(SmsMessage *sms))success
                     failure:(ErrorBlock)failure {
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:paramaters
                           successBlock:^(id content) {
                               SmsMessage *sms       = [SmsMessage mj_objectWithKeyValues:content];
                               
                               success(sms);
    } errorBlock:^(id error) {
        failure(error);
    }];

}

- (void)requestSMSForCheckMobleWithUrl:(NSString *)url
                            paramaters:(id)paramaters
                               success:(void (^)(SmsMessage *sms))success
                               failure:(ErrorBlock)failure {
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:paramaters
                           successBlock:^(id content) {
                               SmsMessage *sms       = [SmsMessage mj_objectWithKeyValues:content];
                               
                               success(sms);
    } errorBlock:^(id error) {
        failure(error);
    }];
    
}

- (void)requestForCheckMobleWithUrl:(NSString *)url
                            paramaters:(id)paramaters
                               success:(void (^)(StatusEntity *status))success
                               failure:(ErrorBlock)failure {
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:paramaters
                           successBlock:^(id content) {
        
                               StatusEntity *statusEntity       = [StatusEntity mj_objectWithKeyValues:content[@"info"]];
                               
                               success(statusEntity);
                               
    } errorBlock:^(id error) {
        failure(error);
    }];
    
}

@end
