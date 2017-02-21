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

typedef void(^DeleteCommentSuccessBlock)(id deleteCommentSuccessBlock);
typedef void(^DeleteCommentFailureBlock)(id deleteCommentFailureBlock);


@interface ReplyViewModel : DetailViewModel

@property (nonatomic, strong) RACCommand *fetchReplyEntityCommand;

@property (nonatomic, strong) DeleteTieZiSuccessBlock deleteSuccessBlock;
@property (nonatomic, strong) DeleteFailureBlock      deleteFailureBlock;

@property (nonatomic, strong) DeleteCommentSuccessBlock deleteCommentSuccessBlock;
@property (nonatomic, strong) DeleteCommentSuccessBlock deleteCommentFailureBlock;

- (void)setupModelOfCell:(YWReplyCell *)cell
                   model:(TieZiReply *)model;

- (void)setDeleteSuccessBlock:(DeleteTieZiSuccessBlock)deleteSuccessBlock
                 failureBlock:(DeleteFailureBlock)deleteFailureBlock;

- (void)setDeleteCommentSuccessBlock:(DeleteCommentSuccessBlock)deleteCommentSuccessBlock
                             failure:(DeleteCommentSuccessBlock)failure;

/**
 删帖
 
 @param request 请求模型
 */
- (void)deleteTieZiWithRequest:(RequestEntity *)request;

/**
 *  删除回帖评论
 *
 *  @param url        /Post/comment_del
 *  @param parameter comment_id
 *  @param success
 *  @param failure    失败
 */
- (void)deleteCommentWithRequest:(RequestEntity *)request;


@end
