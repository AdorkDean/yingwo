//
//  ViewModel.h
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWHomeTableViewCellBase.h"
#import "TieZi.h"
#import "TieZiResult.h"
#import "HomeController.h"
#import "BadgeCount.h"

typedef void(^ImageCntBlock)(NSUInteger imageCnt);

/**
 *  HomeViewController 的ViewModel
 */
@interface TieZiViewModel : NSObject

@property (nonatomic, strong)RACCommand     *fecthTieZiEntityCommand;
@property (nonatomic, assign)NSArray        *imageUrlArr;

@property (nonatomic, assign)int            user_id;

@property (nonatomic, copy  )ImageCntBlock  imageCntBlock;
@property (nonatomic, assign)NSUInteger     *imageCnt;

- (void)setupRACComand;

/**
 *  找cell的id
 *
 *  @param model TieZi
 *  return 返回id
 */
- (NSString *)idForRowByModel:(TieZi *)model;

/**
 *  CellModel
 *
 *  @param cell YWHomeTableViewCell
 *  @param model TieZi
 */
- (void)setupModelOfCell:(YWHomeTableViewCellBase *)cell model:(TieZi *)model;

/**
 *  不分类获取所有新鲜事、贴子信息
 *
 *  @param url
 *  @param paramaters nil
 *  @param success 返回数组
 *  @param failure 失败
 */
- (void)requesAllThingsWithUrl:(NSString *)url
                    paramaters:(id)paramaters
                       success:(void (^)(NSArray *tieZi))success
                         error:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;


/**
 *  获取贴子
 *
 *  @param url
 *  @param paramaters cat_id = 1
 *  @param success    返回数组
 *  @param failure    失败
 */
- (void)requestTieZiWithUrl:(NSString *)url
                 paramaters:(id)paramaters
                    success:(void (^)(NSArray *tieZi))success
                      error:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;


/**
 *  新鲜事请求
 *
 *  @param url        http://yw.zhibaizhi.com/yingwophp/post/get_post_list
 *  @param paramaters cat_id
 *  @param success    返回数组
 *  @param failure    失败
 */
- (void)requestFreshThingWithUrl:(NSString *)url
                      paramaters:(id)paramaters
                         success:(void (^)(NSArray *tieZi))success
                           error:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

/**
 *  图片下载
 *
 *  @param imageUrls 图片url数组
 *  @param imageArr  成功返回UIImage数组
 *  @param failure   失败
 */
- (void)downloadCompletedImageViewByUrls:(NSArray *)imageUrls
                                progress:(void (^)(CGFloat))progress
                                 success:(void (^)(NSMutableArray *imageArr))imageArr
                                 failure:(void (^)(NSString *failure))failure;

/**
 *  删除帖子
 *
 *  @param url        /Post/del
 *  @param paramaters post_id（帖子ID）
 *  @param success    成功回调StatusEntity
 *  @param failure    失败
 */
- (void)deleteTieZiWithUrl:(NSString *)url
               paramaters:(NSDictionary *)paramaters
                  success:(void (^)(StatusEntity *statusEntity))success
                  failure:(void (^)(NSString *error))failure;

/**
 *  新帖子数量请求
 *
 *  @param url        /Post/index_cnt
 *  @param paramaters 空
 *  @param success    成功返回新帖子数量
 *  @param failure    失败
 */
- (void)requestForBadgeWithUrl:(NSString *)url
                    paramaters:(NSDictionary *)paramaters
                       success:(void (^)(int badgeCount))success
                       failure:(void (^)(NSString *error))failure;


/**
 *  点赞请求
 *
 *  @param url        /Post/like
 *  @param paramaters post_id（帖子ID）、value（	0为取消喜欢 1为喜欢）
 *  @param success    成功回调StatusEntity
 *  @param failure    失败
 */
- (void)postTieZiLIkeWithUrl:(NSString *)url
                  paramaters:(NSDictionary *)paramaters
                     success:(void (^)(StatusEntity *statusEntity))success
                     failure:(void (^)(NSString *error))failure;

/**
 *  跟帖点赞请求
 *
 *  @param url        /Post/reply_like
 *  @param paramaters reply_id（帖子ID）、value（	0为取消喜欢 1为喜欢）
 *  @param success    成功回调StatusEntity
 *  @param failure    失败
 */
- (void)postReplyTieZiLikeWithUrl:(NSString *)url
                       paramaters:(NSDictionary *)paramaters
                          success:(void (^)(StatusEntity *statusEntity))success
                          failure:(void (^)(NSString *error))failure;

/**
 *  本地保存点赞记录
 *
 *  @param postId 贴子id
 */
- (void)saveLikeCookieWithPostId:(NSNumber *) postId;

/**
 *  取消点赞记录
 *
 *  @param postId 贴子id
 */
- (void)deleteLikeCookieWithPostId:(NSNumber *) postId;

/**
 *  判断是否有点赞过
 *
 *  @param postId 贴子id
 *
 *  @return YES or NO
 */
- (BOOL)isLikedTieZiWithTieZiId:(NSNumber *) postId;

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

/**
 *  判断跟帖是否有点赞过
 *
 *  @param replyId 跟帖id
 *
 *  @return YES or NO
 */
- (BOOL)isLikedTieZiWithReplyId:(NSNumber *) replyId;

@end
