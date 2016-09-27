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
    if (self.selectedIndex == 0) {
        [self refreshHomeVC];
    }
}

- (void)refreshHomeVC {
    [self.homeVC.homeTableview.mj_header beginRefreshing];
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
        self.selectedIndex = index;
        //点击后刷新
        [self.homeVC.homeTableview.mj_header beginRefreshing];
    }else if(index == 1) {
        self.selectedIndex = index;
    }
    else if (index == 2) {
        
        [self performSegueWithIdentifier:@"announce" sender:self];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
