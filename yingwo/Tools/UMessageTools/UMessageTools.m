//
//  UMessageTools.m
//  yingwo
//
//  Created by apple on 2017/2/7.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "UMessageTools.h"

@implementation UMessageTools

+ (void)initUMessageConfigurationWithLaunchOptions:(NSDictionary *)launchOptions{

    [UMessage startWithAppkey:@"57f8af24e0f55a291700280b"
                launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];

  //  [UMessage setLogEnabled:YES];
  //  [UMessage setBadgeClear:YES];
    
}
@end
