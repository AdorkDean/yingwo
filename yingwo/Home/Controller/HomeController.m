//
//  NHomeController.m
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "HomeController.h"
#import "SubjectPostController.h"

#import "CommonMacro.h"
#import "SCNavTabBar.h"
#import "SubjectPostViewModel.h"

@interface HomeController ()<YWDropDownViewDelegate,SCNavTabBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIBarButtonItem           *rightBarItem;
@property (nonatomic, strong) UIBarButtonItem           *leftBarButton;
@property (nonatomic, strong) YWDropDownView            *drorDownView;
@property (nonatomic, strong) YWPhotoCotentView         *contentView;

@property (nonatomic, strong) RequestEntity             *requestEntity;
@property (nonatomic, strong) SubjectPostViewModel      *subjectPostViewModel;

@property (nonatomic, strong) NSArray                   *subjectIdArr;
@property (nonatomic, strong) NSArray                   *subjectNameArr;
@property (nonatomic, strong) NSArray                   *subjectEntityArr;

@property (nonatomic, assign) NSUInteger                currentIndex;
@property (nonatomic, strong) SCNavTabBar               *navTabBar;

@end

@implementation HomeController

#pragma mark - 懒加载
- (UIBarButtonItem *)leftBarButton {
    if (_leftBarButton == nil) {
        _leftBarButton = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"screen"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(showDropDownView:)];
    }
    return _leftBarButton;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
//        UIView *rightBarItemContainer       = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        UIButton *rightBarBtn           = [[UIButton alloc] initWithFrame:rightBarItemContainer.bounds];
//        [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"magni"] forState:UIControlStateNormal];
////        [rightBarBtn addTarget:self action:@selector(nil) forControlEvents:UIControlEventTouchUpInside];
//        [rightBarItemContainer addSubview:rightBarBtn];
//        _rightBarItem = [[UIBarButtonItem alloc ] initWithCustomView:rightBarItemContainer];
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"magni"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:nil];
    }
    return _rightBarItem;
}

- (YWDropDownView *)drorDownView {
    if (_drorDownView == nil) {
        
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:4];
        [titles addObject:@"全部"];
        [titles addObject:@"新鲜事"];
        [titles addObject:@"关注的话题"];
        
        _drorDownView          = [[YWDropDownView alloc] initWithTitlesArr:titles
                                                                    height:90
                                                                     width:100];
        _drorDownView.delegate = self;
    }
    return _drorDownView;
}

-(SubjectPostViewModel *)subjectPostViewModel {
    if (_subjectPostViewModel == nil) {
        _subjectPostViewModel = [[SubjectPostViewModel alloc] init];
    }
    return _subjectPostViewModel;
}

-(AllPostController *)allPostController {
    if (_allPostController == nil) {
        _allPostController = [[AllPostController alloc] init];
        _allPostController.tabBar = self.tabBar;
    }
    return _allPostController;
}

#pragma mark button action

