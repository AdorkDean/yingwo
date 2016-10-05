//
//  YWDiscoveryController.h
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"


@interface DiscoveryController : BaseViewController

@property (nonatomic, strong) RACCommand *fecthTopicEntityCommand;
@property (nonatomic, assign) BOOL       isStopTableView;

@end

