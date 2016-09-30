//
//  YWSubjectViewCell.h
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWFieldListView.h"
#import "YWTopicListView.h"

#import "FieldEntity.h"
#import "SubjectEntity.h"
#import "TopicEntity.h"

@protocol YWSubjectViewCellDelegate;

@interface YWSubjectViewCell : UITableViewCell

@property (nonatomic, strong) YWFieldListView           *fieldListView;
@property (nonatomic, strong) YWTopicListView           *topicListView;

@property (nonatomic, assign) id<YWSubjectViewCellDelegate> delegate;

- (void)createSubview;
- (void)addTopicListViewBy:(NSArray *)topicArr;

@end

@protocol YWSubjectViewCellDelegate <NSObject>

- (void)didSelectTopicWith:(int)topicId;

@end
