//
//  NHomeController.m
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()<YWDropDownViewDelegate>

@property (nonatomic, strong) UIBarButtonItem   *rightBarItem;
@property (nonatomic, strong) UIBarButtonItem   *leftBarItem;
@property (nonatomic, strong) YWDropDownView    *drorDownView;
@property (nonatomic, strong) YWPhotoCotentView *contentView;

@property (nonatomic, strong) RequestEntity     *requestEntity;

@property (nonatomic, strong) NSMutableArray    *tieZiList;

@end

@implementation HomeController


//刷新的初始值
static int start_id = 0;

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.URLString = HOME_URL;
        //请求的事新鲜事
        _requestEntity.filter     = AllThingModel;
        //偏移量开始为0
        _requestEntity.start_id   = start_id;
    }
    return _requestEntity;
}

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"screen"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(showDropDownView:)];
    }
    return _leftBarItem;
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
    

    [self addRefreshForTableView];

    NSLog(@"home:%@",NSHomeDirectory());
}

- (void)addRefreshForTableView {
    
    __weak HomeController *weakSelf = self;
    self.tableView.mj_header        = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //偏移量开始为0
        self.requestEntity.start_id  = start_id;
        
        [weakSelf loadDataWithRequestEntity:self.requestEntity];
    }];
    
    self.tableView.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"南京工业大学";
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    
    
    [self stopSystemPopGestureRecognizer];
    
    [self showTabBar:YES animated:YES];
    
}


#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}

/**
 *  下拉刷新
 */
- (void)loadDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    //检测登录状态
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isExit            = [userDefault objectForKey:@"isUserInfoExit"];
    
    if ([isExit intValue] == 0) {
  //      [self testLoginState];
    }
    
 //   [self requestNewTieziCount];
    
    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.tableView.mj_footer resetNoMoreData];
}

/**
 *  上拉刷新
 */
- (void)loadMoreDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    [self loadForType:2 RequestEntity:requestEntity];
}

- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    
    @weakify(self);
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        @strongify(self);
        //这里是倒序获取前10个
        if (tieZis.count > 0) {
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.tieZiList = [tieZis mutableCopy];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                
                //刷新后清除小红点
                [self.tabBar.homeBtn clearBadge];
                //显示新帖子View
              //  [self showNewTieziCount:self.badgeCount];
                
            }else { 
                
                [self.tieZiList addObjectsFromArray:tieZis];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            TieZi *lastObject           = [tieZis objectAtIndex:tieZis.count-1];
            self.requestEntity.start_id = lastObject.tieZi_id;
            
        }
        else
        {
            //没有任何数据
            if (tieZis.count == 0 && requestEntity.start_id == 0) {
                
                self.tieZiList = nil;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                //显示新帖子View
               // [self showNewTieziCount:self.badgeCount];
                
            }
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
        //错误的情况下停止刷新（网络错误）
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark -- UIScrollViewDelegate

//tabar隐藏滑动距离设置
//滑动100pt后隐藏TabBar
CGFloat scrollHiddenSpace = 5;
CGFloat lastPosition = -4;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        CGFloat currentPosition = scrollView.contentOffset.y;
        if (currentPosition > -400 && currentPosition < 0) {
            
            [self showTabBar:YES animated:YES];
            
        }else if ( currentPosition - lastPosition > scrollHiddenSpace ) {
            
            lastPosition = currentPosition;
            [self hidesTabBar:YES animated:YES];
            
        }else if(lastPosition - currentPosition > scrollHiddenSpace){
            
            lastPosition = currentPosition;
            [self showTabBar:YES animated:YES];
            
        }
    }
    
}

#pragma mark ---- DropDownViewDelegate
- (void)seletedDropDownViewAtIndex:(NSInteger)index {
    self.requestEntity.filter = (int)index;
    [self.tableView.mj_header beginRefreshing];
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



@end
