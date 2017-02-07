//
//  UMShareTools.m
//  yingwo
//
//  Created by apple on 2017/2/7.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "UMShareTools.h"

@implementation UMShareTools

+ (void)initUMShareConfiguration {
    //打开调试日志
    // [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57f8af24e0f55a291700280b"];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa5620512b44a6653" appSecret:@"2075207f2ec67ebea6dff904c35d3bdb" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105350566"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"wb590675358"  appSecret:@"95e7a907eebbad3cf575561a3f69d8c7" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //移除微信收藏选项
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_WechatFavorite];
    
    //添加自定义选项
    //    YWCustomSharePlatform *cusPlatform = [[YWCustomSharePlatform alloc] init];
    //    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:cusPlatform withUserDefinePlatformType:UMSocialPlatformType_Line];
    //
}
@end
