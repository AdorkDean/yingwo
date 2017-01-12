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

@property (nonatomic, strong) SMPagerTabView       *discoveryPageView;
@property (nonatomic, strong) NSMutableArray       *catalogVcArr;

@property (nonatomic, strong) DiscoveryController  *moduleVc;
@property (nonatomic, strong) HotDiscussController *hotDisVc;

//发现
@property (nonatomic, strong) TieZi *tieZi;

//版块
@property (nonatomic, assign) int                 topic_id;

//主题
@property (nonatomic, copy  ) NSString            *subject;

//主题id
@property (nonatomic, assign) int                 subject_id;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.discoveryPageView];
    
    
    self.navigationItem.titleView = self.discoveryPageView.tabView;
   

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //查看贴子详情
    if ([segue.destinationViewController isKindOfClass:[DetailController class]])
    {
        
        if ([segue.identifier isEqualToString:@"detail"]) {
            DetailController *detailVc = segue.destinationViewController;
            detailVc.model             = self.tieZi;
            
        }
    }
    else if ([segue.destinationViewController isKindOfClass:[TopicListController class]]) {
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
    
    self.tieZi = model;
    self.tieZi.user_name = @"南工土拨鼠";
    
    [self performSegueWithIdentifier:@"detail" sender:self];
    
}

#pragma mark DiscoveryControllerDelegate

- (void)didSelectModuleTopicWith:(int)topic_id {
    
    self.topic_id = topic_id;
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_TOPIC sender:self];

}

- (void)didSelectModuleTopicWith:(int)topic_id subjectId:(int)subjectId subject:(NSString *)subject {
    
    self.topic_id = topic_id;
    self.subject_id = subjectId;
    self.subject = subject;
    
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_TOPICLIST sender:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
