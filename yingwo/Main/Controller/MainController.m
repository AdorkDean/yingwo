//
//  MainController.m
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MainController.h"
#import "YWTabBarController.h"
#import "PersonalCenterController.h"
#import "HomeController.h"
#import "AnnounceController.h"
#import "DiscoveryController.h"
#import "DetailController.h"

#import "WZLBadgeImport.h"
#import "BadgeCount.h"

@interface MainController ()

@property (nonatomic, strong) YWTabBarController       *mainTabBarController;
@property (nonatomic, strong) HomeController           *homeVC;
@property (nonatomic, strong) DiscoveryController      *discoveryVC;
@property (nonatomic, strong) PersonalCenterController *personCenterVC;
@property (nonatomic, strong) AnnounceController       *announceVC;

@property (nonatomic, assign) NSInteger                selectedIndex;


@end

@implementation MainController



#pragma mark action


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reloaded = YES;
    
    self.homeVC                        = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_HOME_IDENTIFIER];
    self.discoveryVC                   = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_DISCOVERY_IDENTIFIER];
    self.personCenterVC                = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_PERSONNAL_CENTER_IDENTIFY];

    self.announceVC                    = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_ANNOUNCE_IDENTIFIER];

    MainNavController *homeNav         = [[MainNavController alloc] initWithRootViewController:self.homeVC];
    MainNavController *discoveryNav    = [[MainNavController alloc] initWithRootViewController:self.discoveryVC];
    MainNavController *personCenterNav = [[MainNavController alloc] initWithRootViewController:self.personCenterVC];
    MainNavController *announceNav     = [[MainNavController alloc] initWithRootViewController:self.announceVC];

    NSArray *controllerArr = [NSArray arrayWithObjects:homeNav,discoveryNav,announceNav,discoveryNav,personCenterNav, nil];
    
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
    
    [self stopSystemPopGestureRecognizer];
    
    [self refreshBadgeState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    //去掉导航栏下的下划线
    [self.navigationController.navigationBar hideNavigationBarBottomLine];

    //防止点击发布新鲜事后，跳转回来后，但前TabBar的颜色不见了
    [_mainTabBarController.tabBar showSelectedTabBarAtIndex:self.selectedIndex];
    
    //如果刚出现的是贴子页面，要刷新。
    //发布完后回，若到回到贴子页面要刷新
    //第一次加载app可能会有两次刷新，这里一次多余了，贴子的controller也有个刷新
//        AnnounceController *announceVc = [[AnnounceController alloc] init];
//        self.announceVC = announceVc;
//    
//    __weak AnnounceController *weakSelf = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_ANNOUNCE_IDENTIFIER];
//    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)refreshHomeVC {
    [self.homeVC.homeTableview.mj_header beginRefreshing];
}

- (void)refreshBadgeState {

    //一进入app就请求一次
    [self requestForBadgeCount];

    //利用本地通知来间隔时间请求有无新帖子，有的话即显示小红点
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //异步请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (TRUE) {
            [NSThread sleepForTimeInterval:15]; //请求时间间隔
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            [self requestForBadgeCount];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    });
}

- (void)requestForBadgeCount {
   //请求未刷新的新帖子数
    NSDictionary *paramaters;
    [self requestForBadgeWithUrl:HOME_INDEX_CNT_URL
                      paramaters:paramaters
                         success:^(int badgeCount) {
                             
                             if (badgeCount >= 1) {
                                 //UI操作在多线程异步请求下需放在主线程中执行
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.mainTabBarController.tabBar.homeBtn.badgeCenterOffset = CGPointMake(-3, 3);
                                     [self.mainTabBarController.tabBar.homeBtn showBadge];
                                 });
                                 
                             }
                         }
                         failure:^(NSString *error) {
                             NSLog(@"error:%@",error);
                         }];
    

}


//请求
- (void)requestForBadgeWithUrl:(NSString *)url
                    paramaters:(NSDictionary *)paramaters
                       success:(void (^)(int badgeCount))success
                       failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

              BadgeCount *badgeCnt = [BadgeCount mj_objectWithKeyValues:content];
              int badgeCount       =  [badgeCnt.info intValue];
              success(badgeCount);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
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
        
        //如果点击了其他页面后点击home页面，则不刷新，再次点击home页面才刷新
        self.selectedIndex = index;
        
        if (self.reloaded == NO) {
            self.reloaded  = YES;
        }else {
            //刷新后清除小红点
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTabBarController.tabBar.homeBtn clearBadge];
            });
            [self.homeVC.homeTableview.mj_header beginRefreshing];
        }
    }
    else if(index == 1) {
        self.reloaded = NO;
        self.selectedIndex = index;
    }
    else if (index == 2) {
        self.reloaded = NO;

        [self performSegueWithIdentifier:@"announce" sender:self];
    }
    else if (index == 3 || index == 4) {
        self.selectedIndex = index;
        self.reloaded = NO;
    }

}


#pragma mark segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"announce"]) {
        if ([segue.destinationViewController isKindOfClass:[MainNavController class]]) {
            
            MainNavController *mainNav = segue.destinationViewController;
            
            AnnounceController *announceVc = [mainNav.viewControllers objectAtIndex:0];
            
            announceVc.delegate = self.announceVC.delegate;
            announceVc.returnValueBlock = ^(BOOL isreloaded2) {
                                
                if (isreloaded2 == YES) {
                    [self refreshHomeVC];
                    
                }
            };
            
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
