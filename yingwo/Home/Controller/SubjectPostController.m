//
//  SubjectPostController.m
//  yingwo
//
//  Created by 王世杰 on 2017/3/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "SubjectPostController.h"
#import "YWTopicScrView.h"
#import "SubjectPostViewModel.h"

static int start_id = 0;

@interface SubjectPostController ()<YWTopicScrViewDelegate>

@property (nonatomic, strong) RequestEntity             *requestEntity;
@property (nonatomic, strong) YWTopicScrView            *topicScrView;
@property (nonatomic, strong) SubjectPostViewModel      *subjectPostViewModel;
@property (nonatomic, strong) NSArray                   *subjectArr;

@property (nonatomic, assign) int                       field_id;
@property (nonatomic, assign) int                       topic_id;

@end

@implementation SubjectPostController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addRefreshForTableView];
    
    //通知刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNotification)
                                                 name:@"刷新" object:nil];
    
    [self setupTableHeaderView];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}
#pragma mark 懒加载
- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.URLString  = TIEZI_URL;
        //请求的话题
        _requestEntity.topic_id  = self.topic_id;
        //请求的主题
        _requestEntity.subject_id = self.subject_id;
        //偏移量开始为0
        _requestEntity.start_id   = start_id;
        
    }
    return _requestEntity;
}

-(YWTopicScrView *)topicScrView {
    if (_topicScrView == nil) {
        _topicScrView = [[YWTopicScrView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        _topicScrView.Scrdelegate = self;
    }
    return _topicScrView;
}

-(SubjectPostViewModel *)subjectPostViewModel {
    if (_subjectPostViewModel == nil) {
        _subjectPostViewModel = [[SubjectPostViewModel alloc] init];
    }
    return _subjectPostViewModel;
}

- (void)setupTableHeaderView {
    
    self.tableView.sectionHeaderHeight = 35;
    self.tableView.tableHeaderView = self.topicScrView;
    
    [self.subjectPostViewModel setupModelForFieldTopicOfCell:self.topicScrView model:self.subjectEntity];
    
}

- (void)addRefreshForTableView {
    
    [self showLoadingViewOnFrontView:self.tableView];

    WeakSelf(self);
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        //偏移量开始为0
        weakself.requestEntity.start_id  = start_id;
        
        [weakself loadDataWithRequestEntity:self.requestEntity];
        
    }];

    
    [header setHeaderRefreshWithCustomImages];
    
    self.tableView.mj_header = header;
    
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
    
    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.tableView.mj_footer resetNoMoreData];
}

/**
 *  上拉刷新
 */
- (void)loadMoreDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    [self loadForType:2 RequestEntity:requestEntity];
}

/**
 *  下拉、上拉刷新
 *
 *  @param type  上拉or下拉
 *  @param model 刷新类别：所有帖、新鲜事、好友动态、关注的话题
 */
- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    
    @weakify(self);
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        @strongify(self);
        
        [self showFrontView:self.tableView];
        //这里是倒序获取前10个
        if (tieZis.count > 0) {
            
            self.emptyRemindView.hidden = YES;
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.tieZiList = [tieZis mutableCopy];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
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
                self.emptyRemindView.hidden = NO;
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

#pragma mark YWTopicScrViewDelegate
-(void)topicDidSelectLabel:(YWTitle *)label withTopicId:(int)topicId {

    self.topic_id = topicId;
    self.requestEntity.topic_id = topicId;
    
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark -- UIScrollViewDelegate

//滑动100pt后隐藏TabBar
//tabar隐藏滑动距离设置
CGFloat scrollHiddenSpace1 = 5;
CGFloat lastPosition1 = -4;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        CGFloat currentPosition = scrollView.contentOffset.y;
        if (currentPosition > -400 && currentPosition < 0) {
            
                            [self showTabBar:YES withTabBar:self.tabBar animated:YES];
            
        }else if ( currentPosition - lastPosition1 > scrollHiddenSpace1 ) {
            
            lastPosition1 = currentPosition;
                            [self hidesTabBar:YES withTabBar:self.tabBar animated:YES];
            
        }else if(lastPosition1 - currentPosition > scrollHiddenSpace1){
            
            lastPosition1 = currentPosition;
                            [self showTabBar:YES withTabBar:self.tabBar animated:YES];
            
        }
    }
}

@end
