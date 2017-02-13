//
//  TopicController.h
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "TopicListViewModel.h"

@protocol TopicListControllerDelegate;

typedef NS_ENUM(NSInteger,TopicTypeModel) {
    
    AllTopicModel   = 0, //话题
    OneFieldModel   = 1, //校园生活
    TwoFieldModel   = 2, //兴趣爱好
    ThreeFieldModel = 3, //学科专业
};

@interface TopicListController : BaseViewController

@property (nonatomic, strong) UITableView        *topicTableView;
@property (nonatomic, strong) UIScrollView       *topicScrollView;

@property (nonatomic, strong) TopicListViewModel *viewModel;

@property (nonatomic, assign) int                userId;

//判断是否是从我的话题跳转过来的
@property (nonatomic, assign) BOOL               isMyTopic;

//根据topicType，给出self.title的名字
@property (nonatomic, assign) TopicTypeModel     topicType;

//主题名字
@property (nonatomic, copy  ) NSString           *subject;

//领域下的id
@property (nonatomic, assign) int                field_id;

//主题id
@property (nonatomic, assign) int                subject_id;

//主题下话题数组
@property (nonatomic, strong) NSArray            *topicArr;

@property (nonatomic, assign) id<TopicListControllerDelegate>            delegate;



@end

@protocol TopicListControllerDelegate <NSObject>

- (void)didSelectTopicListWith:(int)topicId;

@end
