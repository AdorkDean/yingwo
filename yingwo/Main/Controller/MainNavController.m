//
//  MainNavController.m
//  yingwo
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MainNavController.h"

@interface MainNavController ()

@end

@implementation MainNavController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title color and UIButtonBarItem color
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    //background color
    self.navigationBar.barTintColor = [UIColor colorWithHexString:THEME_COLOR_1];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19 weight:1]}];
    self.navigationBar.translucent = NO;
    
    //隐藏导航栏底部的线
    [self.navigationBar hideNavigationBarBottomLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
