//
//  UMAnalyticsTools.m
//  yingwo
//
//  Created by apple on 2017/2/7.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "UMAnalyticsTools.h"

@implementation UMAnalyticsTools

+ (void)initUMengAnalyticsConfiguration {
    
    NSString *version          = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    UMConfigInstance.appKey    = @"57f8af24e0f55a291700280b";
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    Customer *user = [User findCustomer];
    //发送用户统计信息
    if (user.name != nil) {
        [MobClick profileSignInWithPUID:user.name];
    }
}
@end
