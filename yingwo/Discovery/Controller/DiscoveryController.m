//
//  YWDiscoveryController.m
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DiscoveryController.h"
#import "TopicListController.h"
#import "TopicController.h"

#import "UIViewAdditions.h"
#import "DiscoveryViewModel.h"

#import "YWDiscoveryBaseCell.h"
#import "YWBannerTableViewCell.h"
#import "YWSubjectViewCell.h"

//导航条图片高度
static CGFloat const bannerHeight         = 150;

static NSString *YWBANNER_CELL_IDENTIFIER = @"bannerCell";
static NSString *SUBJECT_CELL_IDENTIER    = @"subjectCell";

@interface DiscoveryController ()<UITableViewDataSource,UITableViewDelegate,MXScrollViewDelegate,YWSubjectViewCellDelegate>
@property (nonatomic, strong) UITableView         *tableView;
@property (nonatomic, strong) YWDiscoveryBaseCell *segmentViewCell;
@property (nonatomic, strong) NSMutableArray      *bannerArr;
@property (nonatomic, strong) UIView              *coverView;

@property (nonatomic, strong) RequestEntity       *requestEntity;
@property (nonatomic, strong) FieldEntity         *fieldEntity;

@property (nonatomic, assign) CGFloat             navgationBarHeight;
@property (nonatomic, strong) DiscoveryViewModel  *viewModel;

@property (nonatomic, strong) UIView              *fieldView;
@property (nonatomic, strong) UIButton            *firstFieldBtn;
@property (nonatomic, strong) UIButton            *secondFieldBtn;
@property (nonatomic, strong) UIButton            *thirdFieldBtn;


//主题下话题数组
@property (nonatomic, strong) NSArray             *subjectArr;


//点击选中的推荐主题
@property (nonatomic, assign) NSInteger         selectIndex;

@end

//刷新的初始值
static int start_id = 0;

@implementation DiscoveryController

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                                            0,
                                                                                            self.view.width,
                                                                                            self.navgationBarHeight+self.view.height)
                                                                           style:UITableViewStylePlain];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.allowsSelection = NO;
        _tableView.tag             = 101;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        
        _tableView.contentInset    = UIEdgeInsetsMake(0, 0, 300, 0);
        [_tableView registerClass:[YWBannerTableViewCell class]
                    forCellReuseIdentifier:YWBANNER_CELL_IDENTIFIER];
        [_tableView registerClass:[YWSubjectViewCell class]
                    forCellReuseIdentifier:SUBJECT_CELL_IDENTIER];
        
    }
    return _tableView;
}

- (DiscoveryViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[DiscoveryViewModel alloc] init];
    }
    return _viewModel;
}


- (CGFloat)navgationBarHeight {
    //导航栏＋状态栏高度
    return  self.navigationController.navigationBar.height +
    [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (UIButton *)firstFieldBtn {
    if (_firstFieldBtn == nil) {
        _firstFieldBtn                 = [[UIButton alloc] init];
        _firstFieldBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _firstFieldBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1]
                             forState:UIControlStateNormal];

        [_firstFieldBtn addTarget:self
                           action:@selector(firstFieldBtnSetFieldId)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _firstFieldBtn;
}

- (UIButton *)secondFieldBtn {
    
    
    
    if (_secondFieldBtn == nil) {
        _secondFieldBtn                 = [[UIButton alloc] init];
        _secondFieldBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _secondFieldBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
        [_secondFieldBtn addTarget:self
                            action:@selector(secondFieldBtnSetFieldtId)
                  forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _secondFieldBtn;
}

- (UIButton *)thirdFieldBtn {
    if (_thirdFieldBtn == nil) {
        _thirdFieldBtn                 = [[UIButton alloc] init];
        _thirdFieldBtn.titleLabel.font = [UIFont systemFontOfSize:16 ];
        _thirdFieldBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];

        [_thirdFieldBtn addTarget:self
                           action:@selector(thirdFieldBtnSetFieldtId)
                 forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _thirdFieldBtn;
}


- (UIView *)fieldView {
    if (_fieldView == nil) {
        _fieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _fieldView.backgroundColor = [UIColor whiteColor];
        
        [_fieldView addSubview:self.firstFieldBtn];
        [_fieldView addSubview:self.secondFieldBtn];
        [_fieldView addSubview:self.thirdFieldBtn];
        
        [self.firstFieldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fieldView.mas_left).offset(30);
            make.centerY.equalTo(_fieldView);
        }];
        
        [self.secondFieldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_fieldView);
        }];
        
        [self.thirdFieldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_fieldView);
            make.right.equalTo(_fieldView.mas_right).offset(-30);
        }];
        
    }
    return _fieldView;
}

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.URLString = HOT_TOPIC_URL;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
}



