//
//  MainController.m
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MainController.h"
#import "YWTabBarController.h"
#import "MainViewModel.h"

#import "WZLBadgeImport.h"
#import "BadgeCount.h"
#import "EBForeNotification.h"

@interface MainController ()

@property (nonatomic,strong ) MainViewModel            *viewModel;

@property (nonatomic, assign) NSInteger                selectedIndex;

@property (nonatomic, assign) BOOL                     isOnHomePage;

@end

@implementation MainController

- (MainViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[MainViewModel alloc] init];
    }
    return _viewModel;
}

- (void)layoutSubviews {
    
    //self.reloaded = YES;
    
    _homeVC         = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_HOME_IDENTIFIER];
    _discoveryNavVC = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_DISCOVERY_IDENTIFIER];
    _messageVC      = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_MESSAGE_IDENTIFY];
    _personCenterVC = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_PERSONNAL_CENTER_IDENTIFY];

    _announceVC     = [[AnnounceController alloc] initWithTieZiId:0 title:@"新鲜事"];

    MainNavController *homeNav         = [[MainNavController alloc] initWithRootViewController:self.homeVC];
    MainNavController *discoveryNav    = [[MainNavController alloc] initWithRootViewController:self.discoveryNavVC];
    MainNavController *messageNav      = [[MainNavController alloc] initWithRootViewController:self.messageVC];
    MainNavController *personCenterNav = [[MainNavController alloc] initWithRootViewController:self.personCenterVC];
    _announceVCNav                     = [[MainNavController alloc] initWithRootViewController:self.announceVC];
    
    NSArray *controllerArr = [NSArray arrayWithObjects:homeNav,
                              discoveryNav,
                              _announceVCNav,
                              messageNav,
                              personCenterNav, nil];
    
    NSMutableDictionary *imgDic1 = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic1 setObject:[UIImage imageNamed:@"home_G"] forKey:@"Default"];
    [imgDic1 setObject:[UIImage imageNamed:@"home"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic2 setObject:[UIImage imageNamed:@"find_G"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"find"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic3 setObject:[UIImage imageNamed:@"add"] forKey:@"Default"];
    //  [imgDic3 setObject:[UIImage imageNamed:@""] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic4 setObject:[UIImage imageNamed:@"bub_G"] forKey:@"Default"];
    [imgDic4 setObject:[UIImage imageNamed:@"bub"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic5 setObject:[UIImage imageNamed:@"head_G"] forKey:@"Default"];
    [imgDic5 setObject:[UIImage imageNamed:@"head"] forKey:@"Seleted"];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic1,imgDic2,imgDic3,imgDic4,imgDic5,nil];
    
    _mainTabBarController = [[YWTabBarController alloc] initWithViewControllers:controllerArr
                                                                     imageArray:imgArr];
    _mainTabBarController.delegate = self;
    
    [self.view addSubview:_mainTabBarController.view];

    _homeVC.tabBar = _mainTabBarController.tabBar;
    _messageVC.bubBtn = _mainTabBarController.tabBar.bubBtn;
    
}

#pragma mark action
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self stopSystemPopGestureRecognizer];
    
    [self refreshBadgeState];
    
//    [self requestForBadgeCount];

    self.isOnHomePage = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoNotification:)
                                                 name:USERINFO_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eBBannerViewDidClick:)
                                                 name:EBBannerViewDidClick
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAnnounce)
                                                 name:PREVIEW_ANNOUNCE_NOTIFICATION
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    //去掉导航栏下的下划线
    [self.navigationController.navigationBar hideNavigationBarBottomLine];

    //防止点击发布新鲜事后，跳转回来后，但前TabBar的颜色不见了
    [_mainTabBarController.tabBar showSelectedTabBarAtIndex:self.selectedIndex];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)userInfoNotification:(NSNotification*)notification{
//判断推送类型及推送id
    NSDictionary *dict = [notification userInfo];
    NSString *type = [dict valueForKey:@"push_type"];
    NSString *item_id = [dict valueForKey:@"push_item_id"];
    
    if ([type isEqualToString:@"MESSAGE"]) {
        
        [self showMessagePage];
        [self.messageVC jumpToMyCommentPage];
        
    }else if ([type isEqualToString:@"LIKE"])
    {
        [self showMessagePage];
        [self.messageVC jumpToMyFavorPage];
        
    }else if ([type isEqualToString:@"ALERT"])
    {
        
        [self showHomePage];
        
    }else if ([type isEqualToString:@"TOPIC"]) {
        
        self.homeVC.allPostController.type_topic = YES;
        self.homeVC.allPostController.item_id = [item_id intValue];
        [self showHomePage];
        
    }else if ([type isEqualToString:@"POST"]) {
        
//        self.homeVC.allPostController.type_post = YES;
//        self.homeVC.allPostController.item_id = [item_id intValue];
        
        [self showDiscoveryPage];
    }
    
}

#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}

