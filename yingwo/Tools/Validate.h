//
//  Validate.h
//  yingwo
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  字符串合法性检查类，主要用于登陆、注册时手机号、密码的验证
 */
@interface Validate : NSObject
//手机号验证：0～9的数字,11位
+ (BOOL) validateMobile:(NSString *)mobile;

//验证码
+ (BOOL) validateVerification:(NSString *)verification;
//密码验证：只能是字母、数字,最长20
+ (BOOL) validatePassword:(NSString *)passWord;

//用户名验证：数字、字母、中文、长度1～24
+(BOOL) validateUserName:(NSString *)name;

//验证是否全为空格
+ (BOOL) validateIsEmpty:(NSString *) str;

@end
