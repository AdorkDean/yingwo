//
//  LoginModel.m
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (void)requestForLogin {
    
    [YWRequestTool YWRequestPOSTWithURL:self.request.URLString
                              parameter:self.request.parameter
                           successBlock:^(NSDictionary *content) {
                               
                               [SVProgressHUD dismiss];
                               
                               User *user           = [User mj_objectWithKeyValues:content[@"info"]];
                               
                               if (user != nil) {
                                   
                                   //登录成功后保存cookie
                                   [YWNetworkTools cookiesValueWithKey:LOGIN_COOKIE];
                                   
                                   //登录后本地保存数据
                                   //首先改变face_img的形式
                                   user.face_img = [NSString selectCorrectUrlWithAppendUrl:user.face_img];
                                   
                                   //头像
                                   [self requestForHeadImageWithUrl:user.face_img];
                                   
                               }else{
                                   
                                   [SVProgressHUD showErrorStatus:@"帐号或密码错误" afterDelay:HUD_DELAY];
                                   
                               }
                               
                               NSDictionary *parameters = @{@"device_token":[YWNetworkTools getDeviceToken]};
                               //提交device token
                               [self postDeviceTokenWithUrl:DEVICE_TOKEN_URL parameters:parameters];
                               
                               self.successBlock(user);
                               
                           } errorBlock:^(id error) {
                               self.errorBlock(error);
                           }];
    
}

- (void)requestForLoginWithUrl:(NSString *)url
                    parameters:(id)parameters
                       success:(void (^)(User *user))success
                       failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure {
    
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:parameters
                           successBlock:^(NSDictionary *content) {
                               
                               User *customer           = [User mj_objectWithKeyValues:content[@"info"]];
                               NSDictionary *parameters = @{@"device_token":[YWNetworkTools getDeviceToken]};
                               //提交device token
                               [self postDeviceTokenWithUrl:DEVICE_TOKEN_URL parameters:parameters];
                               
                               success(customer);
        
    } errorBlock:^(id error) {
        
    }];
}

- (void)requestForHeadImageWithUrl:(NSString *)imageUrl{
    
    NSURL *url             = [NSURL URLWithString:imageUrl];

    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
                                        UIImage *headImage = [UIImage imageWithData:data];
            
                                        [YWSandBoxTool saveHeadPortraitIntoCache:headImage];
        
    }];
    
    [task resume];


}

- (void)postDeviceTokenWithUrl:(NSString *)url
                    parameters:(NSDictionary *)parameters{
    
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:parameters
                           successBlock:^(id success) {
                               
                               NSLog(@"device token提交成功～%@",success);

        
    } errorBlock:^(id error) {
        
    }];

    
}

@end
