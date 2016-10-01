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

#import "YWDiscoveryBaseCell.h"
#import "YWBannerTableViewCell.h"
#import "YWSegmentViewCell.h"

//导航条图片高度
static CGFloat const bannerHeight           = 150;

static NSString *YWBANNER_CELL_IDENTIFIER   = @"bannerCell";
static NSString *YWPAGEVIEW_CELL_IDENTIFIER = @"discoveryCell";

@interface DiscoveryController ()<UITableViewDataSource,UITableViewDelegate,MXScrollViewDelegate,DiscoveryDelegate>
@property (nonatomic, strong) UITableView          *discoveryTableView;
@property (nonatomic, strong) YWDiscoveryBaseCell  *segmentViewCell;
@property (nonatomic, strong) NSMutableArray       *bannerArr;

@property (nonatomic, assign) CGFloat              navgationBarHeight;
@property (nonatomic, strong) DiscoveryViewModel   *viewModel;

@property (nonatomic, strong) FieldOneController   *oneFieldVc;
@property (nonatomic, strong) FieldTwoController   *twoFieldVc;
@property (nonatomic, strong) FieldThreeController *threeFieldVc;

//主题
@property (nonatomic, copy  ) NSString             *subject;

//主题id
@property (nonatomic, assign) int                  subject_id;

//主题下话题数组
@property (nonatomic, strong) NSArray              *topicArr;

//选择的话题id
@property (nonatomic, assign) int                  topic_id;

@end

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
        
        [_discoveryTableView registerClass:[YWBannerTableViewCell class]
                    forCellReuseIdentifier:YWBANNER_CELL_IDENTIFIER];
        [_discoveryTableView registerClass:[YWSegmentViewCell class]
                    forCellReuseIdentifier:YWPAGEVIEW_CELL_IDENTIFIER];

    }
    return _discoveryTableView;
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

- (void)viewDidLoad {
    [super viewDidLoad];

  //  [self.discoveryTableView addSubview:self.discoverySegmentView];
    [self.view addSubview:self.discoveryTableView];
    //不能放到viewWillAppear中，否则不起作用
    [self scrollViewDidScroll:self.discoveryTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"发现";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}


#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.viewModel idForRowByIndexPath:indexPath];

    YWDiscoveryBaseCell *cell    = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                   forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        [self.viewModel setupModelOfCell:cell model:nil];
        
    }else if (indexPath.section == 1) {
        
        //获得cell，为了给对应的section添加领域view
        self.segmentViewCell               = cell;
        cell.oneFieldVc.delegate           = self;
        cell.twoFieldVc.delegate           = self;
        cell.threeFieldVc.delegate         = self;
        cell.oneFieldVc.discoveryTableView = self.discoveryTableView;

        self.oneFieldVc                    = cell.oneFieldVc;
        self.twoFieldVc                    = cell.twoFieldVc;
        self.threeFieldVc                  = cell.threeFieldVc;

    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return bannerHeight;
    }
    return SCREEN_HEIGHT*1.2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }

    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        //添加领域view
        return self.segmentViewCell.discoverySegmentView.tabView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 200;
    }
    return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TopicListController class]]) {
        if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_TOPICLIST]) {
            
            TopicListController *topicListVc = segue.destinationViewController;
            topicListVc.subject_id           = self.subject_id;
            
        }
    }
    //TopicController
    else if ([segue.destinationViewController isKindOfClass:[TopicController class]]) {
        
        TopicController *topicVc = segue.destinationViewController;
        topicVc.topic_id         = self.topic_id;
    }
}



#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //导航栏图片允许拉伸
   // [self.mxScrollView stretchingSubviews];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y >= bannerHeight && self.oneFieldVc.tableView.contentOffset.y != 0) {
        
        self.discoveryTableView.scrollEnabled     = NO;
        self.oneFieldVc.tableView.scrollEnabled   = YES;
        self.twoFieldVc.tableView.scrollEnabled   = YES;
        self.threeFieldVc.tableView.scrollEnabled = YES;

    }
    
}


#pragma mark DiscoveryDelegate

- (void)didSelectSubjectWith:(NSString *)subject subjectId:(int)subjectId {

    self.subject    = subject;
    self.subject_id = subjectId;
    
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_TOPICLIST sender:self];
}

- (void)didSelectTopicWith:(int)topicId {
    
    self.topic_id = topicId;
    
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_TOPIC sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
