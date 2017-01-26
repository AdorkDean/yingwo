//
//  MD5.h
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

/**
 *  MD5密码加密
 */
@interface MD5 : NSObject

+ (NSString*)getMd5WithString:(NSString *)string;

+ (NSString *)getSha1WithString:(NSString *)string;

@end
