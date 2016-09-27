//
//  TopicController.m
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicController.h"

#import "DetailController.h"
#import "HotTopicController.h"
#import "NewTopicController.h"

#import "TopicViewModel.h"
#import "YWTopicSegmentViewCell.h"
#import "YWTopicHeaderView.h"
#import "SMPagerTabView.h"


#import "TopicEntity.h"

@interface TopicController ()<TopicControllerDelegate,SMPagerTabViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView            *topicSrcllView;
//@property (nonatomic, strong) YWTopicSegmentViewCell *segmentViewCell;
@property (nonatomic, strong) SMPagerTabView          *segmentView;
@property (nonatomic, strong) YWTopicHeaderView      *topicHeaderView;
@property (nonatomic, strong) UIView        *topicNavigatoionBar;
@property (nonatomic, strong) UIView        *topicSectionView;

@property (nonatomic, strong) HotTopicController        *hotVc;
@property (nonatomic, strong) NewTopicController     *freshVc;


@property (nonatomic, strong) UIBarButtonItem        *rightBarItem;
@property (nonatomic, strong) UIBarButtonItem        *leftBarItem;

@property (nonatomic, strong) UIButton               *addBtn;

@property (nonatomic, strong) NSMutableArray     *catalogVcArr;

@property (nonatomic, assign) CGFloat                navgationBarHeight;
@property (nonatomic, strong) TopicViewModel         *viewModel;

@end

static NSString *TOPIC_CELL_IDENTIFIER         = @"topicCell";
static NSString *TOPIC_SEGMENT_CELL_IDENTIFIER = @"segmentCell";

static CGFloat HeaderViewHeight = 250;

@implementation TopicController

- (UIScrollView *)topicSrcllView {
    if (_topicSrcllView == nil) {
        _topicSrcllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         -self.navgationBarHeight,
                                                                         SCREEN_WIDTH,
                                                                         SCREEN_HEIGHT)];
        _topicSrcllView.delegate = self;
        _topicSrcllView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+200);
    }
    return _topicSrcllView;
}

- (YWTopicHeaderView *)topicHeaderView {
    if (_topicHeaderView == nil) {
        _topicHeaderView                   = [[YWTopicHeaderView alloc] initWithFrame:CGRectMake(0,
                                                                                                 0,
                                                                                                 SCREEN_WIDTH,
                                                                               HeaderViewHeight)];

        _topicHeaderView.loopScroll        = NO;
        _topicHeaderView.showPageIndicator = YES;
    }
    return _topicHeaderView;
}

- (UIView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[SMPagerTabView alloc] initWithFrame:CGRectMake(0,
                                                                HeaderViewHeight+40,
                                                                SCREEN_WIDTH,
                                                                SCREEN_HEIGHT-HeaderViewHeight-40)];
        
        _segmentView.delegate = self;
        
        //开始构建UI
        [_segmentView buildUI];
        //起始选择一个tab
        [_segmentView selectTabWithIndex:0 animate:NO];
        //显示红点，点击消失

        
        
    }
    return _segmentView;
}

- (UIView *)topicNavigatoionBar {
    if (_topicNavigatoionBar == nil) {
        _topicNavigatoionBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _topicNavigatoionBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:0];
    }
    return _topicNavigatoionBar;
}

- (UIView *)topicSectionView {
    if (_topicSectionView == nil) {
        _topicSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     HeaderViewHeight,
                                                                     SCREEN_WIDTH,
                                                                     40)];
        
        [_topicSectionView addSubview:self.segmentView.tabView];
    }
    return _topicSectionView;
}

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem           = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backFarword)];
        _leftBarItem.tintColor = [UIColor whiteColor];
        
        
    }
    return _leftBarItem;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem           = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"share"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:nil];
        _rightBarItem.tintColor = [UIColor whiteColor];
    }
    return _rightBarItem;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"xiehuati"]
                           forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (CGFloat)navgationBarHeight {
    //导航栏＋状态栏高度
    return  self.navigationController.navigationBar.height+20;
}

- (TopicViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TopicViewModel alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray *)catalogVcArr {
    if (_catalogVcArr == nil) {
        _catalogVcArr = [NSMutableArray arrayWithCapacity:2];
        
        [_catalogVcArr addObject:self.freshVc];
        [_catalogVcArr addObject:self.hotVc];
        
    }
    return _catalogVcArr;
}

