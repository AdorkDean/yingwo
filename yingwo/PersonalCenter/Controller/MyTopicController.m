//
//  MyTopicController.m
//  yingwo
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyTopicController.h"
#import "TopicListController.h"
#import "TopicController.h"

#import "SMPagerTabView.h"

@interface MyTopicController ()<SMPagerTabViewDelegate,TopicListControllerDelegate>

@property (nonatomic, strong) SMPagerTabView      *topicPgaeView;
@property (nonatomic, strong) UIView             *topicSectionView;

@property (nonatomic, strong) NSMutableArray      *catalogVcArr;

//校园生活
@property (nonatomic, strong) TopicListController *oneFieldVc;
//兴趣爱好
@property (nonatomic, strong) TopicListController *twoFieldVc;
//学科专业
@property (nonatomic, strong) TopicListController *threeFieldVc;

@property (nonatomic, assign) int                  topicId;

@end

@implementation MyTopicController

- (SMPagerTabView *)topicPgaeView {
    if (_topicPgaeView == nil) {
        
        _topicPgaeView          = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0,
                                                                         40,
                                                                         SCREEN_WIDTH,
                                                                         SCREEN_HEIGHT)];
        _topicPgaeView.delegate = self;
        
        [self.catalogVcArr addObject:self.oneFieldVc];
        [self.catalogVcArr addObject:self.twoFieldVc];
        [self.catalogVcArr addObject:self.threeFieldVc];

        //开始构建UI
        [_topicPgaeView buildUI];
        //起始选择一个tab
        [_topicPgaeView selectTabWithIndex:0 animate:NO];

    }
    return _topicPgaeView;
}

- (UIView *)topicSectionView {
    if (_topicSectionView == nil) {
        _topicSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     40)];
        
        [_topicSectionView addSubview:self.topicPgaeView.tabView];
    }
    return _topicSectionView;
}


- (NSMutableArray *)catalogVcArr {
    if (_catalogVcArr == nil) {
        _catalogVcArr = [[NSMutableArray alloc] init];
    }
    return _catalogVcArr;
}

- (TopicListController *)oneFieldVc {
    if (_oneFieldVc == nil) {
        _oneFieldVc           = [[TopicListController alloc] init];
        _oneFieldVc.delegate  = self;
        _oneFieldVc.title     = @"校园生活";
        _oneFieldVc.field_id  = 1;
        _oneFieldVc.isMyTopic = YES;
    }
    return _oneFieldVc;
}

- (TopicListController *)twoFieldVc {
    if (_twoFieldVc == nil) {
        _twoFieldVc           = [[TopicListController alloc] init];
        _twoFieldVc.delegate  = self;
        _twoFieldVc.title     = @"兴趣爱好";
        _twoFieldVc.field_id  = 2;
        _twoFieldVc.isMyTopic = YES;

    }
    return _twoFieldVc;
}

- (TopicListController *)threeFieldVc {
    if (_threeFieldVc == nil) {
        _threeFieldVc           = [[TopicListController alloc] init];
        _threeFieldVc.delegate  = self;
        _threeFieldVc.title       = @"学科专业";
        _threeFieldVc.field_id  = 3;
        _threeFieldVc.isMyTopic = YES;

    }
    return _threeFieldVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topicPgaeView];
    [self.view addSubview:self.topicSectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"我的话题";
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToPersonCenterView)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    
    return [self.catalogVcArr count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    
    UIViewController *vc = self.catalogVcArr[number];
    
    return vc;
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}


#pragma mark TopicListControllerDelegate

- (void)didSelectTopicListWith:(int)topicId{
    
    self.topicId = topicId;
    
    [self performSegueWithIdentifier:@"topic" sender:self];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"topic"]) {
        
        if ([segue.destinationViewController isKindOfClass:[TopicController class]]) {
            
            TopicController *topicVc = segue.destinationViewController;
            topicVc.topic_id         = self.topicId;
            
        }
        
    }
    
}

#pragma mark private method

- (void)backToPersonCenterView {
    [self.navigationController popViewControllerAnimated:YES];
}





@end
