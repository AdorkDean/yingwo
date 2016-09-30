//
//  NSString+Clean.h
//  yingwo
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  url过滤非法字符类
 */
@interface NSString (Url)

/**
 *  url非法字符清除
 *
 *  @param urlString 资源标志符
 *
 *  @return 返回合法url
 */
+ (NSString *)replaceIllegalStringForUrl:(NSString *)urlString;

/**
 *  将图片数组的url解析出来，
 *
 *  @param urlString 拼接的字符串链接
 *
 *  @return 返回保存ImageViewEntity的数组
 */
+ (NSMutableArray *)separateImageViewURLString:(NSString *)urlString;

/**
 *  取出前面的url
 *
 *  @param appendUrl 平接后的url
 *
 *  @return 返回url
 */
+ (NSString *)selectCorrectUrlWithAppendUrl:(NSString *)appendUrl;
@end
