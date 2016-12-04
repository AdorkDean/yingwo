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
#import "MainNavController.h"

#import "UIViewAdditions.h"
#import "DiscoveryViewModel.h"
#import "FeildViewModel.h"

#import "YWDiscoveryBaseCell.h"
#import "YWBannerTableViewCell.h"
#import "YWSubjectViewCell.h"

//导航条图片高度
static CGFloat const bannerHeight         = 150;

static NSString *YWBANNER_CELL_IDENTIFIER = @"bannerCell";
static NSString *SUBJECT_CELL_IDENTIER    = @"subjectCell";

@interface DiscoveryController ()<UITableViewDataSource,UITableViewDelegate,MXScrollViewDelegate,YWSubjectViewCellDelegate>
@property (nonatomic, strong) UITableView         *discoveryTableView;
@property (nonatomic, strong) YWDiscoveryBaseCell *segmentViewCell;
@property (nonatomic, strong) NSMutableArray      *bannerArr;
@property (nonatomic, strong) UIView              *coverView;

@property (nonatomic, strong) RequestEntity       *requestEntity;

@property (nonatomic, assign) CGFloat             navgationBarHeight;
@property (nonatomic, strong) DiscoveryViewModel  *discoveryViewModel;
@property (nonatomic, strong) FeildViewModel      *fieldViewModel;

@property (nonatomic, strong) UIView              *fieldView;
@property (nonatomic, strong) UIButton            *firstFieldBtn;
@property (nonatomic, strong) UIButton            *secondFieldBtn;
@property (nonatomic, strong) UIButton            *thirdFieldBtn;

@property (nonatomic, strong) NSArray             *subjectCacheArrOne;
@property (nonatomic, strong) NSArray             *subjectCacheArrTwo;
@property (nonatomic, strong) NSArray             *subjectCacheArrThree;

@property (nonatomic, strong) NSArray             *topicCacheArrOne;
@property (nonatomic, strong) NSArray             *topicCacheArrTwo;
@property (nonatomic, strong) NSArray             *topicCacheArrThree;


//主题
@property (nonatomic, copy  ) NSString            *subject;

@property (nonatomic, assign) int                 field_id;

//主题id
@property (nonatomic, assign) int                 subject_id;

//主题下话题数组
@property (nonatomic, strong) NSArray             *topicArr;

//选择的话题id
@property (nonatomic, assign) int                 topic_id;

//点击选中的推荐主题
@property (nonatomic, assign) NSInteger         selectIndex;

@end

//刷新的初始值
static int start_id = 0;

@implementation DiscoveryController

- (UITableView *)discoveryTableView {
    
    if (_discoveryTableView == nil) {
        
        _discoveryTableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                                            0,
                                                                                            self.view.width,
                                                                                            self.navgationBarHeight+self.view.height)
                                                                           style:UITableViewStylePlain];
        _discoveryTableView.delegate        = self;
        _discoveryTableView.dataSource      = self;
        _discoveryTableView.allowsSelection = NO;
        _discoveryTableView.tag             = 101;
        _discoveryTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _discoveryTableView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        
        _discoveryTableView.contentInset    = UIEdgeInsetsMake(0, 0, 300, 0);
        [_discoveryTableView registerClass:[YWBannerTableViewCell class]
                    forCellReuseIdentifier:YWBANNER_CELL_IDENTIFIER];
        [_discoveryTableView registerClass:[YWSubjectViewCell class]
                    forCellReuseIdentifier:SUBJECT_CELL_IDENTIER];
        
    }
    return _discoveryTableView;
}

- (DiscoveryViewModel *)discoveryViewModel {
    if (_discoveryViewModel == nil) {
        _discoveryViewModel = [[DiscoveryViewModel alloc] init];
    }
    return _discoveryViewModel;
}