- (BOOL)tabBarController:(YWTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(YWTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}

- (void)didSelectedViewController:(UIViewController *)viewController AtIndex:(NSInteger)index {
    
    if (index == 0) {
        
        if (self.isOnHomePage) {
            
//            [self refreshHomeVC];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新" object:nil];
            
        }else {
            self.isOnHomePage = YES;
        }
    }
    else if(index == 1) {
        self.isOnHomePage = NO;

    }
    else if (index == 2) {

        [self showAnnounce];
    }
    else if (index == 3){
        
        self.isOnHomePage = NO;

        
    }
    else if(index == 4) {
        self.isOnHomePage = NO;

    }
    
    if (index != 2) {
        
        self.selectedIndex = index;

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private method

- (void)showAnnounce {
    
    if ([self.view.window.rootViewController isMemberOfClass:[MainController class]]) {
        
        [self presentViewController:self.announceVCNav animated:YES completion:nil];

    }
    

}
- (void)clearMessageRedDot {
    
    [self.mainTabBarController.tabBar.bubBtn clearBadge];

}

- (void)clearRedDotWithIndex:(NSUInteger)index {
    
    [self.mainTabBarController.tabBar.bubBtn clearBadge];
    [self.messageVC.messagePgaeView hideRedDotWithIndex:index];
    
}


-(void)eBBannerViewDidClick:(NSNotification*)notification{
    //判断推送类型及推送id
    NSDictionary *dict = [notification object];
    NSString *type     = [dict valueForKey:@"push_type"];
    NSString *item_id  = [dict valueForKey:@"push_item_id"];
    
    if ([type isEqualToString:@"MESSAGE"]) {
        
        [self showMessagePage];
        [self.messageVC jumpToMyCommentPage];
        
    }else if ([type isEqualToString:@"LIKE"])
    {
        
        [self showMessagePage];
        [self.messageVC jumpToMyFavorPage];
        
    }else if ([type isEqualToString:@"ALERT"])
    {
        
        [self showHomePage];
        
    }else if ([type isEqualToString:@"TOPIC"]) {
        
        self.homeVC.allPostController.type_topic = YES;
        self.homeVC.allPostController.item_id = [item_id intValue];
        [self showHomePage];
        
    }else if ([type isEqualToString:@"POST"]) {
        
//        self.homeVC.allPostController.type_post = YES;
//        self.homeVC.allPostController.item_id = [item_id intValue];
        [self showDiscoveryPage];
        [self.discoveryNavVC pushBlock];
        
    }
}


- (void)showHomePage {
    [_mainTabBarController displayViewAtIndex:0];
    [_mainTabBarController.tabBar showSelectedTabBarAtIndex:0];
    
}

- (void)showDiscoveryPage {
    [_mainTabBarController displayViewAtIndex:1];
    [_mainTabBarController.tabBar showSelectedTabBarAtIndex:1];
    
}
- (void)showMessagePage {
    
    [_mainTabBarController displayViewAtIndex:3];
    [_mainTabBarController.tabBar showSelectedTabBarAtIndex:3];
    
}

- (void)refreshHomeVC {
    [self.homeVC.allPostController.tableView.mj_header beginRefreshing];
    
    WeakSelf(self);
    self.homeVC.allPostController.tableView.mj_header.endRefreshingCompletionBlock = ^ {
        [weakself.mainTabBarController.tabBar.homeBtn clearBadge];

    };
    
}

- (void)refreshBadgeState {
    
    //一进入app就请求一次
    
    //利用本地通知来间隔时间请求有无新帖子，有的话即显示小红点
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //异步请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (TRUE) {
            [NSThread sleepForTimeInterval:30]; //请求时间间隔
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            [self requestForBadgeCount];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    });
}

- (void)requestForBadgeCount {
    
    WeakSelf(self);
    self.viewModel.badgeBlock = ^(int badgeCount,BadgeModel badgeModel) {
        
        if (badgeCount > 0) {
            
            if (badgeModel == HomeBadgeModel) {
                
//                weakself.mainTabBarController.tabBar.homeBtn.badgeCenterOffset = CGPointMake(-3, 3);
//                [weakself.mainTabBarController.tabBar.homeBtn showBadge];

                weakself.homeVC.allPostController.remindLabelBlock(badgeCount);
                
                NSLog(@"home 里面有推送:%d",badgeCount);
            }
            else if (badgeModel == CommentBadgeModel) {
                
                weakself.mainTabBarController.tabBar.bubBtn.badgeCenterOffset = CGPointMake(-3, 3);
                [weakself.mainTabBarController.tabBar.bubBtn showBadge];
                [weakself.messageVC.messagePgaeView showRedDotWithIndex:0];
                NSLog(@"comment 里面有推送:%d",badgeCount);
                
                weakself.messageVC.hasCommentBadge = YES;
                [weakself.messageVC.commentBtn.badgeLabel showBadgeWithStyle:WBadgeStyleNumber
                                                                       value:badgeCount
                                                               animationType:WBadgeAnimTypeScale];
            }
            else if (badgeModel == LikeBadgeModel) {
                
                weakself.mainTabBarController.tabBar.bubBtn.badgeCenterOffset = CGPointMake(-3, 3);
                [weakself.mainTabBarController.tabBar.bubBtn showBadge];
                [weakself.messageVC.messagePgaeView showRedDotWithIndex:1];
                NSLog(@"like 里面有推送:%d",badgeCount);
                
                weakself.messageVC.hasLikeBadge = YES;
                [weakself.messageVC.favorBtn.badgeLabel showBadgeWithStyle:WBadgeStyleNumber
                                                                     value:badgeCount
                                                             animationType:WBadgeAnimTypeScale];
            }
        }        
        
    };
    
    [self.viewModel requestForHomeBadgeWithUrl:HOME_INDEX_CNT_URL];
    [self.viewModel requestForCommentBadgeWithUrl:MESSAGE_COMMENT_CNT_URL];
    [self.viewModel requestForLikeBadgeWithUrl:MESSAGE_LIKE_CNT_URL];
    
    
}

@end
