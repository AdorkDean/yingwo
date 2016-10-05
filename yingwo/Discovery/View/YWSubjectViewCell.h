//
//  YWSubjectViewCell.h
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWDiscoveryBaseCell.h"

#import "TopicEntity.h"

@interface YWSubjectViewCell : YWDiscoveryBaseCell


@end

@protocol YWSubjectViewCellDelegate <NSObject>

- (void)didSelectTopicWith:(int)topicId;

@end
