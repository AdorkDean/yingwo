//
//  ReplyViewModel.h
//  yingwo
//
//  Created by apple on 2017/2/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "DetailViewModel.h"
#import "YWReplyCell.h"

typedef void(^DeleteTieZiSuccessBlock)(id deleteSuccessBlock);
typedef void(^DeleteFailureBlock)(id deleteFailureBlock);

@interface ReplyViewModel : DetailViewModel

@property (nonatomic, strong) RACCommand *fetchReplyEntityCommand;

@property (nonatomic, strong) DeleteTieZiSuccessBlock deleteSuccessBlock;
@property (nonatomic, strong) DeleteFailureBlock      deleteFailureBlock;

- (void)setupModelOfCell:(YWReplyCell *)cell
                   model:(TieZiReply *)model;

- (void)setDeleteSuccessBlock:(DeleteTieZiSuccessBlock)deleteSuccessBlock
                 failureBlock:(DeleteFailureBlock)deleteFailureBlock;

/**
 删帖
 
 @param request 请求模型
 */
- (void)deleteTieZiWithRequest:(RequestEntity *)request;

@end
