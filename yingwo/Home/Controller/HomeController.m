//
//  NHomeController.m
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "HomeController.h"
#import "SCNavTabBarController.h"
#import "SubjectPostController.h"

#import "SubjectPostViewModel.h"

@interface HomeController ()<YWDropDownViewDelegate>

@property (nonatomic, strong) UIBarButtonItem           *rightBarItem;
@property (nonatomic, strong) UIBarButtonItem           *leftBarButton;
@property (nonatomic, strong) YWDropDownView            *drorDownView;
@property (nonatomic, strong) YWPhotoCotentView         *contentView;

@property (nonatomic, strong) RequestEntity             *requestEntity;
@property (nonatomic, strong) SubjectPostViewModel      *subjectPostViewModel;

@property (nonatomic, strong) NSArray                   *subjectIdArr;
@property (nonatomic, strong) NSArray                   *subjectNameArr;
@property (nonatomic, strong) NSArray                   *subjectEntityArr;

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
    
    [self loadAllRecommendTopicList];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"南京工业大学";
    self.navigationItem.leftBarButtonItem  = self.leftBarButton;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    
    [self stopSystemPopGestureRecognizer];
    
    [self showTabBar:YES animated:YES];
    
//    [self.view bringSubviewToFront:self.tabBar];
}

-(void)layoutSubviews {
    
//    self.allPostController.tabBar = self.tabBar;
    
}
-(void)initDataSourceBlock {
    
    [self loadAllRecommendTopicList];
    
    WeakSelf(self);
    [self.subjectPostViewModel setSuccessBlock:^(NSArray *subjectArr) {
        weakself.subjectIdArr = [subjectArr firstObject];
        weakself.subjectNameArr = [subjectArr objectAtIndex:1];
        weakself.subjectEntityArr = [subjectArr lastObject];
        
        [weakself initController];

    } errorBlock:^(id error) {
        
    }];
}

- (void)initController {

    NSMutableArray *controllerArr       = [NSMutableArray array];
    self.allPostController.title                     = @"全部";
    
    [controllerArr addObject:self.allPostController];
    
    for (int i = 0; i < self.subjectNameArr.count; i++) {
        SubjectPostController *subjectPostVc = [[SubjectPostController alloc] init];
        subjectPostVc.title = self.subjectNameArr[i];
        subjectPostVc.subject_id = [self.subjectIdArr[i] intValue];
        subjectPostVc.subjectEntity = self.subjectEntityArr[i];

        [controllerArr addObject:subjectPostVc];
    }
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] initWithSubViewControllers:controllerArr];
    
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    navTabBarController.navTabBarLineColor = [UIColor colorWithHexString:THEME_COLOR_1];
    navTabBarController.navTabBarFont = [UIFont systemFontOfSize: 15];

    navTabBarController.canPopAllItemMenu = YES;
    [navTabBarController addParentController: self];

}


#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}


#pragma mark -- UIScrollViewDelegate

//tabar隐藏滑动距离设置
//滑动100pt后隐藏TabBar
CGFloat scrollHiddenSpace = 5;
CGFloat lastPosition = -4;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    if (scrollView == self.tableView) {
//        
//        CGFloat currentPosition = scrollView.contentOffset.y;
//        if (currentPosition > -400 && currentPosition < 0) {
//            
//            [self showTabBar:YES animated:YES];
//            
//        }else if ( currentPosition - lastPosition > scrollHiddenSpace ) {
//            
//            lastPosition = currentPosition;
//            [self hidesTabBar:YES animated:YES];
//            
//        }else if(lastPosition - currentPosition > scrollHiddenSpace){
//            
//            lastPosition = currentPosition;
//            [self showTabBar:YES animated:YES];
//            
//        }
//    }
    
}

#pragma mark ---- DropDownViewDelegate
- (void)seletedDropDownViewAtIndex:(NSInteger)index {
    self.requestEntity.filter = (int)index;
//    [self.tableView.mj_header beginRefreshing];
}

- (void)hidesTabBar:(BOOL)yesOrNo animated:(BOOL)animated {
    
    //动画隐藏
    if (animated == yesOrNo) {
        if (yesOrNo == YES) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT);
            }];
            
        }
    }else {
        if (yesOrNo == YES)
        {
            self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT);
            
        }
        
    }
}

- (void)showTabBar:(BOOL)yesOrNo animated:(BOOL)animated {
    
    //动画隐藏
    if (animated == yesOrNo) {
        if (yesOrNo == YES) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT-self.tabBar.height*2+4);
            }];
            
        }
    }else {
        if (yesOrNo == YES)
        {
            self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT-self.tabBar.height*2+4);
            
        }
        
    }
    
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
