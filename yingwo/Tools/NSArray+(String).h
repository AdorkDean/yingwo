//
//  NSArray+(String).h
//  yingwo
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (String)

/**
 *  url数组拼接成字符串
 *
 *  @param arr 字符串数组
 *
 *  @return 以逗号隔开的字符串
 */
+ (NSString *)appendElementToString:(NSArray *)arr;

@end
