//
//  AllPostController.m
//  yingwo
//
//  Created by 王世杰 on 2017/3/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "AllPostController.h"
//#import "MainController.h"

//刷新的初始值
static int start_id = 0;

@interface AllPostController ()

@property (nonatomic, strong) RequestEntity     *requestEntity;

@end

@implementation AllPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addRefreshForTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotification) name:@"刷新" object:nil];
    
//    MainController *mainVc = [[MainController alloc] init];
//    mainVc.homeBadgeBlock = ^(int badgeCount) {
//        NSLog(@"有新的badge,%d",badgeCount);
//    };
    
}

#pragma mark 懒加载
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

- (void)addRefreshForTableView {
    
    WeakSelf(self);
    self.tableView.mj_header        = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //偏移量开始为0
        self.requestEntity.start_id  = start_id;
        
        [weakself loadDataWithRequestEntity:self.requestEntity];
    }];
    
    self.tableView.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshNotification {
    [self.tableView.mj_header beginRefreshing];
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
                //[self showNewTieziCount:self.badgeCount];
                
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