- (void)layoutSubviews {
    
    [self.view addSubview:self.tableView];
    //添加遮挡视图，遮盖刷新前显示出的部分    
    
    __weak DiscoveryController *weakself = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.requestEntity.URLString = HOT_TOPIC_URL;
        [weakself loadDataWithRequestEntity:self.requestEntity];
        
    } ];
    
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        
        [weakself loadMoreDataWithRequestEntity:self.requestEntity];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)initDataSourceBlock {
    
    WeakSelf(self);
    [self.viewModel setSuccessBlock:^(NSArray *subjectArr) {
        
    
        weakself.subjectArr = subjectArr;
        [weakself.tableView reloadData];
        [SVProgressHUD dismiss];
        
    } errorBlock:^(id error) {
        
    }];

    [self.viewModel setFieldSuccessBlock:^(id content) {
        
        [weakself setFieldBtnTitleWith:content];
    } fieldFailureBlock:^(id failure) {
        
    }];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"版块";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DiscoveryPage"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"DiscoveryPage"];
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
 */
- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    
    if (![YWNetworkTools networkStauts]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    @weakify(self);
    [[self.viewModel.fecthTopicEntityCommand execute:requestEntity] subscribeNext:^(NSArray *banners) {
        @strongify(self);
        
        if (type == 1) {
            
            [self loadRecommendTopicListWithFieldId:1];
            [self.viewModel requestForField];
            
        }
        else
        {
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
        //错误的情况下停止刷新（网络错误）
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
}

- (void)firstFieldBtnSetFieldId {
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@""];
    
    [self loadRecommendTopicListWithFieldId:1];
}

- (void)secondFieldBtnSetFieldtId {

    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@""];
    
    [self loadRecommendTopicListWithFieldId:2];
    
}

- (void)thirdFieldBtnSetFieldtId {
    
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@""];
    
    [self loadRecommendTopicListWithFieldId:3];
}


#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.subjectArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.viewModel idForRowByIndexPath:indexPath];
    
    YWDiscoveryBaseCell *cell    = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                   forIndexPath:indexPath];
    cell.selectionStyle          = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        [self.viewModel setupModelForBannerOfCell:cell model:nil];
        
        cell.mxScrollView.tapImageHandle = ^(NSInteger index) {
            
            HotTopicEntity *hotEntity = [self.viewModel.bannerArr objectAtIndex:index];
            
            if ([self.delegate respondsToSelector:@selector(didSelectModuleTopicWith:)]) {
                
                [self.delegate didSelectModuleTopicWith: [hotEntity.topic_id intValue]];

                
            }
            
        };
        
        
    }else if (indexPath.section == 1) {
        
        [self.viewModel setupModelForFieldTopicOfCell:cell
                                                model:[self.subjectArr objectAtIndex:indexPath.row]];
        [cell.fieldListView addTarget:self
                               action:@selector(jumpToTopicListView:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        cell.delegate           = self;
        
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return 40;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    return self.fieldView;
}

#pragma mark UITableViewDelegate 自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return bannerHeight;
    }
    else
    {
        
        return [tableView fd_heightForCellWithIdentifier:SUBJECT_CELL_IDENTIER
                                        cacheByIndexPath:indexPath
                                           configuration:^(id cell) {
                                               
                                               [self.viewModel setupModelForFieldTopicOfCell:cell
                                                                                       model:[self.subjectArr objectAtIndex:indexPath.row]];
                                               
                                           }];
    }
    
}


#pragma mark YWSubjectViewCellDelegate

- (void)didSelectTopicWith:(int)topicId {
    
    if ([self.delegate respondsToSelector:@selector(didSelectModuleTopicWith:)]) {
        
        [self.delegate didSelectModuleTopicWith:topicId];
        
    }

}

#pragma mark private method

- (void)jumpToTopicListView:(UIButton *)sender {
    
    YWSubjectViewCell *subjectCell = (YWSubjectViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath         = [self.tableView indexPathForCell:subjectCell];
    
    self.selectIndex               = indexPath.row;
    
    SubjectEntity *subject           = [self.subjectArr objectAtIndex:self.selectIndex];
    
    //获取第一个贴子中的subject_id
    TopicEntity *topic             = [TopicEntity mj_objectWithKeyValues:subject.topicArr[0]];
    
    if ([self.delegate respondsToSelector:@selector(didSelectModuleTopicWith:subjectId:subject:)]) {
        
        [self.delegate didSelectModuleTopicWith:[topic.topic_id intValue]
                                      subjectId:[topic.subject_id intValue]
                                        subject:subject.title];
        
    }
    
}

#pragma mark priavte method

- (void)loadRecommendTopicListWithFieldId:(int)fieldId {
    
    RequestEntity *request = [[RequestEntity alloc] init];
    request.URLString      = RECOMMENDED_TOPIC_URL;
    request.parameter      = @{@"field_id":@(fieldId)};
    
    [self.viewModel requestRecommendTopicListWith:request];

    
}

- (void)setFieldBtnTitleWith:(NSArray *)fieldArr {
    
    if (fieldArr.firstObject != nil) {
        
        FieldEntity *fieldOne   = [fieldArr objectAtIndex:0];
        FieldEntity *fieldTwo   = [fieldArr objectAtIndex:1];
        FieldEntity *fieldThree = [fieldArr objectAtIndex:2];
        
        [self.firstFieldBtn setTitle:fieldOne.title forState:UIControlStateNormal];
        [self.secondFieldBtn setTitle:fieldTwo.title forState:UIControlStateNormal];
        [self.thirdFieldBtn setTitle:fieldThree.title forState:UIControlStateNormal];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
