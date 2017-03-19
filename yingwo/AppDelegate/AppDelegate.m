//
//  AppDelegate.m
//  yingwo
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "AppDelegate.h"

#import "BadgeCount.h"
#import "EBForeNotification.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
//以下几个库仅作为调试引用引用的
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>

#import "MainController.h"
#import "LoginController.h"
#import "YWTabBarController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@property (nonatomic, strong) YWTabBarController       *mainTabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //数据库使用的是MagicalRecord第三方框架，封装的是CoreData
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelError];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"yingwoDatabase.sqlite"];
    
    //初始化融云
    [RongCloudTools initCustomConfigurationIn:self];
    
    /**
     *  友盟分享配置项
     */
    [UMShareTools initUMShareConfiguration];
    
    /**
     *  友盟统计与崩溃
     */
    [UMAnalyticsTools initUMengAnalyticsConfiguration];
    
    /**
     *  友盟推送配置项
     */
    //设置 AppKey 及 LaunchOptions
    [UMessageTools initUMessageConfigurationWithLaunchOptions:launchOptions];
    
    //初始化UIApplication
    [self initCustomAppDelegate];

    //初始化main controller
    [self initLoadingController];

    //iOS10必须加下面这段代码。
    [self letIOS10RemoteNotification];

    
    [YWNetworkTools postDeviceToken];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {

    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {

    }
    return result;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

//iOS10以下使用这个方法接收通知

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ||
        [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) { //应用在后台时

        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_NOTIFICATION
                                                            object:self
                                                          userInfo:userInfo];
        NSLog(@"device token: %@",userInfo);
        
//        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {//应用从前台时

        NSLog(@"device token: %@",userInfo);
        
        [UMessage setAutoAlert:NO];
        //应用从前台时
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self stringDevicetoken:deviceToken];
    NSLog(@"deviceToken:---%@",deviceToken);
    
 //   [UMessage registerDeviceToken:deviceToken];
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];

        //应用处于前台时的远程推送接受
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:YES];
    }else{
        //应用处于前台时的本地推送接受
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void) userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_NOTIFICATION
                                                            object:self
                                                          userInfo:userInfo];
        
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    Customer *user                 = [User findCustomer];

    if ([User haveExistedLoginInformation] && [user.register_status intValue] == 1)  {
        
        if ([shortcutItem.type isEqualToString:@"com.yingwoo.yingwoxiaoyuan.First"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PREVIEW_ANNOUNCE_NOTIFICATION
                                                                object:nil];
        }
        else {
            
        }

        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
 //   [self saveContext];
}

#pragma mark RCIMUserInfoDataSource，RCIMGroupInfoDataSource


- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    
    Customer *customer = [User findCustomer];
    
    NSLog(@"user:%@",userId);

    if ([userId isEqualToString:customer.userId]) {
        return completion([[RCUserInfo alloc] initWithUserId:userId
                                                        name:customer.name
                                                   portrait:customer.face_img]);
    }else
    {
        [User getUserInfoForChatWithUserId:userId success:^(User *user) {
            
            return completion([[RCUserInfo alloc] initWithUserId:userId
                                                            name:user.name
                                                        portrait:user.face_img]);

        } failure:^(id failureValue) {
            
        }];
    }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion {
    
}

#pragma mark 以下的方法仅作调试使用
-(NSString *)stringDevicetoken:(NSData *)deviceToken
{
    NSString *token     = [deviceToken description];
    NSString *pushToken = [[[token stringByReplacingOccurrencesOfString:
                                                         @"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">"
                                                              withString:@""]
                                    stringByReplacingOccurrencesOfString:@" "
                                                              withString:@""];
    

    
    [YWNetworkTools saveDeviceToken:pushToken];
    [YWNetworkTools postDeviceToken];

    return pushToken;
}


#pragma mark private method

- (void)initCustomAppDelegate {
    
    [UIApplication sharedApplication].statusBarStyle              = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor whiteColor];
    
}

- (void)initLoadingController {
    
    
    UIStoryboard *storyboard       = [UIStoryboard storyboardWithName:@"Main"
                                                               bundle:nil];
    Customer *user                 = [User findCustomer];

     MainNavController         *mainNav;
    //如果有帐号，则直接登录
    if ([User haveExistedLoginInformation] && [user.register_status intValue] == 1) {

    MainController *mainVC         = [storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_MAINVC_IDENTIFIER];
    self.window.rootViewController = mainVC;

    }else {
    UIStoryboard *storyboard       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *loginVC       = [storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_LOGINVC_IDENTIFIER];
    mainNav                        = [[MainNavController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = mainNav;
        
    }
    
    [self.window makeKeyAndVisible];

}

-(void)letIOS10RemoteNotification {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate                  = self;
    UNAuthorizationOptions types10   = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  
                              } else {
                                  //点击不允许
                                  
                              }
                          }];
}

#pragma mark - Core Data stack

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wangxiaofa.yingwo.yingwo" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"yingwo" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"yingwo.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
