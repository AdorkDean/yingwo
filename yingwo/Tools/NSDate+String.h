//
//  YWDateTools.h
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  将long型数字转换成时间字符串
 */
@interface NSDate (String)

+ (NSString *)getDateString:(NSString *)spString;
@end
