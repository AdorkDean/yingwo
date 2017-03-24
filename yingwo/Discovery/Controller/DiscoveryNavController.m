//
//  DiscoveryNavController.m
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "DiscoveryNavController.h"
#import "DetailController.h"
#import "TopicListController.h"
#import "TopicController.h"

#import "SMPagerTabView.h"

#import "DiscoveryController.h"
#import "HotDiscussController.h"

@interface DiscoveryNavController ()<HotDiscussControllerDelegate,DiscoveryControllerDelegate,ZJScrollPageViewDelegate>

@property (strong, nonatomic) NSArray                         *titles;
@property (strong, nonatomic) NSArray<UIViewController<ZJScrollPageViewChildVcDelegate> *> *childVcs;
@property (weak, nonatomic  ) ZJScrollSegmentView             *segmentView;
@property (weak, nonatomic  ) ZJContentView                   *contentView;

@property (nonatomic, strong) DiscoveryController             *moduleVc;
@property (nonatomic, strong) HotDiscussController            *hotDisVc;

//发现
@property (nonatomic, strong) TieZi                           *tieZi;

//版块
@property (nonatomic, assign) int                             topic_id;

//主题
@property (nonatomic, copy  ) NSString                        *subject;

//主题id
@property (nonatomic, assign) int                          subject_id;

@end

@implementation DiscoveryNavController

- (DiscoveryController *)moduleVc {
    
    if (_moduleVc == nil) {
        _moduleVc = [[DiscoveryController alloc] init];
        _moduleVc.delegate = self;
    }
    return _moduleVc;
    
}

- (HotDiscussController *)hotDisVc {
    
    if (_hotDisVc == nil) {
        _hotDisVc = [[HotDiscussController alloc] init];
        _hotDisVc.delegate = self;
    }
    return _hotDisVc;
}

- (void)layoutSubviews {
    

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.childVcs = [self setupChildVc];
    // 初始化
    [self setupSegmentView];
    [self setupContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}


- (void)setupSegmentView {
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showCover = YES;
    // 不要滚动标题, 每个标题将平分宽度
    style.scrollTitle = NO;
    
    // 渐变
    style.gradualChangeTitleColor = YES;
    // 遮盖背景颜色
    style.coverBackgroundColor = [UIColor whiteColor];
    //标题一般状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.normalTitleColor = [UIColor colorWithHexString:THEME_COLOR_3];
    
    //标题选中状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.selectedTitleColor = [UIColor colorWithHexString:THEME_COLOR_1];
    
    style.titleFont = [UIFont systemFontOfSize:15 weight:1];

    self.titles = @[@"热议", @"版块"];
    
    // 注意: 一定要避免循环引用!!
    __weak typeof(self) weakSelf = self;
    ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 64, 120.0, 28.0)
                                                                 segmentStyle:style
                                                                     delegate:self
                                                                       titles:self.titles
                                                                titleDidClick:^(ZJTitleView *titleView,
                                                                                NSInteger index) {
                                                                    
                                                                   
        [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
        
    }];
    // 自定义标题的样式
    segment.layer.cornerRadius     = 14.0;
    segment.backgroundColor        = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    // 当然推荐直接设置背景图片的方式
    // segment.backgroundImage = [UIImage imageNamed:@"extraBtnBackgroundImage"];
    
    self.segmentView = segment;
    self.navigationItem.titleView = self.segmentView;
    
}

- (void)setupContentView {
    
    ZJContentView *content = [[ZJContentView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.bounds.size.width, self.view.bounds.size.height) segmentView:self.segmentView parentViewController:self delegate:self];
    self.contentView = content;
    [self.view addSubview:self.contentView];
    
}

- (NSArray *)setupChildVc {
    
    NSArray *childVcs = [NSArray arrayWithObjects:self.hotDisVc, self.moduleVc, nil];
    return childVcs;
}

#pragma mark ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = self.childVcs[index];
    }
    
    return childVc;
}


-(CGRect)frameOfChildControllerForContainer:(UIView *)containerView {
    return  CGRectInset(containerView.bounds, 20, 20);
}


#pragma mark HotDiscussControllerDelegate

- (void)didSelectHotDisTopicWith:(HotDiscussEntity *)model {
    
    DetailController *detailVc = [[DetailController alloc] initWithTieZiModel:model];
    [self customPushToViewController:detailVc];
    
    
}

#pragma mark DiscoveryControllerDelegate

- (void)didSelectModuleTopicWith:(int)topic_id {
    
    TopicController *topicVc = [[TopicController alloc] initWithTopicId:topic_id];
    [self customPushToViewController:topicVc];

}


- (void)didSelectModuleTopicWith:(int)topic_id subjectId:(int)subjectId subject:(NSString *)subject {
    
    TopicListController *topicListVc = [[TopicListController alloc] initWithSubjectId:subjectId
                                                                           subjectName:subject];
    [self customPushToViewController:topicListVc];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushBlock {
  //  [self.discoveryPageView selectTabWithIndex:0 animate:YES];
    [self.hotDisVc refreshTableView];
}
@end
