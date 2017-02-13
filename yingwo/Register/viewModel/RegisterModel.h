//
//  RigisterModel.h
//  yingwo
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmsMessage.h"
#import "Register.h"
#import "UpdatePwdEntity.h"

@interface RegisterModel : NSObject

@property (nonatomic, strong) RACCommand *fetchResultCommand;


/**
 *  重置密码请求
 *
 *  @param url        部分url
 *  @param parameters 密码
 *  @param success    返回Register对象
 *  @param failure    失败
 */
- (void)requestForUpdatePwdWithUrl:(NSString *)url
                       parameters:(id)parameters
                          success:(void (^)(UpdatePwdEntity *update))success
                          failure:(ErrorBlock)failure;


/**
 *  注册请求
 *
 *  @param url        部分url
 *  @param parameters 请求参数
 *  @param success    返回Register对象
 *  @param failure    失败
 */
- (void)requestForRegisterWithUrl:(NSString *)url
                       parameters:(id)parameters
                          success:(void (^)(Register *reg))success
                          failure:(ErrorBlock)failure;

/**
 *  验证码请求
 *
 *  @param url        部分url
 *  @param parameters 请求参数
 *  @param success    返回SmsMessage对象
 *  @param failure    失败
 */
- (void)requestForSMSWithUrl:(NSString *)url
                  paramaters:(id)paramaters
                     success:(void (^)(SmsMessage *sms))success
                     failure:(ErrorBlock)failure;

/**
 *  短信验证
 *
 *  @param url        验证url
 *  @param paramaters 验证码和手机号
 *  @param success    status = 1
 *  @param failure    status = 0
 */
- (void)requestSMSForCheckMobleWithUrl:(NSString *)url
                            paramaters:(id)paramaters
                               success:(void (^)(SmsMessage *sms))success
                               failure:(ErrorBlock)failure;

/**
 *  验证手机是否注册过
 *
 *  @param url        /User/Check_mobile
 *  @param paramaters moblie
 *  @param success  status
 *  @param failure
 */
- (void)requestForCheckMobleWithUrl:(NSString *)url
                         paramaters:(id)paramaters
                            success:(void (^)(StatusEntity *status))success
                            failure:(ErrorBlock)failure;
@end
