//
//  HomeController.h
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

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

/**
 *  HomeController 用于首页显示贴子、新鲜事
 *  同时此类具备内容的筛选，就是上面的 ContentCategory 分类
 */
@interface HomeController : BaseViewController

@property (nonatomic, strong) YWTabBar        *tabBar;
@property (nonatomic, assign) NSUInteger      index;
@property (nonatomic, assign) ContentCategory contentCategoryModel;
@property (nonatomic, strong) UITableView     *homeTableview;

@end
