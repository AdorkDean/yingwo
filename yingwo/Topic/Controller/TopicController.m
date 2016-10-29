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
#import "AnnounceController.h"

#import "TopicViewModel.h"
#import "YWTopicSegmentViewCell.h"
#import "YWTopicHeaderView.h"
#import "SMPagerTabView.h"


#import "TopicEntity.h"

@interface TopicController ()<TopicControllerDelegate,SMPagerTabViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView            *topicSrcllView;
//@property (nonatomic, strong) YWTopicSegmentViewCell *segmentViewCell;
@property (nonatomic, strong) SMPagerTabView          *segmentView;
@property (nonatomic, strong) YWTopicHeaderView       *topicHeaderView;
@property (nonatomic, strong) UIView                  *topicNavigatoionBar;
@property (nonatomic, strong) UIView                  *topicSectionView;

@property (nonatomic, strong) HotTopicController      *hotVc;
@property (nonatomic, strong) NewTopicController      *freshVc;

@property (nonatomic, strong) UIActivityIndicatorView *refreshIndictor;

@property (nonatomic, strong) UIBarButtonItem         *rightBarItem;
@property (nonatomic, strong) UIBarButtonItem         *leftBarItem;

@property (nonatomic, strong) UIButton                *addBtn;

@property (nonatomic, strong) RequestEntity           *requestEntity;

@property (nonatomic, strong) NSMutableArray          *catalogVcArr;

@property (nonatomic, assign) CGFloat                 navgationBarHeight;
@property (nonatomic, strong) TopicViewModel          *viewModel;

@property (nonatomic, assign) BOOL                    isChangedPage;

@end

static NSString *TOPIC_CELL_IDENTIFIER         = @"topicCell";
static NSString *TOPIC_SEGMENT_CELL_IDENTIFIER = @"segmentCell";

static CGFloat HeaderViewHeight = 250;
static int start_id = 0;

@implementation TopicController

- (UIScrollView *)topicSrcllView {
    if (_topicSrcllView == nil) {
        _topicSrcllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         -self.navgationBarHeight,
                                                                         SCREEN_WIDTH,
                                                                         SCREEN_HEIGHT+self.navgationBarHeight)];
        _topicSrcllView.backgroundColor              = [UIColor clearColor];
        _topicSrcllView.delegate                     = self;
        _topicSrcllView.showsVerticalScrollIndicator = NO;
    }
    return _topicSrcllView;
}

#define TopicHeaderViewFrame CGRectMake(0,0,SCREEN_WIDTH,HeaderViewHeight)

- (YWTopicHeaderView *)topicHeaderView {
    if (_topicHeaderView == nil) {
        _topicHeaderView                   = [[YWTopicHeaderView alloc] initWithFrame:TopicHeaderViewFrame];

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
                                                                SCREEN_HEIGHT+HeaderViewHeight)];
        
        _segmentView.delegate = self;
        
        //开始构建UI
        [_segmentView buildUI];
        //起始选择一个tab
        [_segmentView selectTabWithIndex:0 animate:NO];
        //显示红点，点击消失

        
        
    }
    return _segmentView;
}

- (UIActivityIndicatorView *)refreshIndictor {
    if (_refreshIndictor == nil) {
        _refreshIndictor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _refreshIndictor.center = CGPointMake(SCREEN_WIDTH/2, -100);
    }
    return _refreshIndictor;
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

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.requestUrl = TIEZI_URL;
        //请求的事新鲜事
        _requestEntity.topic_id   = self.topic_id;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
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
        _hotVc              = [[HotTopicController alloc] init];
        _hotVc.topicSrcView = self.topicSrcllView;
        _hotVc.topic_id     = self.topic_id;
        _hotVc.delegate     = self;
    }
    return _hotVc;
}

- (NewTopicController *)freshVc {
    if (_freshVc == nil) {
        _freshVc              = [[NewTopicController alloc] init];
        _freshVc.topic_id     = self.topic_id;
        _freshVc.topicSrcView = self.topicSrcllView;
        _freshVc.delegate     = self;
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
#pragma mark action

- (void)setAllAction {
    
    [self.addBtn addTarget:self
                    action:@selector(addTopic)
          forControlEvents:UIControlEventTouchUpInside];
    
}

//发布话题
- (void)addTopic {
    
    AnnounceController *announceVc = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_ANNOUNCE_IDENTIFIER];
    announceVc.isTopic             = YES;
    announceVc.topic_id            = self.topic_id;
    announceVc.topic_title         = self.topic_title;
    MainNavController *mainNav     = [[MainNavController alloc] initWithRootViewController:announceVc];

    [self presentViewController:mainNav animated:YES completion:nil];
    
}

- (void)backFarword {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   [self.view addSubview:self.topicTableView];

 //   [self.topicTableView addSubview:self.topicHeaderView];
    
    [self.topicSrcllView addSubview:self.topicHeaderView];
    [self.topicSrcllView addSubview:self.segmentView];

    [self.view addSubview:self.topicSrcllView];
    [self.view addSubview:self.topicNavigatoionBar];
    [self.view addSubview:self.topicSectionView];

    [self.view addSubview:self.addBtn];
    [self.view bringSubviewToFront:self.addBtn];
    
    [self setAllLayout];
    [self setAllAction];
    

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishReloadData)
                                                 name:@"TopicRelaod" object:nil];
    
