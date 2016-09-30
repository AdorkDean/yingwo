//
//  TopicViewModel.h
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWTopicViewCell.h"

#import "TopicEntity.h"

@interface TopicListViewModel : NSObject

<<<<<<< HEAD
@property (nonatomic, strong) RACCommand *fecthTopicEntityCommand;

@property (nonatomic, assign) BOOL       isMyTopic;

=======
>>>>>>> origin/master
- (void)setupModelOfCell:(YWTopicViewCell *)cell model:(TopicEntity *)model;

@end
