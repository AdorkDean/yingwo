//
//  YWDiscoveryBaseCell.h
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXScrollView.h"

#import "YWFieldListView.h"
#import "YWTopicListView.h"

#import "FieldEntity.h"
#import "SubjectEntity.h"
#import "TopicEntity.h"

@protocol YWSubjectViewCellDelegate;

@interface YWDiscoveryBaseCell : UITableViewCell

@property (nonatomic,strong ) NSMutableArray       *images;
@property (nonatomic, strong) MXImageScrollView    *mxScrollView;

@property (nonatomic, strong) YWFieldListView           *fieldListView;
@property (nonatomic, strong) YWTopicListView           *topicListView;

@property (nonatomic, assign) id<YWSubjectViewCellDelegate> delegate;

- (void)createSubview;
- (void)addTopicListViewBy:(NSArray *)topicArr;



@end
