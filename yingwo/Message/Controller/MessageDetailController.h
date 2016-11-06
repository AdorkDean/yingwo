//
//  MessageDetailController.h
//  yingwo
//
//  Created by apple on 2016/11/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailController.h"
#import "TieZi.h"
#import "TieZiReply.h"

@interface MessageDetailController : BaseViewController

//点击的贴子
@property (nonatomic, strong) TieZi       *model;

@property (nonatomic, assign) CommentType commentType;

@property (nonatomic, strong) TieZiReply  *replyModel;

//是否跟贴完成
@property (nonatomic, assign) BOOL        isReleased;

@property (nonatomic, strong) NSDictionary *tieZiParamters;

@end