- (FeildViewModel *)fieldViewModel {
    if (_fieldViewModel == nil) {
        _fieldViewModel = [[FeildViewModel alloc] init];
    }
    return _fieldViewModel;
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
        //        [_firstFieldBtn setTitle:@"校园生活" forState:UIControlStateNormal];
        
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
        //        [_secondFieldBtn setTitle:@"兴趣爱好" forState:UIControlStateNormal];
        
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
        //        [_thirdFieldBtn setTitle:@"学科专业" forState:UIControlStateNormal];
        [_thirdFieldBtn addTarget:self
                           action:@selector(thirdFieldBtnSetFieldtId)
                 forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _thirdFieldBtn;
}

-(NSArray *)subjectCacheArrOne {
    if (_subjectCacheArrOne == nil) {
        _subjectCacheArrOne = [NSArray array];
    }
    return _subjectCacheArrOne;
}

-(NSArray *)subjectCacheArrTwo {
    if (_subjectCacheArrTwo == nil) {
        _subjectCacheArrTwo = [NSArray array];
    }
    return _subjectCacheArrTwo;
}

-(NSArray *)subjectCacheArrThree {
    if (_subjectCacheArrThree == nil) {
        _subjectCacheArrThree = [NSArray array];
    }
    return _subjectCacheArrThree;
}

-(NSArray *)topicCacheArrOne {
    if (_topicCacheArrOne == nil) {
        _topicCacheArrOne = [NSArray array];
    }
    return _topicCacheArrOne;
}

-(NSArray *)topicCacheArrTwo {
    if (_topicCacheArrTwo == nil) {
        _topicCacheArrTwo = [NSArray array];
    }
    return _topicCacheArrTwo;
}

-(NSArray *)topicCacheArrThree {
    if (_topicCacheArrThree == nil) {
        _topicCacheArrThree = [NSArray array];
    }
    return _topicCacheArrThree;
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
        _requestEntity.requestUrl = HOT_TOPIC_URL;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
}

- (int)field_id {
    if (_field_id == 0) {
        _field_id = 1;
    }
    return _field_id;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  [self.discoveryTableView addSubview:self.discoverySegmentView];
    [self.view addSubview:self.discoveryTableView];
    //添加遮挡视图，遮盖刷新前显示出的部分
    [self addTheCoverView];
    
    //不能放到viewWillAppear中，否则不起作用
    //   [self scrollViewDidScroll:self.discoveryTableView];
    
    __weak DiscoveryController *weakself = self;
    
    self.discoveryTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.requestEntity.requestUrl = HOT_TOPIC_URL;
        [weakself loadDataWithRequestEntity:self.requestEntity];
        
    } ];
    
    self.discoveryTableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        
        [weakself loadMoreDataWithRequestEntity:self.requestEntity];
    }];
    
    [self.discoveryTableView.mj_header beginRefreshing];
    
    //   [self loadSubjectData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DiscoveryPage"];
    self.title = @"发现";
    
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
    
    //网络连接错误的情况下停止刷新
    if ([YWNetworkTools networkStauts] == NO) {
        [self.discoveryTableView.mj_header endRefreshing];
    }

    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.discoveryTableView.mj_footer resetNoMoreData];
}


/**
 *  上拉刷新
 */
- (void)loadMoreDataWithRequestEntity:(RequestEntity *)requestEntity {
    //网络连接错误的情况下停止刷新
    if ([YWNetworkTools networkStauts] == NO) {
        [self.discoveryTableView.mj_footer endRefreshing];
    }

    [self loadForType:2 RequestEntity:requestEntity];
}

/**
 *  下拉、上拉刷新
 *
 *  @param type  上拉or下拉
 */
- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    
    @weakify(self);
    [[self.discoveryViewModel.fecthTopicEntityCommand execute:requestEntity] subscribeNext:^(NSArray *banners) {
        @strongify(self);
        
        if (type == 1) {
            //清空缓存数组
            self.subjectCacheArrOne     = nil;
            self.subjectCacheArrTwo     = nil;
            self.subjectCacheArrThree   = nil;
            self.topicCacheArrOne       = nil;
            self.topicCacheArrTwo       = nil;
            self.topicCacheArrThree     = nil;
            
            [self loadSubjectData];
            [self loadFieldList];
        }
        else
        {
            
        }
        
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

- (void)firstFieldBtnSetFieldId {
    self.field_id = 1;
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    
    //第一次点击和下拉刷新后第一次点击需要加载，之后点击都从本地保存的数组中获取
    if (self.subjectCacheArrOne.count > 0 && self.topicCacheArrOne.count > 0) {
        self.fieldViewModel.subjectArr = [self.subjectCacheArrOne mutableCopy];
        self.fieldViewModel.topicArr   = [self.topicCacheArrOne mutableCopy];
        [self.discoveryTableView reloadData];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@""];
        [self loadSubjectData];
    }
    

}

- (void)secondFieldBtnSetFieldtId {

    self.field_id = 2;
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    
    if (self.subjectCacheArrTwo.count > 0 && self.topicCacheArrTwo.count > 0) {
        self.fieldViewModel.subjectArr = [self.subjectCacheArrTwo mutableCopy];
        self.fieldViewModel.topicArr   = [self.topicCacheArrTwo mutableCopy];
        [self.discoveryTableView reloadData];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@""];
        [self loadSubjectData];
    }
    
}

- (void)thirdFieldBtnSetFieldtId {
    
    self.field_id = 3;
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    
    if (self.subjectCacheArrThree.count > 0 && self.topicCacheArrThree.count > 0) {
        self.fieldViewModel.subjectArr = [self.subjectCacheArrThree mutableCopy];
        self.fieldViewModel.topicArr   = [self.topicCacheArrThree mutableCopy];
        [self.discoveryTableView reloadData];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@""];
        [self loadSubjectData];
    }
    
}

- (void)addTheCoverView {
    UIView *coverView                   = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                   50,
                                                                                   SCREEN_WIDTH,
                                                                                   self.discoveryTableView.frame.size.height)];
    
    coverView.backgroundColor           = [UIColor colorWithHexString:BACKGROUND_COLOR];
    self.coverView                      = coverView;
    [self.view addSubview:self.coverView];
}

/**
 *  获取领域
 */
- (void)loadFieldList {
    
    [self.fieldViewModel requestTopicFieldWithUrl:TOPIC_FIELD_URL
                                          success:^(NSArray *fieldArr) {
                                              self.fieldViewModel.fieldArr = [fieldArr mutableCopy];
                                              
                                              [self setFieldBtnTitle];
                                          }
                                          failure:^(NSString *error) {
                                              
                                          }];
}


/**
 *  获取对应的主题
 */
- (void)loadSubjectData {
    
    NSDictionary *paramaters = @{@"field_id":@(self.field_id)};
    
    [self.fieldViewModel requestTopicSubjectListWithUrl:TOPIC_SUBJECT_URL
                                             paramaters:paramaters
                                                success:^(NSArray *subjectArr) {
                                                    
                                                    self.fieldViewModel.subjectArr = [subjectArr mutableCopy];
                                                    if (self.field_id == 1) {
                                                        self.subjectCacheArrOne = [subjectArr mutableCopy];
                                                    }
                                                    if (self.field_id == 2) {
                                                        self.subjectCacheArrTwo = [subjectArr mutableCopy];
                                                    }
                                                    if (self.field_id == 3) {
                                                        self.subjectCacheArrThree = [subjectArr mutableCopy];
                                                    }
                                                    
                                                    [self loadTopicDataWith:subjectArr];
                                                    
                                                } failure:^(NSString *error) {
                                                    [SVProgressHUD dismiss];
                                                }];
}


/**
 *  获取主题下的话题
 *
 *  @param subjectArr 主题数组
 */
