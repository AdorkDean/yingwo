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

#import "TieZiViewModel.h"

#import "TieZi.h"
#import "TieZiComment.h"

#import "DetailViewModelHepler.h"

#import "UMSocialUIManager.h"

typedef NS_ENUM(NSInteger,ReloadModel) {
    HeaderReloadDataModel,
    FooterReoladDataModel
};

/**
 *  DetailViewController 的ViewModel
 */
@interface DetailViewModel : NSObject

@property (nonatomic, strong) TieZiViewModel *tieZiViewModel;

@property (nonatomic, strong) RACCommand *fetchDetailEntityCommand;
//楼主的user_id
@property (nonatomic, assign) NSInteger master_id;

@property (nonatomic, strong) NSMutableArray *imageUrlEntity;

/**
 *  请求原贴
 *
 *  @param url        Post/detail
 *  @param paramaters post_id
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)requestDetailWithUrl:(NSString *)url
                  paramaters:(NSDictionary *)paramaters
                     success:(void (^)(TieZi *tieZi))success
                     failure:(void (^)(NSString *error))failure;

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
 *  请求回帖
 *
 *  @param url        /Post/reply_list
 *  @param paramaters post_id 和 page
 *  @param success    成功返回所有回帖
 *  @param failure    失败
 */
- (void)requestReplyWithUrl:(NSString *)url
                 paramaters:(NSDictionary *)paramaters
                    success:(void (^)(NSArray *tieZi))success
                    failure:(void (^)(NSURLSessionDataTask *,NSError *))failure;


/**
 *  发表评论
 *
 *  @param url        发表评论的url
 *  @param paramaters 参数四个post_reply_id、post_comment_id、post_comment_user_id、content
 *  @param success    成功
 *  @param failure    失败
 */
- (void)postCommentWithUrl:(NSString *)url
                paramaters:(NSDictionary *)paramaters
                   success:(void (^)(StatusEntity *status))success
                   failure:(void (^)(NSString *error))failure;

/**
 *  获取每一个跟贴的评论
 *
 *  @param url        获取评论的url
 *  @param paramaters 两个参数：post_reply_id，page
 *  @param success    成功
 *  @param failure    失败
 */
- (void)requestForCommentWithUrl:(NSString *)url
                      paramaters:(NSDictionary *)paramaters
                         success:(void (^)(NSArray *commentArr))success
                         failure:(void (^)(NSString *error))failure;


/**
 *  删除回帖
 *
 *  @param url        /Post/reply_del
 *  @param paramaters reply_id
 *  @param success
 *  @param failure    失败
 */
- (void)deleteReplyWithUrl:(NSString *)url
                paramaters:(NSDictionary *)paramaters
                   success:(void (^)(StatusEntity *statusEntity))success
                   failure:(void (^)(NSString *error))failure;

/**
 *  删除回帖评论
 *
 *  @param url        /Post/comment_del
 *  @param paramaters comment_id
 *  @param success    
 *  @param failure    失败
 */
- (void)deleteCommentWithUrl:(NSString *)url
                  paramaters:(NSDictionary *)paramaters
                     success:(void (^)(StatusEntity *statusEntity))success
                     failure:(void (^)(NSString *error))failure;

//分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(TieZi *)model;
//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType withModel:(TieZi *)model;
@end
