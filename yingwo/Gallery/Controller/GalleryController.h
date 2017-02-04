//
//  ViewController.h
//  YWGalleryView
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailController.h"
#import "TopicController.h"
#import "YWTabBarController.h"

#import "TieZi.h"
#import "GalleryViewModel.h"
#import "YWDropDownView.h"
#import "YWPhotoCotentView.h"

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

@interface GalleryController : BaseViewController

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) GalleryViewModel *viewModel;
@property (nonatomic, strong) TieZi            *model;

@property (nonatomic, strong) NSMutableArray   *tieZiList;

@end

