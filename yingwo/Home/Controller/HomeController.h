//
//  NHomeController.h
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "GalleryController.h"

typedef NS_ENUM(NSInteger, ContentCategory){
    
    //不分类，所有帖子
    AllThingModel = 0,
    //新鲜事
    FreshThingModel = 1,
    //关注的话题
    ConcernedTopicModel = 2,
    //好友动态
    FriendActivityModel = 3,
    
};

@interface HomeController :GalleryController

@property (nonatomic, strong) YWTabBar        *tabBar;

@property (nonatomic, assign) NSUInteger      index;

@property (nonatomic, assign) ContentCategory contentCategoryModel;

@end