- (void)showDropDownView:(UIBarButtonItem *)sender {
    
    if (self.drorDownView.isPopDropDownView == NO) {
        
        [self.drorDownView showDropDownView];
        self.drorDownView.isPopDropDownView = YES;
        
    }else {
        
        [self.drorDownView hideDropDownView];
        self.drorDownView.isPopDropDownView = NO;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //下拉列表
    [self.navigationController.view addSubview:self.drorDownView];
    
    [self.tabBar selectTabAtIndex:self.index];    

   // NSLog(@"home:%@",NSHomeDirectory());
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"南京工业大学";
    
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    
    [self stopSystemPopGestureRecognizer];
    
    [self.allPostController showTabBar:YES withTabBar:self.tabBar animated:YES];
    
}

-(void)initDataSourceBlock {
    
    [self loadAllRecommendTopicList];
    
    WeakSelf(self);
    [self.subjectPostViewModel setSuccessBlock:^(NSArray *subjectArr) {
        weakself.subjectIdArr = [subjectArr firstObject];
        weakself.subjectNameArr = [subjectArr objectAtIndex:1];
        weakself.subjectEntityArr = [subjectArr lastObject];
        
        [weakself initControllers];

    } errorBlock:^(id error) {
        
    }];
}

- (void)initControllers {

    NSMutableArray *controllerArr       = [NSMutableArray array];
    self.allPostController.title        = @"全部";
    [controllerArr addObject:self.allPostController];
    
    for (int i = 0; i < self.subjectNameArr.count; i++) {
        SubjectPostController *subjectPostVc    = [[SubjectPostController alloc] init];
        subjectPostVc.title                     = self.subjectNameArr[i];
        subjectPostVc.subject_id                = [self.subjectIdArr[i] intValue];
        subjectPostVc.subjectEntity             = self.subjectEntityArr[i];
        subjectPostVc.tabBar                    = self.tabBar;
        
        [controllerArr addObject:subjectPostVc];
    }
    
    self.subViewControllers = controllerArr;
    
    [self initConfig];
    [self viewConfig];
    
    [self.view bringSubviewToFront:self.tabBar];
}

- (void)initConfig {
    self.currentIndex = 1;

    self.navTabBarColor = [UIColor colorWithWhite:1 alpha:0.95];
    self.navTabBarLineColor = [UIColor colorWithHexString:THEME_COLOR_1];
    self.navTabBarFont = [UIFont systemFontOfSize:15];
    self.canPopAllItemMenu = YES;
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:self.subViewControllers.count];
    
    for (UIViewController *vc in self.subViewControllers) {
        [tempArr addObject:vc.title];
    }
    self.subjectNameArr = tempArr;
}

- (void)viewConfig {
    [self viewInit];

    //首先加载第一个视图
    UIViewController *viewController = (UIViewController *)self.subViewControllers[0];
    viewController.view.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
}

- (void)viewInit {
    _canPopAllItemMenu = YES;
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE,
                                                               DOT_COORDINATE,
                                                               SCREEN_WIDTH,
                                                               NAV_TAB_BAR_HEIGHT) canPopAllItemMenu:_canPopAllItemMenu];
    _navTabBar.delegate             = self;
    _navTabBar.backgroundColor      = _navTabBarColor;
    _navTabBar.lineColor            = _navTabBarLineColor;
    _navTabBar.itemTitles           = self.subjectNameArr;
    _navTabBar.arrowImage           = _navTabBarArrowImage;
    _navTabBar.titleFont            = _navTabBarFont;
    [_navTabBar updateData];
    
   _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                              _navTabBar.frame.origin.y + _navTabBar.frame.size.height,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT - _navTabBar.frame.origin.y - _navTabBar.frame.size.height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    _mainView.delegate                          = self;
    _mainView.pagingEnabled                     = YES;
    _mainView.bounces                           = _mainViewBounces;
    _mainView.showsHorizontalScrollIndicator    = NO;
    _mainView.showsVerticalScrollIndicator      = NO;
    _mainView.contentSize                       = CGSizeMake(SCREEN_WIDTH * self.subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    [self.view addSubview:_navTabBar];
    
}

#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentItemIndex = self.currentIndex;
    
    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController *viewController = (UIViewController *)self.subViewControllers[self.currentIndex];
    viewController.view.frame = CGRectMake(self.currentIndex * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];

}

#pragma mark - SCNavTabBarDelegate Methods
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, DOT_COORDINATE) animated:_scrollAnimation];
}

- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height
{
    if (pop)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, SCREEN_HEIGHT - _navTabBar.frame.origin.y);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, NAV_TAB_BAR_HEIGHT);
        }];
    }
    [_navTabBar refresh];
}

#pragma mark ---- DropDownViewDelegate
- (void)seletedDropDownViewAtIndex:(NSInteger)index {
    self.requestEntity.filter = (int)index;
//    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)loadAllRecommendTopicList {
    
    RequestEntity *request = [[RequestEntity alloc] init];
    request.URLString      = RECOMMEND_ALLTOPIC_URL;
    request.parameter      = @{};
    
    [self.subjectPostViewModel requestAllRecommendTopicListWith:request];
    
}

@end