- (void)loadTopicDataWith:(NSArray *) subjectArr{
    
    [self.fieldViewModel requestTopicListWithSubjectArr:subjectArr
                                                success:^(NSArray *topicArr) {
                                                    
                                                    self.fieldViewModel.topicArr = [topicArr mutableCopy];
                                                    
                                                    if (self.field_id == 1) {
                                                        self.topicCacheArrOne = [topicArr mutableCopy];
                                                    }
                                                    if (self.field_id == 2) {
                                                        self.topicCacheArrTwo = [topicArr mutableCopy];
                                                    }
                                                    if (self.field_id == 3) {
                                                        self.topicCacheArrThree = [topicArr mutableCopy];
                                                    }
                                                    
                                                    [self.discoveryTableView reloadData];
                                                    [self.discoveryTableView.mj_header endRefreshing];
                                                    
                                                    //移除遮盖视图
                                                    if (self.coverView != nil) {
                                                        [self.coverView removeFromSuperview];
                                                    }
                                                    
                                                    [SVProgressHUD dismiss];
                                                } failure:^(NSString *error) {
                                                    [SVProgressHUD dismiss];
                                                }];
}


#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.fieldViewModel.subjectArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.discoveryViewModel idForRowByIndexPath:indexPath];
    
    YWDiscoveryBaseCell *cell    = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                   forIndexPath:indexPath];
    cell.selectionStyle          = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        [self.discoveryViewModel setupModelOfCell:cell model:nil];
        
        cell.mxScrollView.tapImageHandle = ^(NSInteger index) {
            
            HotTopicEntity *hotEntity = [self.discoveryViewModel.bannerArr objectAtIndex:index];
            self.topic_id             = [hotEntity.topic_id intValue];
            
            [self performSegueWithIdentifier:@"topic" sender:self];
            
        };
        
        
    }else if (indexPath.section == 1) {
        
        [self.fieldViewModel setupModelOfCell:cell indexPath:indexPath];
        
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
                                               
                                               [self.fieldViewModel setupModelOfCell:cell indexPath:indexPath];
                                               
                                               
                                           }];
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TopicListController class]]) {
        if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_TOPICLIST]) {
            
            TopicListController *topicListVc = segue.destinationViewController;
            topicListVc.subject_id           = self.subject_id;
            topicListVc.subject              = self.subject;
            
        }
    }
    //TopicController
    else if ([segue.destinationViewController isKindOfClass:[TopicController class]]) {
        
        TopicController *topicVc = segue.destinationViewController;
        topicVc.topic_id         = self.topic_id;
    }
}


#pragma mark YWSubjectViewCellDelegate

- (void)didSelectTopicWith:(int)topicId {
    
    self.topic_id = topicId;
    
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_TOPIC sender:self];
    
}

#pragma mark private method

- (void)jumpToTopicListView:(UIButton *)sender {
    
    YWSubjectViewCell *subjectCell = (YWSubjectViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath         = [self.discoveryTableView indexPathForCell:subjectCell];
    
    self.selectIndex               = indexPath.row;
    
    SubjectEntity *subject         = [self.fieldViewModel.subjectArr objectAtIndex:self.selectIndex];
    NSArray *topicArr              = [self.fieldViewModel.topicArr objectAtIndex:self.selectIndex];
    
    //获取第一个贴子中的subject_id
    TopicEntity *topic             = [topicArr objectAtIndex:0];
    
    self.subject                   = subject.title;
    self.subject_id                = [subject.subject_id intValue];
    self.topic_id                  = [topic.topic_id intValue];
    
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_TOPICLIST sender:self];
    
}

- (void)setFieldBtnTitle {
    if (self.fieldViewModel.fieldArr.firstObject != nil) {
        FieldEntity *fieldOne   = [self.fieldViewModel.fieldArr objectAtIndex:0];
        FieldEntity *fieldTwo   = [self.fieldViewModel.fieldArr objectAtIndex:1];
        FieldEntity *fieldThree = [self.fieldViewModel.fieldArr objectAtIndex:2];
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
