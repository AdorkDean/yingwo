//
//  TopicController.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicListController.h"

#import "YWTopicViewCell.h"

#import "TopicListViewModel.h"

#import "TopicEntity.h"

@interface TopicListController ()<UITableViewDelegate,UITableViewDataSource,YWTopicViewCellDelegate>

<<<<<<< HEAD
@property (nonatomic, strong) UITableView        *topicTableView;
@property (nonatomic, strong) UIBarButtonItem    *leftBarItem;
@property (nonatomic, strong) UIBarButtonItem    *rightBarItem;

@property (nonatomic, strong) UIButton           *addTopicBtn;


@property (nonatomic, strong) TopicListViewModel *viewModel;

@property (nonatomic, strong) RequestEntity      *requestEntity;

=======
@property (nonatomic, strong) UITableView     *topicTableView;
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@property (nonatomic, strong) UIButton        *addTopicBtn;


@property (nonatomic, strong) TopicListViewModel  *viewModel;
>>>>>>> origin/master

@end

static NSString *TOPIC_CELL_IDENTIFIER = @"topicIdentifier";

@implementation TopicListController

- (UITableView *)topicTableView {
    if (_topicTableView == nil) {
        _topicTableView                    = [[UITableView alloc ]initWithFrame:CGRectMake(10,
                                                                                   10,
                                                                                   SCREEN_WIDTH-20,
                                                                                   SCREEN_HEIGHT-10)

                                                                  style:UITableViewStylePlain];
        [_topicTableView registerClass:[YWTopicViewCell class]
                forCellReuseIdentifier:TOPIC_CELL_IDENTIFIER];
        _topicTableView.layer.cornerRadius = 10;
        _topicTableView.backgroundColor    = [UIColor clearColor];
        _topicTableView.delegate           = self;
        _topicTableView.dataSource         = self;
    }
    return _topicTableView;
}

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(jumpToDiscoveryPage)];
    }
    return _leftBarItem;
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
        [_addTopicBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
                                forState:UIControlStateNormal];
    }
    return _addTopicBtn;
}

<<<<<<< HEAD
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
=======

- (TopicListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TopicListViewModel alloc] init];
>>>>>>> origin/master
    }
    return _viewModel;
}

#pragma mark all action

- (void) jumpToDiscoveryPage {
    [self.navigationController popViewControllerAnimated:YES];
}

<<<<<<< HEAD


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
        self.title = @"知识技能";
    }

}

=======
>>>>>>> origin/master
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topicTableView];
    [self hideExtraTableView:self.topicTableView];
<<<<<<< HEAD
    
    __weak TopicListController *weakSelf = self;
    self.topicTableView.mj_header        = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [weakSelf loadDataWithSubjctId:self.requestEntity];
    }];
    
    [self.topicTableView.mj_header beginRefreshing];
    
=======
>>>>>>> origin/master
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
<<<<<<< HEAD
=======
    self.title = self.subject;
>>>>>>> origin/master
    
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)hideExtraTableView:(UITableView *)tableview {
    UIView *view              = [[UIView alloc] init];
    view.backgroundColor      = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableview.tableFooterView = view;
}

<<<<<<< HEAD
- (void)loadDataWithSubjctId:(RequestEntity *)requestEntity{
    
    @weakify(self);
    [[self.viewModel.fecthTopicEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        
        @strongify(self);
        
        self.topicArr = [tieZis mutableCopy];
        [self.topicTableView reloadData];
        [self.topicTableView.mj_header endRefreshing];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];

    
}

=======
>>>>>>> origin/master

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
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

@end
