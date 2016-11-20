//
//  SchoolLifeController.m
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FieldOneController.h"
#import "TopicController.h"

#import "FeildViewModel.h"

#import "YWSubjectViewCell.h"

@interface FieldOneController ()<UITableViewDelegate,UITableViewDataSource,YWSubjectViewCellDelegate>


@property (nonatomic, strong) FeildViewModel    *viewModel;

@property (nonatomic, assign) NSInteger         selectIndex;

@end

static NSString *SUBJECT_CELL_IDENTIER =  @"subjectCell";

@implementation FieldOneController

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+200)
                                                  style:UITableViewStylePlain];
        _tableView.contentInset    = UIEdgeInsetsMake(0, 0, 300, 0);
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

- (FeildViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[FeildViewModel alloc] init];
    }
    return _viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"校园生活";

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
    
    NSDictionary *paramaters = @{@"field_id":@"1"};
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.viewModel setupModelOfCell:cell indexPath:indexPath];

    [cell.fieldListView addTarget:self
                           action:@selector(jumpToTopicView:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    cell.delegate           = self;
    
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


#pragma mark YWSubjectViewCellDelegate

- (void)didSelectTopicWith:(int)topicId {
    
//    if ([self.delegate respondsToSelector:@selector(didSelectTopicWith:)]) {
//        [self.delegate didSelectTopicWith:topicId];
//    }
    
}

#pragma mark private method

- (void)jumpToTopicView:(UIButton *)sender {
    
    YWSubjectViewCell *subjectCell = (YWSubjectViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath         = [self.tableView indexPathForCell:subjectCell];

    self.selectIndex               = indexPath.row;

//    SubjectEntity *subject         = [self.viewModel.subjectArr objectAtIndex:self.selectIndex];
//    NSArray *topicArr              = [self.viewModel.topicArr objectAtIndex:self.selectIndex];

    //获取第一个贴子中的subject_id
//    TopicEntity *topic             = [topicArr objectAtIndex:0];
    
//    if ([self.delegate respondsToSelector:@selector(didSelectSubjectWith:subjectId:)])
//    {
////        [self.delegate didSelectSubjectWith:subject.title
////                                  subjectId:[topic.subject_id intValue]];
////
//
//    }
    
}



@end
