//
//  TopicController.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicListController.h"

#import "YWTopicViewCell.h"

#import "TopicEntity.h"

#import "TopicController.h"

@interface TopicListController ()<UITableViewDelegate,UITableViewDataSource,YWTopicViewCellDelegate>

@property (nonatomic, strong) UIBarButtonItem    *rightBarItem;

@property (nonatomic, strong) UIButton           *addTopicBtn;

@property (nonatomic, strong) TopicEntity        *topicEntity;

@property (nonatomic, strong) RequestEntity      *requestEntity;

@property (nonatomic, strong) YWEmptyRemindView  *emptyRemindView;


@end

static NSString *TOPIC_CELL_IDENTIFIER = @"topicIdentifier";

@implementation TopicListController

- (instancetype)initWithSubjectId:(int)subjectId subjectName:(NSString *)subjectName {
    
    self = [super init];
    
    if (self) {
        self.subject_id = subjectId;
        self.subject = subjectName;
    }
    return self;
}

-(UIScrollView *)topicScrollView {
    if (_topicScrollView == nil) {
        _topicScrollView                   = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                            0,
                                                                                            SCREEN_WIDTH,
                                                                                            SCREEN_HEIGHT)];
        _topicScrollView.backgroundColor   = [UIColor clearColor];
        _topicScrollView.scrollEnabled     = YES;
        [_topicScrollView addSubview:self.topicTableView];
    }
    return _topicScrollView;
}

- (UITableView *)topicTableView {
    if (_topicTableView == nil) {
        _topicTableView                    = [[UITableView alloc ] initWithFrame:CGRectMake(10,
                                                                                            10,
                                                                                            SCREEN_WIDTH - 20,
                                                                                            SCREEN_HEIGHT - 85)
                                                                           style:UITableViewStylePlain];
        
        
        [_topicTableView registerClass:[YWTopicViewCell class]
                forCellReuseIdentifier:TOPIC_CELL_IDENTIFIER];
        _topicTableView.contentInset       = UIEdgeInsetsMake(0, 0, 100, 0);
        _topicTableView.layer.cornerRadius = 10;
        _topicTableView.backgroundColor    = [UIColor clearColor];
        _topicTableView.delegate           = self;
        _topicTableView.dataSource         = self;
        _topicTableView.scrollEnabled      = NO;
    }
    return _topicTableView;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"share"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:nil];
    }
    return _rightBarItem;
}

- (UIButton *)addTopicBtn {
    if (_addTopicBtn == nil) {
        _addTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_addTopicBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
//                                forState:UIControlStateNormal];
    }
    return _addTopicBtn;
}

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        _requestEntity.subject_id = self.subject_id;
        _requestEntity.field_id   = self.field_id;
    }
    return _requestEntity;
}

- (TopicListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel           = [[TopicListViewModel alloc] init];
        _viewModel.isMyTopic = self.isMyTopic;
        _viewModel.user_id   = self.userId;
        
    }
    return _viewModel;
}

-(TopicEntity *)topicEntity {
    if (_topicEntity == nil) {
        _topicEntity            = [[TopicEntity alloc] init];
        
    }
    return _topicEntity;
}

-(YWEmptyRemindView *)emptyRemindView {
    if (_emptyRemindView == nil) {
        _emptyRemindView                 = [[YWEmptyRemindView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                            andText:@"还没有关注话题哦~"];
        [self.topicScrollView addSubview:_emptyRemindView];
    }
    return _emptyRemindView;
}

#pragma mark all action


-(void)loadViewIfNeeded {
    
    if (self.topicType == AllTopicModel) {
        
        self.title = self.subject;
        
    }
    else if (self.topicType == OneFieldModel)
    {
        self.title = @"校园生活";
    }
    else if (self.topicType == TwoFieldModel)
    {
        self.title = @"兴趣爱好";
    }
    else if (self.topicType == ThreeFieldModel)
    {
        self.title = @"学科专业";
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topicScrollView];
    [self hideExtraTableView:self.topicTableView];
    
    __weak TopicListController *weakSelf = self;
    self.topicScrollView.mj_header        = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithSubjctId:self.requestEntity];
    }];
    
    [self.topicScrollView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
    self.title                            = self.subject;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)hideExtraTableView:(UITableView *)tableview {
    UIView *view              = [[UIView alloc] init];
    view.backgroundColor      = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableview.tableFooterView = view;
}

- (void)loadDataWithSubjctId:(RequestEntity *)requestEntity{
    
    @weakify(self);
    [[self.viewModel.fecthTopicEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        
        @strongify(self);
        
        self.topicArr = [tieZis mutableCopy];
        [self.topicScrollView.mj_header endRefreshing];
        [self.topicTableView reloadData];
        [self resetFrameAndContentSize];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

//每次刷新完数据后都更新tableview和scrollerView的frame和contentSize
- (void)resetFrameAndContentSize {
    self.topicScrollView.contentSize       = CGSizeMake(SCREEN_WIDTH, self.topicArr.count * 82 + 150);
    
    self.topicTableView.frame              = CGRectMake(10,
                                                        10,
                                                        SCREEN_WIDTH - 20,
                                                        self.topicArr.count * 82 );
    
    if (!self.topicArr.count) {
        self.emptyRemindView.hidden  = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YWTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPIC_CELL_IDENTIFIER
                                                            forIndexPath:indexPath];

    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    cell.delegate         = self;

    TopicEntity *topic    = [self.topicArr objectAtIndex:indexPath.row];

    [self.viewModel setupModelOfCell:cell model:topic];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    TopicEntity *topic = [self.topicArr objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didSelectTopicListWith:)]) {
        
        [self.delegate didSelectTopicListWith:[topic.topic_id intValue]];
        
    }
    else
    {
        [self jumpToTopicPageWithTopicId:[topic.topic_id intValue]];
    }
    
}

#pragma mark YWTopicViewCellDelegate

- (void)didSelectRightBtnWith:(int)value {
    
    if (value == 1) {
        [SVProgressHUD showSuccessStatus:@"关注成功" afterDelay:HUD_DELAY];
    }
    else if(value == 0)
    {
        [SVProgressHUD showSuccessStatus:@"取消关注" afterDelay:HUD_DELAY];
    }
    else
    {
        [SVProgressHUD showErrorStatus:@"关注失败" afterDelay:HUD_DELAY];
    }
    
}

- (void)jumpToTopicPageWithTopicId:(int)topicId {
    
    TopicController *topicVc = [[TopicController alloc] initWithTopicId:topicId];
    [self.navigationController pushViewController:topicVc animated:YES];
}



@end
