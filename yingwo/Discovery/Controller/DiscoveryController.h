//
//  YWDiscoveryController.h
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

@protocol DiscoveryControllerDelegate ;

@interface DiscoveryController : BaseViewController

@property (nonatomic, strong) RACCommand *fecthTopicEntityCommand;
@property (nonatomic, assign) BOOL       isStopTableView;

@property (nonatomic, strong) id<DiscoveryControllerDelegate>delegate;


@end

@protocol DiscoveryControllerDelegate <NSObject>

- (void)didSelectModuleTopicWith:(int)topic_id;

- (void)didSelectModuleTopicWith:(int)topic_id subjectId:(int)subjectId subject:(NSString *)subject;

@end