- (HotTopicController *)hotVc {
    if (_hotVc == nil) {
        _hotVc        = [[HotTopicController alloc] init];
        _hotVc.topicSrcView = self.topicSrcllView;
        _hotVc.delegate = self;
    }
    return _hotVc;
}

- (NewTopicController *)freshVc {
    if (_freshVc == nil) {
        _freshVc      = [[NewTopicController alloc] init];
        _freshVc.topic_id       = self.topic_id;
        _freshVc.topicSrcView = self.topicSrcllView;
        _freshVc.delegate = self;
    }
    return _freshVc;
}

#pragma mark 添加view约束

- (void)setAllLayout {
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
}

- (void)backFarword {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
 //   [self.view addSubview:self.topicTableView];

 //   [self.topicTableView addSubview:self.topicHeaderView];
    
    [self.view addSubview:self.topicSrcllView];
    [self.view addSubview:self.topicNavigatoionBar];
    [self.topicSrcllView addSubview:self.topicHeaderView];
    [self.topicSrcllView addSubview:self.segmentView];
    
    [self.view addSubview:self.topicSectionView];
    [self.view addSubview:self.addBtn];
    [self.view bringSubviewToFront:self.addBtn];
    
    [self setAllLayout];

    [self loadTopicInfoWith:self.topic_id];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar hideNavigationBarBottomLine];


    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0 alpha:0];

    
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:THEME_COLOR_1];
}

- (void)loadTopicInfoWith:(int)topicId {
    
    NSDictionary *paramters = @{@"topic_id":@(topicId)};
    
    [self.viewModel requestTopicDetailInfoWithUrl:TOPIC_DETAIL_URL
                                       paramaters:paramters
                                          success:^(TopicEntity * topic){
        
                                              [self fillTopicHeaderViewWith:topic];
                                              
    } error:^(NSURLSessionDataTask * task, NSError *error) {
        
    }];
    
}



#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [self.catalogVcArr count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return self.catalogVcArr[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}


#define NAVBAR_CHANGE_POINT 50

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y + 64;
    
    CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
    
    if (offsetY >= HeaderViewHeight-self.navgationBarHeight) {
        self.topicSectionView.frame              = CGRectMake(0, self.navgationBarHeight, SCREEN_WIDTH, 40);
        self.topicNavigatoionBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:1];
        self.title = self.topic_title;
    }
    else
    {
        self.topicSectionView.frame              = CGRectMake(0,HeaderViewHeight-offsetY, SCREEN_WIDTH, 40);
        self.topicNavigatoionBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:alpha];
        
        self.title = @"";
        
    }
 //   NSLog(@"%f",alpha);
}


#pragma mark segue prepare

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailController class]]) {
        
        if ([segue.identifier isEqualToString:@"detail"]) {
            DetailController *detailVc = segue.destinationViewController;
            detailVc.model             = self.model;
        }
    }
}

#pragma mark TopicControllerDelegate

- (void)didSelectCellWith:(TieZi *)model {
    
    self.model = model;
    [self performSegueWithIdentifier:@"detail" sender:self];
}


#pragma mark private method

- (void)fillTopicHeaderViewWith:(TopicEntity *)topic {

    
    self.topic_title                         = topic.title;
    self.topicHeaderView.topic.text          = topic.title;
    self.topicHeaderView.numberOfTopic.text  =[NSString stringWithFormat:@"%@贴子 ",topic.post_cnt];
    self.topicHeaderView.numberOfFavour.text = [NSString stringWithFormat:@"| %@关注",topic.like_cnt];

    NSString *headerImageUrl                 = [NSString selectCorrectUrlWithAppendUrl:topic.img];
    NSString *blurImageUrl                   = headerImageUrl;

    [self.topicHeaderView.headerView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]
                                       placeholderImage:[UIImage imageNamed:@"ying"]];
    [self.topicHeaderView.blurImageView sd_setImageWithURL:[NSURL URLWithString:blurImageUrl]
                                       placeholderImage:[UIImage imageNamed:@"ying"]];
    self.topicHeaderView.blurImageView.contentMode = UIViewContentModeScaleAspectFit;
//    NSMutableArray *banner             = [[NSMutableArray alloc] init];
  //  self.topicHeaderView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
