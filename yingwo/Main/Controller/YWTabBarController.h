//
//  YWTabBarController.h
//  XXTabBar
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTabBar.h"
@class UITabBarController;
@protocol YWTabBarControllerDelegate;
@protocol AnnounceControllerDelegate;

/**
 *  应我主要的TabBar
 */
@interface YWTabBarController : UIViewController<YWTabBarDelegate,AnnounceControllerDelegate>

@property (nonatomic, strong  ) NSMutableArray             *viewControllers;
@property (nonatomic, readonly) UIViewController           *selectedViewController;
@property (nonatomic          ) NSUInteger                 selectedIndex;

@property (nonatomic, readonly) YWTabBar                   *tabBar;
@property (nonatomic,assign   ) id<YWTabBarControllerDelegate> delegate;

// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;


- (id)initWithViewControllers:(NSArray *)controllers imageArray:(NSArray *)images;

- (void)removeViewControllerAtIndex:(NSUInteger)index;

- (void)displayViewAtIndex:(NSUInteger)index ;

@end

@protocol YWTabBarControllerDelegate <NSObject>

@optional
- (BOOL)tabBarController:(YWTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(YWTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
- (void)didSelectedViewController:(UIViewController *)viewController AtIndex:(NSInteger)index;

- (void)hidesTabBar:(BOOL)yesOrNo animated:(BOOL)animated;
@end