//
//  MyCommentViewModel.h
//  yingwo
//
//  Created by apple on 2017/2/9.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewModel.h"
#import "MessageViewModel.h"

typedef void(^DeleteReplySuccessBlock)(id deleteReplySuccessBlock);
typedef void(^DeleteReplyFailureBlock)(id deleteReplyFailureBlock);

typedef void(^DeleteCommentSuccessBlock)(id deleteCommentSuccessBlock);
typedef void(^DeleteCommentFailureBlock)(id deleteCommentFailureBlock);

@interface MyCommentViewModel : MessageViewModel

@property (nonatomic, strong) RACCommand *fecthCommentEntityCommand;

@property (nonatomic, strong) DeleteReplySuccessBlock deleteReplySuccessBlock;
@property (nonatomic, strong) DeleteReplyFailureBlock deleteReplyFailureBlock;

@property (nonatomic, strong) DeleteCommentSuccessBlock deleteCommentSuccessBlock;
@property (nonatomic, strong) DeleteCommentFailureBlock deleteCommentFailureBlock;

- (void)setDeleteReplySuccessBlock:(DeleteReplySuccessBlock)deleteReplySuccessBlock
                           failure:(DeleteReplyFailureBlock)failure;

- (void)setDeleteCommentSuccessBlock:(DeleteCommentSuccessBlock)deleteCommentSuccessBlock
                             failure:(DeleteCommentFailureBlock)failure;

- (void)deleteCommentWithRequest:(RequestEntity *)request;
- (void)deleteReplyWithRequest:(RequestEntity *)request;

@end
