//
//  GalleryViewModel.h
//  YWGalleryView
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWGalleryCellOfOne.h"
#import "YWGalleryCellOfTwo.h"
#import "YWGalleryCellOfThree.h"
#import "YWGalleryCellOfFour.h"
#import "YWGalleryCellOfSix.h"
#import "YWGalleryCellOfNine.h"

#import "TieZi.h"
#import "TieZiResult.h"

typedef void(^DeleteTieZiSuccessBlock)(id deleteSuccessBlock);
typedef void(^DeleteFailureBlock)(id deleteFailureBlock);

typedef void(^LikeTieZiBlock)(id likeSuccessBlock);
typedef void(^LikeFailureBlock)(id likeFailureBlock);

@interface GalleryViewModel : BaseViewModel

@property (nonatomic, strong) RACCommand              *fecthTieZiEntityCommand;
@property (nonatomic, assign) NSArray                 *imageUrlArr;

@property (nonatomic, strong) DeleteTieZiSuccessBlock deleteSuccessBlock;
@property (nonatomic, strong) DeleteFailureBlock      deleteFailureBlock;

@property (nonatomic, strong) LikeTieZiBlock          likeSuccessBlock;
@property (nonatomic, strong) LikeFailureBlock        likeFailureBlock;


- (void)setupRACComand;

- (NSString *)idForRowByModel:(TieZi *)model;


- (void)setupModelOfCell:(YWGalleryBaseCell *)cell model:(TieZi *)model;


- (void)setDeleteSuccessBlock:(DeleteTieZiSuccessBlock)deleteSuccessBlock
                 failureBlock:(DeleteFailureBlock)deleteFailureBlock;

- (void)setLikeSuccessBlock:(LikeTieZiBlock)likeSuccessBlock
            likeFailureBlock:(LikeFailureBlock)likeFailure;

/**
 *  请求原贴
 *
 *  @param url        Post/detail
 *  @param parameter post_id
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)requestDetailWithUrl:(NSString *)url
                  parameter:(NSDictionary *)parameter
                     success:(SuccessBlock) success
                     failure:(ErrorBlock) failure;


/**
 删帖

 @param request 请求模型
 */
- (void)deleteTieZiWithRequest:(RequestEntity *)request;



/**
 *  点赞请求
 *
 *  @param parameter post_id（帖子ID）、value（	0为取消喜欢 1为喜欢）
 */
- (void)requestForLikeTieZiWithRequest:(RequestEntity *)request;

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

@end













