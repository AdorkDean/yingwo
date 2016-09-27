//
//  User.h
//  yingwo
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求时，用户数据的对应模型类，与coredata的模型类Customer对应
 *  为什么有了Customer类还要有User类呢？解释：因为Customer类不能直接使用
 *  不能通过MJExtension键值转换
 */
@interface User : NSObject

@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *signature;
@property (nonatomic, copy)NSString *face_img;
@property (nonatomic, copy)NSString *school_name;
@property (nonatomic, copy)NSString *academy_name;
@property (nonatomic, copy)NSString *school_id;
@property (nonatomic, copy)NSString *academy_id;
@property (nonatomic, copy)NSString *register_status;
@property (nonatomic, copy)NSString *grade;
@property (nonatomic, copy)NSString *create_time;

@end
