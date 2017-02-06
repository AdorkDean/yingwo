//
//  RongCloudTools.m
//  TEvaluatingSystem
//
//  Created by apple on 2017/2/3.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "RongCloudTools.h"

@implementation RongCloudTools

+ (void)initRongCloudWithAppKey:(NSString *)key
                          token:(NSString *)token
                        success:(RongCloudReturnValue)success
                        failure:(RongCloudReturnError)failure {
    
    [[RCIM sharedRCIM] initWithAppKey:RongCloud_Key];
  //  [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;

    [[RCIM sharedRCIM] connectWithToken:token
                                success:^(NSString *userId) {
        
        
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        success(userId);

    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"登陆的错误码为:%d", (int)status);
        failure(@"融云登陆的错误码");
        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];

}

+(void)requestForRongCloudTokenWithURL:(NSString *)URLString
                             parameter:(id)parameter
                   rongCloudTokenValue:(RongCloudTokenValue)rongCloudTokenValue
                   rongCloudTokenError:(RongCloudTokenError)rongCloudTokenError{
    
    //随机数
    NSString *nonce     = [RongCloudTools getRandomNonce];
    //时间戳
    NSString *timeStamp = [RongCloudTools getTimestamp];
    //签名
    NSString *signature = [RongCloudTools getSignatureWithAppKey:RongCloud_Key
                                                           nonce:nonce
                                                       timestamp:timeStamp];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    //设置请求头
    [manager.requestSerializer setValue:RongCloud_Key forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:timeStamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];
    [manager.requestSerializer setValue:RongCloud_App_Secret forHTTPHeaderField:@"appSecret"];

    [manager POST:URLString
       parameters:parameter
         progress:nil
          success:^(NSURLSessionDataTask * task, id responseObject) {
        
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
              if ([content[@"code"] integerValue] == 200) {
                  
                  rongCloudTokenValue(content);
                  
              }
              else
              {
                  NSLog(@"请求失败token获取失败");
                  rongCloudTokenError(@"请求失败token获取失败");
              }
              
             // NSLog(@"responseObject:%@",content);
              
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
    }];
    /*
    [TERequestTool TERequestPOSTWithURL:URLString
                              parameter:parameter
                       returnValueBlock:^(id returnValue) {
                           
                           NSDictionary *content = [NSJSONSerialization JSONObjectWithData:returnValue
                                                                                   options:NSJSONReadingMutableContainers
                                                                                     error:nil];
                           if ([content[@"code"] integerValue] == 200) {
                               
                               rongCloudTokenValue(content);

                           }
                           else
                           {
                               NSLog(@"请求失败token获取失败");
                               rongCloudTokenError(@"请求失败token获取失败");
                           }
        
    } failureBlock:^(id failure) {
        
        NSLog(@"请求错误token获取失败");
        rongCloudTokenError(@"请求错误token获取失败");
    }];*/
    
}

////获取随机数
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

+ (NSString *)getRandomNonce {
    NSInteger randomValue = [self getRandomNumber:100000 to:999999];
    return  [NSString stringWithFormat:@"%ld",randomValue];
}

//获取时间戳
+ (NSString *)getTimestamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval times =  [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",times];
}

//sha1 加密
+ (NSString *)sha1WithKey:(NSString *)key
{
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *)getSignatureWithAppKey:(NSString *)appKey
                               nonce:(NSString *)nonce
                           timestamp:(NSString *)timestamp{
    
    NSString *sha1String = [NSString stringWithFormat:@"%@%@%@",appKey,nonce,timestamp];
    return [self sha1WithKey:sha1String];
}

@end
