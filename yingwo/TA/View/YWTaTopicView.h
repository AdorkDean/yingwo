//
//  YWTaTopicView.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicEntity.h"

@protocol YWTaTopicViewDelegate;

@interface YWTaTopicView : UIView

- (void)addTopicListViewBy:(NSArray *)entities;
@property (nonatomic, assign) id<YWTaTopicViewDelegate> delegate;

@end

@protocol YWTaTopicViewDelegate <NSObject>

- (void)didSelectTopicWith:(int)topicId;

@end
