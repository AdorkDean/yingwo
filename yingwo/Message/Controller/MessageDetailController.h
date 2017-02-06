//
//  MessageDetailController.h
//  yingwo
//
//  Created by apple on 2016/11/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DetailController.h"
#import "MessageEntity.h"

@interface MessageDetailController : DetailController

//点击的贴子
@property (nonatomic, strong) MessageEntity       *model;

@end
