//
//  TopicItemController.m
//  yingwo
//
//  Created by apple on 2017/1/26.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "TopicItemController.h"
#import "DetailController.h"

#import "TopicViewModel.h"

//刷新的初始值
static int start_id = 0;
static CGFloat footerHeight = 250;

@interface TopicItemController ()

@property (nonatomic, strong) TopicViewModel    *topicViewModel;

@property (nonatomic,assign ) CGFloat           navgationBarHeight;

@end

@implementation TopicItemController

#pragma mark 懒加载

- (TopicViewModel *)topicViewModel {
    if (_topicViewModel == nil) {
        
        _topicViewModel = [[TopicViewModel alloc] init];
        
    }
    return _topicViewModel;
}

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.URLString = TIEZI_URL;
        //请求的事新鲜事
        _requestEntity.topic_id   = self.topic_id;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = NO;

    self.shouldClickTitle        = NO;
        
    [self showLoadingViewOnFrontView:self.tableView];
    
    [self loadDataWithRequestEntity:self.requestEntity];
    
    WeakSelf(self);
    self.tableView.mj_footer    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.requestEntity.start_id = 0;
    [self loadDataWithRequestEntity:self.requestEntity];
    
}


- (void)refreshData {
    self.requestEntity.start_id = start_id;
    [self loadDataWithRequestEntity:self.requestEntity];
}

- (void)loadMoreData {
    [self loadMoreDataWithRequestEntity:self.requestEntity];
}

/**
 *  下拉刷新
 */
- (void)loadDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    [self loadForType:1 RequestEntity:requestEntity];
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
    [[self.topicViewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        @strongify(self);
        
        [self showFrontView:self.tableView];
        
        //这里是倒序获取前10个
        if (tieZis.count > 0) {
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.tieZiList = [tieZis mutableCopy];
                [self.tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRelaod" object:nil];
                
                
            }else {
                
                [self.tieZiList addObjectsFromArray:tieZis];
                [self.tableView reloadData];
                
            }
            
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            TieZi *lastObject           = [tieZis objectAtIndex:tieZis.count-1];
            self.requestEntity.start_id = lastObject.tieZi_id;
            
        }
        else
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        //将topicSrcView获取homeTableview的contentSize
        self.tableViewSize       = CGSizeMake(self.topicSrcView.contentSize.width,
                                                   //   self.topicSrcView.contentSize.height +
                                                   self.tableView.contentSize.height +
                                                   footerHeight);
        
        //初始化为最新的contentSize
        self.topicSrcView.contentSize = self.tableViewSize;
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
        //错误的情况下停止刷新（网络错误）
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.model = [self.tieZiList objectAtIndex:indexPath.row];
    
    
    //点击跳转到详情里面
    if ([self.delegate respondsToSelector:@selector(didSelectCellWith:)]) {
        [self.delegate didSelectCellWith:self.model];
    }
}

#pragma mark YWGalleryCellBottomViewDelegate
- (void)didSelecteMessageWithBtn:(UIButton *)message {
    
    YWGalleryBaseCell *selectedCell = (YWGalleryBaseCell *)message.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.tableView indexPathForCell:selectedCell];
    
    self.model = [self.tieZiList objectAtIndex:indexPath.row];
    
    //点击跳转到详情里面
    if ([self.delegate respondsToSelector:@selector(didSelectCellWith:)]) {
        [self.delegate didSelectCellWith:self.model];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
