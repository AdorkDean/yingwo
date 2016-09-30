//
//  HobbyController.m
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FieldThreeController.h"

#import "FeildThirdViewModel.h"

#import "YWSubjectViewCell.h"


@interface FieldThreeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FeildThirdViewModel *viewModel;
@property (nonatomic, assign) NSInteger           selectIndex;

@end

static NSString *SUBJECT_CELL_IDENTIER =  @"subjectCell";

@implementation FieldThreeController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled   = NO;
        
        [_tableView registerClass:[YWSubjectViewCell class]
           forCellReuseIdentifier:SUBJECT_CELL_IDENTIER];
    }
    return _tableView;
}

- (FeildThirdViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[FeildThirdViewModel alloc] init];
    }
    return _viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"知识技能";

    [self.view addSubview:self.tableView];
    
    [self loadSubjectData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

/**
 *  获取对应的主题
 */
- (void)loadSubjectData {
    
    NSDictionary *paramaters = @{@"field_id":@"3"};
    
    [self.viewModel requestTopicSubjectListWithUrl:TOPIC_SUBJECT_URL
                                        paramaters:paramaters
                                           success:^(NSArray *subjectArr) {
                                               
                                               self.viewModel.subjectArr = [subjectArr mutableCopy];
                                               
                                               [self loadTopicDataWith:subjectArr];
                                               
                                           } failure:^(NSString *error) {
                                               
                                           }];
}

/**
 *  获取主题下的话题
 *
 *  @param subjectArr 主题数组
 */
- (void)loadTopicDataWith:(NSArray *) subjectArr{
    
    [self.viewModel requestTopicListWithSubjectArr:subjectArr
                                           success:^(NSArray *topicArr) {
                                               
                                               self.viewModel.topicArr = [topicArr mutableCopy];
                                               
                                               [self.tableView reloadData];
                                               
                                           } failure:^(NSString *error) {
                                               
                                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.subjectArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWSubjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBJECT_CELL_IDENTIER
                                                              forIndexPath:indexPath];
    [self.viewModel setupModelOfCell:cell indexPath:indexPath];
    
    [cell.fieldListView addTarget:self
                           action:@selector(jumpToTopicView:)
                 forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark UITableViewDelegate 自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return [tableView fd_heightForCellWithIdentifier:SUBJECT_CELL_IDENTIER
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell indexPath:indexPath];
                                       }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark private method

- (void)jumpToTopicView:(UIButton *)sender {
    
    YWSubjectViewCell *subjectCell = (YWSubjectViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath         = [self.tableView indexPathForCell:subjectCell];
    
    self.selectIndex               = indexPath.row;
    
    SubjectEntity *subject         = [self.viewModel.subjectArr objectAtIndex:self.selectIndex];
    NSArray *topicArr              = [self.viewModel.topicArr objectAtIndex:self.selectIndex];
    
    //获取第一个贴子中的subject_id
    TopicEntity *topic             = [topicArr objectAtIndex:0];
    
    if ([self.delegate respondsToSelector:@selector(didSelectSubjectWith:subjectId:)])
    {
        [self.delegate didSelectSubjectWith:subject.title
                                  subjectId:[topic.subject_id intValue]];
        
    }
    
}
@end
