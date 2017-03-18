//
//  MainController.h
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTabBarController.h"

#import "PersonalCenterController.h"
#import "HomeController.h"
#import "AnnounceController.h"
#import "DiscoveryNavController.h"
#import "DetailController.h"
#import "MessageController.h"
#import "TopicController.h"

/**
 *  主要的控制器，MainTabBarController就添加在这个控制器上
 */

@interface MainController : BaseViewController<YWTabBarControllerDelegate>

@property (nonatomic, strong) YWTabBarController       *mainTabBarController;

@property (nonatomic, strong) HomeController           *homeVC;
@property (nonatomic, strong) DiscoveryNavController   *discoveryNavVC;
@property (nonatomic, strong) PersonalCenterController *personCenterVC;
@property (nonatomic, strong) AnnounceController       *announceVC;
@property (nonatomic, strong) MessageController        *messageVC;
@property (nonatomic, strong) MainNavController        *announceVCNav;

- (void)clearRedDotWithIndex:(NSUInteger)index;

@end
