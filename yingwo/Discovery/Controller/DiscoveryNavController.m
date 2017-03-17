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

@interface DiscoveryNavController ()<SMPagerTabViewDelegate,HotDiscussControllerDelegate,DiscoveryControllerDelegate>

@property (nonatomic, strong) SMPagerTabView               *discoveryPageView;
@property (nonatomic, strong) NSMutableArray               *catalogVcArr;

@property (nonatomic, strong) DiscoveryController          *moduleVc;
@property (nonatomic, strong) HotDiscussController         *hotDisVc;

//发现
@property (nonatomic, strong) TieZi                        *tieZi;

//版块
@property (nonatomic, assign) int                          topic_id;

//主题
@property (nonatomic, copy  ) NSString                     *subject;

//主题id
@property (nonatomic, assign) int                          subject_id;

@end

@implementation DiscoveryNavController

- (SMPagerTabView *)discoveryPageView {
    if (_discoveryPageView == nil) {
        
        _discoveryPageView          = [[SMPagerTabView alloc] initWithFrame:CGRectMake(0,
                                                                                     0,
                                                                                     SCREEN_WIDTH,
                                                                                     SCREEN_HEIGHT)];
        _discoveryPageView.delegate = self;
        
        
        [self.catalogVcArr addObject:self.hotDisVc];
        [self.catalogVcArr addObject:self.moduleVc];
        
        _discoveryPageView.tabButtonFontWeight = 3;
        _discoveryPageView.tabButtonFontSize   = 18;
        _discoveryPageView.tabButtonTitleColorForSelected = [UIColor whiteColor];
        _discoveryPageView.tabButtonTitleColorForNormal = [UIColor whiteColor];
        _discoveryPageView.selectedLineColor = [UIColor whiteColor];

        //开始构建UI
        [_discoveryPageView buildUI];
                
        _discoveryPageView.tabView.backgroundColor = [UIColor clearColor];
        
        //起始选择一个tab
        [_discoveryPageView selectTabWithIndex:0 animate:NO];

    }
    return _discoveryPageView;
}

- (NSMutableArray *)catalogVcArr {
    if (_catalogVcArr == nil) {
        _catalogVcArr = [[NSMutableArray alloc] init];
    }
    return _catalogVcArr;
}

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
    
    
    
    [self.view addSubview:self.discoveryPageView];
    
    self.navigationItem.titleView = self.discoveryPageView.tabView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}



#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    
    return [self.catalogVcArr count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    
    UIViewController *vc = self.catalogVcArr[number];
    
    return vc;
}

#pragma mark HotDiscussControllerDelegate

- (void)didSelectHotDisTopicWith:(HotDiscussEntity *)model {
    
    DetailController *detailVc = [[DetailController alloc] initWithTieZiModel:model];
    [self.navigationController pushViewController:detailVc animated:YES];
    
    
}

#pragma mark DiscoveryControllerDelegate

- (void)didSelectModuleTopicWith:(int)topic_id {
    
    TopicController *topicVc = [[TopicController alloc] initWithTopicId:topic_id];
    [self.navigationController pushViewController:topicVc animated:YES];

}


- (void)didSelectModuleTopicWith:(int)topic_id subjectId:(int)subjectId subject:(NSString *)subject {
    
    TopicListController *topicListVc = [[TopicListController alloc] initWithSubjectId:subjectId
                                                                           subjectName:subject];
    [self.navigationController pushViewController:topicListVc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
