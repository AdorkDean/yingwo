//
//  NHomeController.h
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "GalleryController.h"
#import "AllPostController.h"

@class SCNavTabBar;

@interface HomeController :BaseViewController

@property (nonatomic, strong) YWTabBar              *tabBar;
@property (nonatomic, strong) AllPostController     *allPostController;

@property (nonatomic, assign) ContentCategory       contentCategoryModel;

@property (nonatomic, assign) NSUInteger            index;


@property (nonatomic, assign)   BOOL        canPopAllItemMenu;       
@property (nonatomic, assign)   BOOL        scrollAnimation;         
@property (nonatomic, assign)   BOOL        mainViewBounces;         

@property (nonatomic, strong)   NSArray     *subViewControllers;     

@property (nonatomic, strong)   UIColor     *navTabBarColor;
@property (nonatomic, strong)   UIFont      *navTabBarFont;
@property (nonatomic, strong)   UIColor     *navTabBarLineColor;
@property (nonatomic, strong)   UIImage     *navTabBarArrowImage;

@end
