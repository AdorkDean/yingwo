//
//  Validate.m
//  yingwo
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "Validate.h"

@implementation Validate

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号数字字符
    NSString *phoneRegex = @"^[0-9]{11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL) validateVerification:(NSString *)verification
{
    //手机号数字字符
    NSString *Regex = @"^[0-9]{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [predicate evaluateWithObject:verification];
}

+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9.]{6,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

+(BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[\\u4e00-\\u9fa5A-Za-z0-9]{1,24}$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL) validateIsEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

@end
