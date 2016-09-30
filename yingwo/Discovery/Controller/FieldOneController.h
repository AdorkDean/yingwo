//
//  SchoolLifeController.h
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "DiscoveryController.h"

@interface FieldOneController : BaseViewController

@property (nonatomic, strong) UITableView       *discoveryTableView;

@property (nonatomic, strong) UITableView       *tableView;


@property (nonatomic, assign) id<DiscoveryDelegate> delegate;

@end


