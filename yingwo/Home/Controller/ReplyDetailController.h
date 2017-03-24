//
//  ReplyDetailController.h
//  yingwo
//
//  Created by apple on 2017/1/30.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWDetailTableViewCell.h"
#import "YWDetailBaseTableViewCell.h"
#import "YWDetailReplyCell.h"

#import "DetailViewModel.h"

#import "YWDetailBottomView.h"
#import "YWDetailCommentView.h"
#import "YWCommentView.h"

#import "TieZiComment.h"

#import "YWAlertButton.h"

@interface ReplyDetailController : BaseViewController

@property (nonatomic, strong) TieZiReply  *model;
@property (nonatomic, strong) TieZi       *tieziModel;

@property (nonatomic, assign) CommentType commentType;

@property (nonatomic, assign) BOOL        shouldShowKeyboard;
@property (nonatomic, assign) BOOL        isFromMessage;

- (instancetype)initWithReplyModel:(TieZiReply *)model shouldShowKeyBoard:(BOOL)yesOrNo;

@end
