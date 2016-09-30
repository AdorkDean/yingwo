//
//  SmsMessage.h
//  yingwo
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

/**
 *  验证码实体
 */
#import <Foundation/Foundation.h>

@interface SmsMessage : NSObject

@property (nonatomic, assign) Boolean  status;
@property (nonatomic, copy  ) NSString *info;
@property (nonatomic, copy  ) NSString *url;

@end
