//
//  MessageDetailController.h
//  yingwo
//
//  Created by apple on 2016/11/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailController.h"
#import "TieZiReply.h"
#import "MessageEntity.h"

@interface MessageDetailController : BaseViewController

//点击的贴子
@property (nonatomic, strong) MessageEntity       *model;

@property (nonatomic, assign) CommentType commentType;

@property (nonatomic, strong) TieZiReply  *replyModel;

//是否跟贴完成
@property (nonatomic, assign) BOOL        isReleased;

@property (nonatomic, strong) NSDictionary *tieZiParamters;

@end
