//
//  YWCustomSharePlatform.m
//  yingwo
//
//  Created by 王世杰 on 2016/11/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWCustomSharePlatform.h"

@implementation YWCustomSharePlatform

+(NSString *)platformNameWithPlatformType:(UMSocialPlatformType)platformType {
    return @"复制链接";
}

- (void)umSocial_ShareWithObject:(UMSocialMessageObject *)object withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler {
    
    UMShareWebpageObject *webObjc = object.shareObject;
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = webObjc.webpageUrl;
    [SVProgressHUD showSuccessStatus:@"链接复制成功" afterDelay:1.5];
}

-(BOOL)umSocial_handleOpenURL:(NSURL *)url {
    return YES;
}

-(UMSocialPlatformFeature)umSocial_SupportedFeatures {
    return UMSocialPlatformFeature_None;
}

- (NSString *)umSocial_PlatformSDKVersion {
    return [UMSocialGlobal umSocialSDKVersion];
}

-(BOOL)checkUrlSchema {
    return YES;
}

-(BOOL)umSocial_isInstall {
    return YES;
}

-(BOOL)umSocial_isSupport {
    return YES;
}

-(void)umSocial_clearCacheData {
    
}

-(void)umSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL {
    
}

-(void)umSocial_AuthorizeWithUserInfo:(NSDictionary *)userInfo withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler {
    
}

-(void)umSocial_cancelAuthWithCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler {
    
}

-(void)umSocial_AuthorizeWithUserInfo:(NSDictionary *)userInfo withViewController:(UIViewController *)viewController withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler {
    
}

-(void)umSocial_ShareWithObject:(UMSocialMessageObject *)object withViewController:(UIViewController *)viewController withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler {
    
}

-(void)umSocial_RequestForUserProfileWithCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler {
    
}

-(void)umSocial_RequestForUserProfileWithViewController:(id)currentViewController completion:(UMSocialRequestCompletionHandler)completion {
    
}
@end







