//
//  FavorController.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageController.h"

@interface FavorController : BaseViewController

@property (nonatomic, strong) UITableView      *tableView;

@property (nonatomic, assign) id<MessageControllerDelegate> delegate;

@end