//    [self.segmentView selectTabWithIndex:0 animate:NO];
    
    
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
    
    self.pageModel     = number;
    self.isChangedPage = YES;
    
    if (number == 0) {
        
        self.topicSrcllView.contentSize = self.freshVc.freshTableViewSize;
        
        if (self.topicSrcllView.contentOffset.y >= HeaderViewHeight-self.navgationBarHeight) {
            
            self.topicSrcllView.contentOffset = CGPointMake(0,
                                                            self.freshVc.homeTableview.contentOffset.y+HeaderViewHeight-self.navgationBarHeight);
        }


    }
    else
    {
        self.topicSrcllView.contentSize = self.hotVc.hotTableViewSize;

        if (self.topicSrcllView.contentOffset.y >= HeaderViewHeight-self.navgationBarHeight) {
            
            self.topicSrcllView.contentOffset = CGPointMake(0,
                                                            self.hotVc.homeTableview.contentOffset.y+HeaderViewHeight-self.navgationBarHeight);
        }
        
 

    }
    
    
    
    NSLog(@"页面 %lu",(unsigned long)number);
}

#define NAVBAR_CHANGE_POINT 50

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y + 64;
    
    CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
    
    if (offsetY >= HeaderViewHeight-self.navgationBarHeight) {
        self.topicSectionView.frame              = CGRectMake(0, self.navgationBarHeight, SCREEN_WIDTH, 40);
        self.segmentView.frame                   = CGRectMake(0,
                                            self.navgationBarHeight + 40 + offsetY,
                                            self.segmentView.width,
                                            self.segmentView.height);

        self.topicNavigatoionBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:1];
        self.title                               = self.topic_title;
    }
    else
    {
        self.topicSectionView.frame              = CGRectMake(0,HeaderViewHeight-offsetY, SCREEN_WIDTH, 40);
        self.topicNavigatoionBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:alpha];
        self.title = @"";
        
    }
    
    //缩放
    if (offsetY < 0) {
        
        CGRect headerViewFrame      = TopicHeaderViewFrame;
        CGFloat delta               = 0.0f;
        delta                       = fabs(MIN(0.0f, offsetY));
        headerViewFrame.origin.y    -= delta;
        headerViewFrame.size.height += delta;
        headerViewFrame.size.width  += delta;

        self.topicHeaderView.frame  = headerViewFrame;
        self.topicHeaderView.center = CGPointMake(SCREEN_WIDTH/2, self.topicHeaderView.centerY);

    }
    
    if (self.isChangedPage == YES) {
        self.isChangedPage = NO;
        return;
    }
    else
    {
        //当图片被遮挡住后，里面的tableview才开始滑动
        if (offsetY > HeaderViewHeight-self.navgationBarHeight) {
            
            if (self.pageModel == NewPageModel) {
                
                self.freshVc.homeTableview.contentOffset = CGPointMake(0, offsetY-HeaderViewHeight+self.navgationBarHeight);
                
            }
            else
            {
                
                self.hotVc.homeTableview.contentOffset = CGPointMake(0, offsetY-HeaderViewHeight+self.navgationBarHeight);
                
            }
        }
    }

    
    //滑倒顶部后需要将segmentView至0
    if(offsetY <= HeaderViewHeight - self.navgationBarHeight) {
        
        self.freshVc.homeTableview.contentOffset = CGPointMake(0, 0);
        self.hotVc.homeTableview.contentOffset   = CGPointMake(0, 0);
        self.segmentView.frame                   = CGRectMake(0,
                                                              HeaderViewHeight+40,
                                                              self.segmentView.width,
                                                              self.segmentView.height);

    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y <= -100) {
        
        [self.refreshIndictor startAnimating];
        [self.view addSubview:self.refreshIndictor];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.refreshIndictor.center = CGPointMake(SCREEN_WIDTH/2, 40);
                             
                             
        } completion:^(BOOL finished) {
            
            if (self.pageModel == NewPageModel) {
                
                [self.freshVc refreshData];
                
            }
            else
            {
                [self.hotVc refreshData];
            }
            
            
        }];
        
    }
    
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

    UIImage *topicDefaultImage                       = [UIImage imageNamed:@"morenhuati"];
    //话题为新鲜事的时候隐藏帖子数和关注数,图片为logo，其余话题为默认话题图片
    if (topic.topic_id != 0) {
        self.topic_title                             = topic.title;
        self.topicHeaderView.topic.text              = topic.title;
        self.topicHeaderView.numberOfTopic.text  = [NSString stringWithFormat:@"%@贴子 ",topic.post_cnt];
        self.topicHeaderView.numberOfFavour.text = [NSString stringWithFormat:@"| %@关注",topic.like_cnt];
    }else {
        self.topic_title                         = @"新鲜事";
        self.topicHeaderView.topic.text          = @"新鲜事";
        self.topicHeaderView.addTopicBtn.hidden  = YES;
    }

    NSString *headerImageUrl                     = [NSString selectCorrectUrlWithAppendUrl:topic.img];
    NSString *blurImageUrl                       = headerImageUrl;

    [self.topicHeaderView.headerView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]
                                       placeholderImage:topicDefaultImage];
    
    if (topic.topic_id == 0) {
        self.topicHeaderView.headerView.image    = [UIImage imageNamed:@"app_logo"];
    }
    
    [self.topicHeaderView.blurImageView sd_setImageWithURL:[NSURL URLWithString:blurImageUrl]
                                          placeholderImage:topicDefaultImage
                                                   options:SDWebImageRetryFailed
                                                 completed:^(UIImage *image,
                                                             NSError *error,
                                                             SDImageCacheType cacheType,
                                                             NSURL *imageURL) {
                                                     
                                                     if (topic.topic_id == 0) {
                                                         image = [UIImage imageNamed:@"app_logo"];
                                                     }
                                                     
                                                     //模糊
                                                     if (image != nil) {
                                                         image = [UIImage boxblurImage:image withBlurNumber:0.2];
                                                     }else {
                                                         image = topicDefaultImage;
                                                         image = [UIImage boxblurImage:image withBlurNumber:0.2];
                                                     }

                                                     self.topicHeaderView.blurImageView.image = image;
        
    }];

    
    self.topicHeaderView.blurImageView.contentMode     = UIViewContentModeScaleAspectFill;
    
    //这里注意未关注前user_post_like的初始值为为null，关注后才为1，取消后为0
    if (topic.like != nil && [topic.like intValue] == 0) {
        
        [self.topicHeaderView.addTopicBtn addTarget:self
                                             action:@selector(addLike:)
                                forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        
        [self.topicHeaderView.addTopicBtn addTarget:self
                                             action:@selector(cancelLike:)
                                    forControlEvents:UIControlEventTouchUpInside];
        
        [self.topicHeaderView.addTopicBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
                                                    forState:UIControlStateNormal];
        
    }
    
    if (topic.topic_id == 0) {
        [self.topicHeaderView.addTopicBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
                                                    forState:UIControlStateNormal];
    }

}

