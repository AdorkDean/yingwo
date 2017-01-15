//
//  HotDiscussController.m
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "HotDiscussController.h"

#import "YWHotDiscussCell.h"


@interface HotDiscussController ()<UITableViewDelegate,UITableViewDataSource,YWLabelDelegate>

@property (nonatomic, strong) UITableView          *tableView;

@property (nonatomic, strong) HotDisscussViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray       *dataSource;

@property (nonatomic, strong) RequestEntity       *requestEntity;

@end

@implementation HotDiscussController

- (HotDisscussViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[HotDisscussViewModel alloc] init];
    }
    return _viewModel;
}

static NSString *cellIdentifier = @"disscussCell";

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.contentInset    = UIEdgeInsetsMake(0, 0, 65, 0);
        [_tableView registerClass:[YWHotDiscussCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

static int start_id = 0;

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.requestUrl = HOT_DISCUSS_URL;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.title = @"热议";
    
    __weak HotDiscussController *weakself = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.requestEntity.start_id = start_id;
        [weakself loadDataWithRequestEntity:self.requestEntity];
        
    } ];
    
    self.tableView.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];

    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark UITableView Delegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (YWHotDiscussCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YWHotDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    [self.viewModel setupModelOfCell:cell model:self.dataSource[indexPath.row]];
    cell.topView.title.delegate     = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.dataSource[indexPath.row]];
                                       }];}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.model = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didSelectHotDisTopicWith:)]) {
        [self.delegate didSelectHotDisTopicWith:self.model];
    }
}

#pragma mark YWLabelDelegate

- (void)didSelectLabel:(YWLabel *)label {
    
    if ([self.delegate respondsToSelector:@selector(didSelectHotDisTopicLabelWith:)]) {
        [self.delegate didSelectHotDisTopicLabelWith:label.topic_id];
    }
    
}

#pragma mark private method

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
 */
- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    if (![YWNetworkTools networkStauts]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    @weakify(self);
    [[self.viewModel.fecthTopicEntityCommand execute:requestEntity] subscribeNext:^(NSArray *items) {
        @strongify(self);
        //这里是倒序获取前10个
        if (items.count > 0) {
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",items);
                self.dataSource = [items mutableCopy];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];

            }else {
                
                [self.dataSource addObjectsFromArray:items];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            HotDiscussEntity *lastObject           = [items objectAtIndex:items.count-1];
            self.requestEntity.start_id = lastObject.count;
            
        }
        else
        {
            //没有任何数据
            if (items.count == 0 && requestEntity.start_id == 0) {
                
                self.dataSource = nil;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                //显示新帖子View
                
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
