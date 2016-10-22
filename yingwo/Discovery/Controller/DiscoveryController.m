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

@property (nonatomic, strong) RequestEntity       *requestEntity;

@property (nonatomic, assign) CGFloat             navgationBarHeight;
@property (nonatomic, strong) DiscoveryViewModel  *discoveryViewModel;
@property (nonatomic, strong) FeildViewModel      *fieldViewModel;

@property (nonatomic, strong) UIView              *fieldView;
@property (nonatomic, strong) UIButton            *firstFieldBtn;
@property (nonatomic, strong) UIButton            *secondFieldBtn;
@property (nonatomic, strong) UIButton            *thirdFieldBtn;

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

        _discoveryTableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
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
        [_firstFieldBtn setTitle:@"校园生活" forState:UIControlStateNormal];
        
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
        [_secondFieldBtn setTitle:@"兴趣爱好" forState:UIControlStateNormal];
        
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
        [_thirdFieldBtn setTitle:@"学科专业" forState:UIControlStateNormal];
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
    self.title = @"发现";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

/**
 *  下拉刷新
 */
- (void)loadDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    
    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.discoveryTableView.mj_footer resetNoMoreData];
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
    
    @weakify(self);
    [[self.discoveryViewModel.fecthTopicEntityCommand execute:requestEntity] subscribeNext:^(NSArray *banners) {
        @strongify(self);
        
        if (type == 1) {

            [self loadSubjectData];
            
        }
        else
        {
            
        }
        
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

- (void)firstFieldBtnSetFieldId {
    
    [SVProgressHUD showLoadingStatusWith:@""];
    
    self.field_id = 1;
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [self loadSubjectData];
}

- (void)secondFieldBtnSetFieldtId {
    
    [SVProgressHUD showLoadingStatusWith:@""];

    self.field_id = 2;
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [self loadSubjectData];

}

- (void)thirdFieldBtnSetFieldtId {
    
    [SVProgressHUD showLoadingStatusWith:@""];

    self.field_id = 3;
    [_firstFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_secondFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_2] forState:UIControlStateNormal];
    [_thirdFieldBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [self loadSubjectData];

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
                                               
                                               [self.discoveryTableView reloadData];
                                               [self.discoveryTableView.mj_header endRefreshing];
                                               
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
