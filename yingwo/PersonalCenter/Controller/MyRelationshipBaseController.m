//
//  MyRelationshipBaseController.m
//  yingwo
//
//  Created by 王世杰 on 2016/11/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyRelationshipBaseController.h"

#import "YWMyRelationShipCell.h"

#import "RequestEntity.h"
#import "RelationViewModel.h"

@interface MyRelationshipBaseController ()<UITableViewDelegate,UITableViewDataSource,YWMyRelationShipCellDelegate>

@property (nonatomic, strong) UIScrollView                    *relationScrollView;
@property (nonatomic, strong) UITableView                     *relationTableView;
@property (nonatomic, strong) UILabel                         *countLabel;

@property (nonatomic, strong) RelationViewModel               *viewModel;

@property (nonatomic, assign) int                             *user_id;

@property (nonatomic, strong) NSArray                         *relationArr;

@end

static NSString *RELATION_CELL_IDENTIFIER = @"relationIdentifier";

@implementation MyRelationshipBaseController

- (instancetype)initWithRelationType:(RelationType)type {
    
    self = [super init];
    if (self) {
        self.relationType = type;
    }
    
    return self;
    
}

-(UIScrollView *)relationScrollView {
    if (_relationScrollView == nil) {
        _relationScrollView                         = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _relationScrollView.backgroundColor         = [UIColor clearColor];
        _relationScrollView.scrollEnabled           = YES;
        [_relationScrollView addSubview:self.relationTableView];
        [_relationScrollView addSubview:self.countLabel];

    }
    return _relationScrollView;
}

-(UITableView *)relationTableView {
    if (_relationTableView == nil) {
        _relationTableView                                      = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 85) style:UITableViewStylePlain];
        
        [_relationTableView registerClass:[YWMyRelationShipCell class]
                   forCellReuseIdentifier:RELATION_CELL_IDENTIFIER];
        _relationTableView.contentInset          = UIEdgeInsetsMake(0, 0, 100, 0);
        _relationTableView.layer.cornerRadius    = 10;
        _relationTableView.backgroundColor       = [UIColor clearColor];
        _relationTableView.delegate              = self;
        _relationTableView.dataSource            = self;
        _relationTableView.scrollEnabled         = NO;
        _relationTableView.separatorStyle        = UITableViewCellSeparatorStyleSingleLine;
        _relationTableView.separatorColor        = [UIColor colorWithHexString:@"#F5F5F5"];
        _relationTableView.separatorInset        = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    return _relationTableView;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel                     = [[UILabel alloc] init];
        _countLabel.textAlignment       = NSTextAlignmentCenter;
        _countLabel.textColor           = [UIColor colorWithHexString:THEME_COLOR_6];
        _countLabel.font                = [UIFont systemFontOfSize:14];
        _countLabel.text                = @"";
    }
    return _countLabel;
}

- (RequestEntity *)requestEntity {
    if (_requestEntity == nil) {
        _requestEntity              = [[RequestEntity alloc] init];
//        _requestEntity.user_id      = [[User findCustomer].userId intValue];
    }
    return _requestEntity;
}

- (RelationViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel                  = [[RelationViewModel alloc] init];
    }
    return _viewModel;
} 


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //不同的关系，不同的请求URL
    [self requestRelationType];
    
    [self.view addSubview:self.relationScrollView];

    [self hideExtraTableView:self.relationTableView];
    
    __weak MyRelationshipBaseController *weakSelf = self;
    self.relationScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithSubjctId:self.requestEntity];
    }];
    
    [self.relationScrollView.mj_header beginRefreshing];
    
    //最下端显示人数label
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.relationTableView.mas_bottom).offset(10);
        make.centerX.equalTo(self.relationTableView);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTitleAndLabel];

    self.navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)hideExtraTableView:(UITableView *)tableview {
    UIView *view              = [[UIView alloc] init];
    view.backgroundColor      = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableview.tableFooterView = view;
}

- (void)loadDataWithSubjctId:(RequestEntity *)requestEntity{
    
    @weakify(self);
    [[self.viewModel.fecthRelationEntityCommand execute:requestEntity] subscribeNext:^(NSArray *relationsArr) {
        
        @strongify(self);
        
        self.relationArr = [relationsArr mutableCopy];
        [self.relationScrollView.mj_header endRefreshing];
        [self.relationTableView reloadData];
        [self resetFrameAndContentSize];

    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

//每次刷新完数据后都更新tableview和scrollerView的frame和contentSize
- (void)resetFrameAndContentSize {
    self.relationScrollView.contentSize       = CGSizeMake(SCREEN_WIDTH, self.relationArr.count * 74 + 150);
    
    self.relationTableView.frame              = CGRectMake(10,
                                                        10,
                                                        SCREEN_WIDTH - 20,
                                                        self.relationArr.count * 74 );
}

//不同的关系，不同的请求URL
- (void)requestRelationType {
    switch (self.relationType) {
        case 1:
        {
            self.requestEntity.URLString = TA_USER_FRIEND_LIST_URL;
            break;
        }
        case 2:
        {
            self.requestEntity.URLString = TA_USER_LIKE_LIST_URL;
            break;
        }
        case 3:
        {
            self.requestEntity.URLString = TA_USER_LIKED_LIST_URL;
            break;
        }
        case 4:
        {
            self.requestEntity.URLString = nil;
            break;
        }
        case 5:
        {
            self.requestEntity.URLString = TA_USER_LIKE_LIST_URL;
            break;
        }
        case 6:
        {
            self.requestEntity.URLString = TA_USER_LIKED_LIST_URL;
            break;
        }
        default:
            break;
    }
}

//根据关系设置标题和底部label
- (void)setTitleAndLabel {
    switch (self.relationType) {
        case 1:
        {
            self.title           = @"我的好友";
            self.countLabel.text = [NSString stringWithFormat:@"共%d位好友",self.friendCnt];
            break;
        }
        case 2:
        {
            self.title           = @"我的关注";
            self.countLabel.text = [NSString stringWithFormat:@"共关注%d人",self.followCnt];
            break;
        }
        case 3:
        {
            self.title           = @"我的粉丝";
            self.countLabel.text = [NSString stringWithFormat:@"%d人关注了你",self.fansCnt];
            break;
        }
        case 4:
        {
            self.title           = @"我的访客";
            break;
        }
        case 5:
        {
            self.title           = @"Ta的关注";
            self.countLabel.text = [NSString stringWithFormat:@"共关注%d人",self.followCnt];
            break;
        }
        case 6:
        {
            self.title           = @"Ta的粉丝";
            self.countLabel.text = [NSString stringWithFormat:@"%d人关注了Ta",self.fansCnt];
            break;
        }
        default:
            break;
    }

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.relationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YWMyRelationShipCell *cell = [tableView dequeueReusableCellWithIdentifier:RELATION_CELL_IDENTIFIER
                                                                 forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RelationEntity *relation = [self.relationArr objectAtIndex:indexPath.row];
    
    [self.viewModel setupModelOfCell:cell model:relation];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击进入用户详情
    RelationEntity *relation = [self.relationArr objectAtIndex:indexPath.row];
    TAController *taVc = [[TAController alloc] initWithUserId:[relation.user_id intValue]];
    [self.navigationController pushViewController:taVc animated:YES];
}

@end

