//关注话题
- (void)addLike:(UIButton *)sender {
    
    [SVProgressHUD showLoadingStatusWith:@""];
    
    NSDictionary *paramater = @{@"topic_id":@(self.topic_id),@"value":@1};
    
    [self.viewModel requestTopicLikeWithUrl:TOPIC_LIKE_URL
                                 paramaters:paramater
                                    success:^(StatusEntity *status) {
                              
                              if (status.status == YES) {
                                  
                                  [sender setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
                                                    forState:UIControlStateNormal];
                                  
                                  //先移除之前已经添加的action，再添加新的action
                                  [sender removeTarget:self
                                                action:@selector(addLike:)
                                      forControlEvents:UIControlEventTouchUpInside];
                                  [sender addTarget:self
                                             action:@selector(cancelLike:)
                                   forControlEvents:UIControlEventTouchUpInside];
                                  
                                  [SVProgressHUD showSuccessStatus:@"关注成功" afterDelay:HUD_DELAY];
                              }
                              else
                              {
                                  [SVProgressHUD showErrorStatus:@"关注失败" afterDelay:HUD_DELAY];
                              }
                          } failure:^(NSString *error) {
                              
                              [SVProgressHUD showErrorStatus:@"关注失败" afterDelay:HUD_DELAY];
                              
                          }];
    
    
}

//取消关注
- (void)cancelLike:(UIButton *)sender {
    
    [SVProgressHUD showLoadingStatusWith:@""];
    
    
    NSDictionary *paramater = @{@"topic_id":@(self.topic_id),@"value":@0};
    
    [self.viewModel requestTopicLikeWithUrl:TOPIC_LIKE_URL
                                 paramaters:paramater
                                    success:^(StatusEntity *status) {
                              
                              if (status.status == YES) {
                                  
                                  [sender setBackgroundImage:[UIImage imageNamed:@"weiguanzhu"]
                                                    forState:UIControlStateNormal];
                                  
                                  //先移除之前已经添加的action，在添加新的action
                                  [sender removeTarget:self
                                                action:@selector(cancelLike:)
                                      forControlEvents:UIControlEventTouchUpInside];
                                  
                                  [sender addTarget:self
                                             action:@selector(addLike:)
                                   forControlEvents:UIControlEventTouchUpInside];
                                  
                                  [SVProgressHUD showSuccessStatus:@"取消关注" afterDelay:HUD_DELAY];
                                  
                                  
                              }
                              else
                              {
                                  [SVProgressHUD showErrorStatus:@"取消关注失败" afterDelay:HUD_DELAY];
                                  
                              }
                          } failure:^(NSString *error) {
                              
                              [SVProgressHUD showErrorStatus:@"取消关注失败" afterDelay:HUD_DELAY];
                              
                              
                          }];
    
}


#pragma mark priavate method

-(void) finishReloadData {
    
    [self.refreshIndictor stopAnimating];
    [self.refreshIndictor removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
