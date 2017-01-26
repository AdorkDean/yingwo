//
//  User+CURD.h
//  yingwo
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  User的分类，用于实现User类的从数据库的增、删、改、查
 *  是一个间接类，直接操作的是 Customer 类
 */
@interface User (CURD)

//将user模型转为customer模型
//增加记录
+ (void)saveCustomerByUser:(User *)user;

//删除记录
+ (void)deleteCustoer;

//查询记录
+ (Customer *)findCustomer;

//修改记录
+ (void)modifyCustomerByKey:(NSString *)key value:(NSString *)value;

//登录信息本地化保存
/**
 *  登录手机号、密码保存
 *
 *  @param phone    手机号
 *  @param password 密码
 */
+ (BOOL)saveLoginInformationWithUsernmae:(NSString *)phone password:(NSString *)password;

//检查是否有登录信息
+ (BOOL)haveExistedLoginInformation;

//获取用户名（手机号）
+ (NSString *)getUsername;

//获取密码
+ (NSString *)getPasswoord;

+ (void)deleteLoginInformation;

@end






