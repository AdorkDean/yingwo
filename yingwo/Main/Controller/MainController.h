//
//  MainController.h
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTabBarController.h"

/**
 *  主要的控制器，MainTabBarController就添加在这个控制器上
 */
@interface MainController : BaseViewController<YWTabBarControllerDelegate>

@property (nonatomic, strong) YWTabBarController       *mainTabBarController;

@property (nonatomic, assign) BOOL                     reloaded;
@property (nonatomic, assign) BOOL                     reloaded2;

- (void)clearRedDotWithIndex:(NSUInteger)index;

@end
