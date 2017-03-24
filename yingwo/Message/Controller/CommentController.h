//
//  CommentController.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageController.h"

#import "YWMessageCell.h"
#import "YWImageMessageCell.h"

#import "MessageViewModel.h"

#import "MessageEntity.h"

@interface CommentController : BaseViewController<UITableViewDelegate,UITableViewDataSource,YWMessageCellDelegate>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) RequestEntity     *requestEntity;

@property (nonatomic, assign) id<MessageControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray    *messageArr;

@property (nonatomic, strong) YWEmptyRemindView  *emptyRemindView;

- (void)jumpToReplyDetailPageWithModel:(MessageEntity *)message andOriginalModel:(MessageEntity *)messageEntity;

@end


