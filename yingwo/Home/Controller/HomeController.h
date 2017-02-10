//
//  NHomeController.h
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "GalleryController.h"

@interface HomeController :GalleryController

@property (nonatomic, strong) YWTabBar        *tabBar;

@property (nonatomic, assign) NSUInteger      index;

@property (nonatomic, assign) ContentCategory contentCategoryModel;

@property (nonatomic, assign) BOOL            type_topic;
@property (nonatomic, assign) BOOL            type_post;
@property (nonatomic, assign) int             item_id;


//- (void)weatherPush;

@end
