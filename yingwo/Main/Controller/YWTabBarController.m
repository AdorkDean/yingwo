//
//  YWTabBarController.m
//  XXTabBar
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTabBarController.h"
#import "YWTabBar.h"
#import "AnnounceController.h"
#import "HomeController.h"

#define kTabBarHeight 49.0f
#define TAB_BAR_MARGIN_TOP 10.0f
@interface YWTabBarController ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation YWTabBarController

- (id)initWithViewControllers:(NSArray *)controllers imageArray:(NSArray *)images {
    
    self = [super init];
    if (self) {

        _viewControllers = [[NSMutableArray alloc ] initWithArray:controllers];

        _containerView   = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _tabBar          = [[YWTabBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) buttonImages:images];

        _tabBar.delegate = self;

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:_containerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark -Getter and setter
-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index {
    
    if (index >= [_viewControllers count]) {
        return;
    }
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view]removeFromSuperview];
    [_viewControllers removeObjectAtIndex:index];
    [_tabBar removeTabAtIndex:index];
    
}

- (void)hidesTabBar:(BOOL)yesOrNo animated:(BOOL)animated {
    
    //动画隐藏
    if (animated == yesOrNo) {
        if (yesOrNo == YES) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view);
                    make.top.equalTo(self.view.mas_bottom).offset(TAB_BAR_MARGIN_TOP);
                }];
                [self.tabBar layoutIfNeeded];
            }];
            
        }else {
                [self.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view);
                    make.bottom.equalTo(self.view.mas_bottom).offset(TAB_BAR_MARGIN_TOP);
                }];
                [self.tabBar layoutIfNeeded];
        }
 
    }else {
        if (yesOrNo == YES)
        {
            [self.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.top.equalTo(self.view.mas_bottom).offset(TAB_BAR_MARGIN_TOP);
            }];
            [self.tabBar layoutIfNeeded];
        }
        else
        {

        }
    }
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index {
    //[_viewControllers insertObject:vc atIndex:index];
    //_tabBar inse
}

#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index {
    
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]]) {
            
            return;
        }
    }
    
    //UINavgationController
     MainNavController *targetViewController = (MainNavController *)[_viewControllers objectAtIndex:index];
    targetViewController.view.frame = _containerView.frame;

    if (index == 0) {
        HomeController *homeVc = (HomeController *)[targetViewController.viewControllers objectAtIndex:0];;
        homeVc.tabBar = _tabBar;
        homeVc.index  = index;
        [self addTabBarOnSelectedController:homeVc];
    }else {
        
        UIViewController *selectedViewController = (UIViewController* )[targetViewController.viewControllers objectAtIndex:0];
        [self addTabBarOnSelectedController:selectedViewController];

    }
    //从MainNavController中取出第一个controller
   
  //  _selectedIndex = index;
    
    
    //如果是containerView的子View，直接置前；如果不是子view，添加到containerView上
    //当每个controller都已经被添加过后，则不需要再添加（addSubview，直接bringToFront就可以了
    if ([targetViewController.view isDescendantOfView:_containerView])
    {
        [_containerView bringSubviewToFront:targetViewController.view];

    }
    else
    {
        [_containerView addSubview:targetViewController.view];
        
    }
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController];
     }
    
    if ([_delegate respondsToSelector:@selector(didSelectedViewController:AtIndex:)]) {
        [_delegate didSelectedViewController:targetViewController AtIndex:index];
    }
    
}

- (void)showAnnounceViewAtIndex:(NSInteger)index {
        
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]]) {
            
            return;
        }
    }
    
    MainNavController *targetViewController = (MainNavController *)[_viewControllers objectAtIndex:index];
    AnnounceController *announceVC          = [[targetViewController viewControllers] objectAtIndex:0];
    announceVC.delegate                     = self;
    
    if ([_delegate respondsToSelector:@selector(didSelectedViewController:AtIndex:)]) {
        [_delegate didSelectedViewController:targetViewController AtIndex:index];
    }
    
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController];
    }
    
}

- (void)addTabBarOnSelectedController:(UIViewController *)viewController {
    
    [viewController.view addSubview:_tabBar];
    [_tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(viewController.view);
        make.bottom.equalTo(viewController.view.mas_bottom).offset(-8).priorityLow();

    }];
}

#pragma mark tabBar delegates
- (void)tabBar:(YWTabBar *)tabBar didSelectIndex:(NSInteger)index {
    if (index == 2) {
        
        [self showAnnounceViewAtIndex:index];

    }else {

        [self displayViewAtIndex:index];

    }
}

#pragma mark AnnounceControllerDelegate

- (void)jumpToHomeController {
    [self displayViewAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
