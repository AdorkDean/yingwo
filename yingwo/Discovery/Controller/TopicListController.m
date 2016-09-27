//
//  TopicController.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicListController.h"

#import "YWTopicViewCell.h"

#import "TopicViewModel.h"

#import "TopicEntity.h"

@interface TopicListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView     *topicTableView;
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@property (nonatomic, strong) UIButton        *addTopicBtn;


@property (nonatomic, strong) TopicViewModel  *viewModel;

@end

static NSString *TOPIC_CELL_IDENTIFIER = @"topicIdentifier";

@implementation TopicListController

- (UITableView *)topicTableView {
    if (_topicTableView == nil) {
        _topicTableView                    = [[UITableView alloc ]initWithFrame:CGRectMake(10,
                                                                                   10,
                                                                                   SCREEN_WIDTH-20,
                                                                                   SCREEN_HEIGHT-10)

                                                                  style:UITableViewStylePlain];
        [_topicTableView registerClass:[YWTopicViewCell class]
                forCellReuseIdentifier:TOPIC_CELL_IDENTIFIER];
        _topicTableView.layer.cornerRadius = 10;
        _topicTableView.backgroundColor    = [UIColor clearColor];
        _topicTableView.delegate           = self;
        _topicTableView.dataSource         = self;
    }
    return _topicTableView;
}

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(jumpToDiscoveryPage)];
    }
    return _leftBarItem;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"share"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:nil];
    }
    return _rightBarItem;
}

- (UIButton *)addTopicBtn {
    if (_addTopicBtn == nil) {
        _addTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addTopicBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
                                forState:UIControlStateNormal];
    }
    return _addTopicBtn;
}


- (TopicViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TopicViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark all action

- (void) jumpToDiscoveryPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topicTableView];
    [self hideExtraTableView:self.topicTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.subject;
    
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)hideExtraTableView:(UITableView *)tableview {
    UIView *view              = [[UIView alloc] init];
    view.backgroundColor      = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableview.tableFooterView = view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YWTopicViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:TOPIC_CELL_IDENTIFIER
                                                            forIndexPath:indexPath];

    TopicEntity *topic       = [self.topicArr objectAtIndex:indexPath.row];

    cell.topic.text          = topic.title;
    cell.numberOfTopic.text  = [NSString stringWithFormat:@"%@贴子",topic.post_cnt];
    cell.numberOfFavour.text = [NSString stringWithFormat:@"%@关注",topic.like_cnt];
    
    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:topic.img]
                          placeholderImage:nil];
    
   // cell.leftImageView.backgroundColor = [UIColor redColor];
 //   cell.accessoryView             = self.addTopicBtn;
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

@end
