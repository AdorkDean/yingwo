//
//  DetailViewModel.h
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailController.h"

#import "YWDetailBaseTableViewCell.h"
#import "YWDetailReplyCell.h"
#import "YWDetailTableViewCell.h"
#import "TieZiReply.h"
#import "GalleryViewModel.h"
#import "TieZi.h"
#import "TieZiComment.h"
#import "ReplyCommentList.h"

typedef NS_ENUM(NSInteger,ReloadModel) {
    HeaderReloadDataModel,
    FooterReoladDataModel
};

typedef void(^ReplyLikeTieZiBlock)(id likeSuccessBlock);
typedef void(^ReplyLikeFailureBlock)(id likeFailureBlock);

typedef void(^CommentReplySuccessBlock)(id commentReplySuccessBlock);
typedef void(^CommentReplyFailureBlock)(id commentReplyFailureBlock);

typedef void(^CommentListSuccessBlock)(id commentListSuccessBlock);
typedef void(^CommentListFailureBlock)(id commentListFailureBlock);

/**
 *  DetailViewController 的ViewModel
 */
@interface DetailViewModel : BaseViewModel

@property (nonatomic, strong) ReplyLikeTieZiBlock      likeSuccessBlock;
@property (nonatomic, strong) ReplyLikeFailureBlock    likeFailureBlock;

@property (nonatomic, strong) CommentReplySuccessBlock commentReplySuccessBlock;
@property (nonatomic, strong) CommentReplyFailureBlock commentReplyFailureBlock;

@property (nonatomic, strong) CommentListSuccessBlock  commentListSuccessBlock;
@property (nonatomic, strong) CommentListFailureBlock  commentListFailureBlock;


@property (nonatomic, strong) GalleryViewModel         *tieZiViewModel;

@property (nonatomic, strong) RACCommand               *fetchDetailEntityCommand;
//楼主的user_id
@property (nonatomic, assign) NSInteger                master_id;

@property (nonatomic, strong) NSMutableArray *imageUrlEntity;

- (void)setLikeSuccessBlock:(ReplyLikeTieZiBlock)likeSuccessBlock
           likeFailureBlock:(ReplyLikeFailureBlock)likeFailureBlock;

- (void)setCommentReplySuccessBlock:(CommentReplySuccessBlock)commentReplySuccessBlock
                            failure:(CommentReplyFailureBlock)commentReplyFailureBlock;

- (void)setCommentListSuccessBlock:(CommentListSuccessBlock)commentListSuccessBlock
                           failure:(CommentListFailureBlock)commentListFailureBlock;


- (void)setupRACComand;

/**
 *  初始化cell
 *
 *  @param cell  YWDetailBaseTableViewCell
 *  @param model TieZi
 *  @param model indexPath 用来算楼层的
 */
- (void)setupModelOfCell:(YWDetailBaseTableViewCell *)cell
                   model:(TieZiReply *)model
               indexPath:(NSIndexPath *)indexPath;
/**
 *  寻找相对应的id
 *
 *  @param indexPath NSIndexPath
 *  @param model     TieZi
 *
 *  @return 返回id
 */
- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath model:(TieZi *)model;


/**
 获取回复

 @param request parameter replyId
 */
- (void)requestReplyWithRequest:(RequestEntity *)request
                        success:(void (^)(NSArray *tieZi))success
                        failure:(void (^)(id error))failure;

/**
 *  发表评论
 *
 *  @param url        发表评论的url
 *  @param parameter 参数四个post_reply_id、post_comment_id、post_comment_user_id、content
 */
- (void)postCommentWithRequest:(RequestEntity *)request;

/**
 请求评论，用于发表评论时刷新评论

 @param request  两个参数：post_reply_id，page
 */
- (void)requestCommentWithRequest:(RequestEntity *)request;

/**
 *  删除回帖
 *
 *  @param url        /Post/reply_del
 *  @param parameter reply_id
 *  @param success
 *  @param failure    失败
 */
- (void)deleteReplyWithUrl:(NSString *)url
                parameter:(NSDictionary *)parameter
                   success:(void (^)(StatusEntity *statusEntity))success
                   failure:(void (^)(NSString *error))failure;


/**
 *  删除回帖评论
 *
 *  @param url        /Post/comment_del
 *  @param parameter comment_id
 *  @param success    
 *  @param failure    失败
 */
- (void)deleteCommentWithUrl:(NSString *)url
                  parameter:(NSDictionary *)parameter
                     success:(void (^)(StatusEntity *statusEntity))success
                     failure:(void (^)(NSString *error))failure;


/**
 *  点赞请求
 *
 *  @param parameter post_id（帖子ID）、value（	0为取消喜欢 1为喜欢）
 */
- (void)requestForReplyLikeTieZiWithRequest:(RequestEntity *)request;

/**
 *  判断跟帖是否有点赞过
 *
 *  @param replyId 跟帖id
 *
 *  @return YES or NO
 */
- (BOOL)isLikedTieZiWithReplyId:(NSNumber *) replyId;
/**
 *  本地保存跟帖点赞记录
 *
 *  @param replyId 跟帖id
 */
- (void)saveLikeCookieWithReplyId:(NSNumber *) replyId;

/**
 *  取消跟帖点赞记录
 *
 *  @param replyId 跟帖id
 */
- (void)deleteLikeCookieWithReplyId:(NSNumber *) replyId;


//分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(TieZi *)model;
//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType withModel:(TieZi *)model;
@end
