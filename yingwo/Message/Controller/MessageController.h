//
//  MessageController.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageEntity.h"

@protocol MessageControllerDelegate ;

@interface MessageController : BaseViewController

@end

@protocol MessageControllerDelegate <NSObject>

- (void)didSelectMessageWith:(MessageEntity *)model;

@end
