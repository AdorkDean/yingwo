//
//  ViewModel.m
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TieZiViewModel.h"
#import "YWHomeTableViewCellNoImage.h"
#import "YWHomeTableViewCellOneImage.h"
#import "YWHomeTableViewCellTwoImage.h"
#import "YWHomeTableViewCellThreeImage.h"
#import "YWHomeTableViewCellFourImage.h"
#import "YWHomeTableViewCellSixImage.h"
#import "YWHomeTableViewCellNineImage.h"
#import "YWHomeTableViewCellMoreNineImage.h"

@implementation TieZiViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupRACComand];
        
    }
    return self;
}


- (void)setupRACComand {
    
    @weakify(self);
    _fecthTieZiEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            RequestEntity *requestEntity = (RequestEntity *)input;
            
            NSDictionary *paramaters = nil;
            
            if (requestEntity.filter == AllThingModel) {
                paramaters = @{@"start_id":@(requestEntity.start_id)};
            }
            else
            {
                paramaters = @{@"filter":@(requestEntity.filter),
                             @"start_id":@(requestEntity.start_id)};
            }
            
            
            [self requestTieZiWithUrl:requestEntity.requestUrl
                           paramaters:paramaters
                              success:^(NSArray *tieZi) {
                                     
                                     [subscriber sendNext:tieZi];
                                     [subscriber sendCompleted];
                                     
                                 } error:^(NSURLSessionDataTask *task, NSError *error) {
                                     [subscriber sendError:error];
                                 }];
            
            return nil;
        }];
    }];
    
}

- (void)setupModelOfCell:(YWHomeTableViewCellBase *)cell model:(TieZi *)model {
    

    if (model.topic_id != 0) {
        
        cell.labelView.title.topic_id   = model.topic_id;
        cell.labelView.title.label.text = model.topic_title;

    }
    else
    {
        cell.labelView.title.topic_id   = 0;
        cell.labelView.title.label.text = @"新鲜事";
    }
    
    cell.contentText.text                            = model.content;
    cell.bottemView.nickname.text                    = model.user_name;
    cell.bottemView.favourLabel.text                 = model.like_cnt;
    cell.bottemView.messageLabel.text                = model.reply_cnt;
    NSString *dataString                             = [NSString stringWithFormat:@"%d",model.create_time];
    cell.bottemView.time.text                        = [NSDate getDateString:dataString];
    cell.bottemView.headImageView.layer.cornerRadius = 20;
    cell.bottemView.favour.post_id                   = model.tieZi_id;

    //获取正确的头像url
    model.user_face_img = [NSString selectCorrectUrlWithAppendUrl:model.user_face_img];
    
    [cell.bottemView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.user_face_img]
                                     placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    //判断是否有点赞记录
    if ([self isLikedTieZiWithTieZiId:[NSNumber numberWithInt:model.tieZi_id]]) {
        [cell.bottemView.favour setBackgroundImage:[UIImage imageNamed:@"heart_red"]
                                          forState:UIControlStateNormal];
         cell.bottemView.favour.isSpring = YES;
    }
    else
    {
        [cell.bottemView.favour setBackgroundImage:[UIImage imageNamed:@"heart_gray"]
                                          forState:UIControlStateNormal];
        cell.bottemView.favour.isSpring = NO;
    }
    
    if (model.imageUrlArrEntity.count == 3) {
        
    }
    
    if (model.imageUrlArrEntity.count > 0) {
        
        for (int i = 0; i < model.imageUrlArrEntity.count; i ++) {
            
            ImageViewEntity *imageEntity = [model.imageUrlArrEntity objectAtIndex:i];
            //图片请求
            [self requestImageForCell:cell WithUrl:imageEntity.imageName withModel:model imageViewTag:i+1];
        }
        
        if (model.imageUrlArrEntity.count == 5 || model.imageUrlArrEntity.count == 8) {
            //count = 5 第6张不显示
            //count = 8 第9张不显示
            [self requestNullImageForCell:cell
                                  WithUrl:nil
                                withModel:nil
                             nullImageTag:model.imageUrlArrEntity.count+1];
        }
        if (model.imageUrlArrEntity.count == 7) {
            //count = 7 第8、9张不显示
            [self requestNullImageForCell:cell
                                  WithUrl:nil withModel:nil
                             nullImageTag:model.imageUrlArrEntity.count+1];
            
            [self requestNullImageForCell:cell
                                  WithUrl:nil
                                withModel:nil
                             nullImageTag:model.imageUrlArrEntity.count+2];

        }
    }
    
}

/**
 *  cell上图片请求
 *
 *  @param cell    对应cell
 *  @param partUrl 部分url
 *  @param model   TiZi模型
 *  @param tag     UIImageView的tag
 */
- (void)requestImageForCell:(YWHomeTableViewCellBase *)cell
                    WithUrl:(NSString *)partUrl
                  withModel:(TieZi *)model
               imageViewTag:(NSInteger)tag{
    
    int imageWidth;
    
    //这里算出的宽度值要乘以2变成像素值
    if (tag == 1) {
        imageWidth = (SCREEN_WIDTH - 10*2 - 5 *2)*2;
    }
    else if (tag == 2 || tag == 4) {
        imageWidth = (SCREEN_WIDTH - 10*2 - 5 *2 - 5 * 1)/2*2;
    }
    else if(tag > 2) {
        imageWidth = (SCREEN_WIDTH - 10*2 - 5 *2 - 5 * 2)/3*2;
    }
    //图片模式，这里请求的是正方形图片
    NSString *imageMode    = [NSString stringWithFormat:QINIU_SQUARE_IMAGE_MODEL,imageWidth];
    NSString *fullurl      = [partUrl stringByAppendingString:imageMode];
    NSURL *imageUrl        = [NSURL URLWithString:fullurl];
    
    UIImageView *imageView = [cell.middleView viewWithTag:tag];
    
    [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"ying"]];
    
}

/**
 *  空图片显示,例如5张图片情况下，第6张图片是不显示图片的
 *
 *  @param cell    对应的cell
 *  @param partUrl 部分url
 *  @param model   TiZi模型
 *  @param tag     UIImageView的tag
 */
- (void)requestNullImageForCell:(YWHomeTableViewCellBase *)cell
                        WithUrl:(NSString *)partUrl
                      withModel:(TieZi *)model nullImageTag:(NSInteger)tag {
    
    UIImageView *imageView = [cell.middleView viewWithTag:tag];
    imageView.image = nil;
    
}

- (NSString *)idForRowByModel:(TieZi *)model {
    
    //不能用model.imageUrlArr.count 返回的是<nil>,系统默认为1😭
    if (model.imageUrlArrEntity == nil) {
        return @"noImageCell";
    }else if (model.imageUrlArrEntity.count == 1) {
        return @"oneImageCell";
    }else if (model.imageUrlArrEntity.count == 2) {
        return @"twoImageCell";
    }else if (model.imageUrlArrEntity.count == 3) {
        return @"threeImageCell";
    }else if (model.imageUrlArrEntity.count == 4) {
        return @"fourImageCell";
    }else if (model.imageUrlArrEntity.count <= 6) {
        return @"sixImageCell";
    }else if (model.imageUrlArrEntity.count <= 9) {
        return @"nineImageCell";
    }else if (model.imageUrlArrEntity.count > 9) {
        return @"moreNineImageCell";
    }
    
    return @"noImageCell";

}

- (void)requesAllThingsWithUrl:(NSString *)url
                    paramaters:(id)paramaters
                       success:(void (^)(NSArray *))success
                         error:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];

    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              
              TieZiResult *tieZiResult = [TieZiResult mj_objectWithKeyValues:content];
              NSArray *tieZiArr        = [TieZi mj_objectArrayWithKeyValuesArray:tieZiResult.info];
              
              
                NSLog(@"tieZiArr:%@",tieZiResult.info);

              //需要将返回的url字符串，转化为imageUrl数组
              [self changeImageUrlModelFor:tieZiArr];
              
              success(tieZiArr);
              
              //  NSLog(@"content:%@",content);
              //  NSLog(@"tieZiArr:%@",tieZiResult.info);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"error:%@",error);
              failure(task,error);
              
          }];
}

- (void)requestTieZiWithUrl:(NSString *)url
                 paramaters:(id)paramaters
                    success:(void (^)(NSArray *))success
                      error:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
              
              
              TieZiResult *tieZiResult = [TieZiResult mj_objectWithKeyValues:content];
              
              NSArray *tieZiArr        = [TieZi mj_objectArrayWithKeyValuesArray:tieZiResult.info];
              
          //    NSLog(@"tieZiArr:%@",tieZiResult.info);
              
              //需要将返回的url字符串，转化
              //为imageUrl数组
              [self changeImageUrlModelFor:tieZiArr];
              
              success(tieZiArr);
              
              //  NSLog(@"content:%@",content);
              //  NSLog(@"tieZiArr:%@",tieZiResult.info);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"error:%@",error);
              failure(task,error);
              
          }];

}

- (void)requestFreshThingWithUrl:(NSString *)url
                 paramaters:(id)paramaters
                    success:(void (^)(NSArray *tieZi))success
                      error:(void (^)(NSURLSessionDataTask *task,NSError *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              
              TieZiResult *tieZiResult = [TieZiResult mj_objectWithKeyValues:content];
              NSArray *tieZiArr        = [TieZi mj_objectArrayWithKeyValuesArray:tieZiResult.info];
              
              //需要将返回的url字符串，转化为imageUrl数组
              [self changeImageUrlModelFor:tieZiArr];
              
              success(tieZiArr);
              
            //  NSLog(@"content:%@",content);
            //  NSLog(@"tieZiArr:%@",tieZiResult.info);
              
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
        failure(task,error);

    }];
}


- (void)changeImageUrlModelFor:(NSArray *)tieZiArr {
    
    for (TieZi *tie in tieZiArr) {
        tie.imageUrlArrEntity = [NSString separateImageViewURLString:tie.img];
        
    }
    
}

- (void)downloadCompletedImageViewByUrls:(NSArray *)imageEntities
                                progress:(void (^)(CGFloat))progress
                                 success:(void (^)(NSMutableArray *imageArr))imageArr
                                 failure:(void (^)(NSString *error))failure{
    
    
   ImageViewEntity *imageEntity = [imageEntities objectAtIndex:0];
   NSMutableArray *imageUrls    = [ImageViewEntity getImageUrlsFromImageEntities:imageEntities];
   Boolean hasExsitImages       = [YWSandBoxTool isExistImageByName:imageEntity.imageName];

    //先从沙盒中找图片
    if (hasExsitImages) {
        imageArr([YWSandBoxTool getImagesFromCacheByUrlsArr:imageUrls]);
        progress(1);
    }
    else
    {
        [YWAvatarBrowser downloadImagesWithUrls:imageUrls
                                       progress:^(CGFloat progressNum) {
                                           progress(progressNum);
                                       }
                                        success:^(NSMutableArray *success) {
                                            
                                            imageArr(success);
                                            //  [YWAvatarBrowser showImage:avatarImageView WithImageViewArr:success];
                                            
                                        } failure:^(NSString *error) {
                                            failure(error);
                                            NSLog(@"failure:%@",error);
                                        }];
    }

}

- (void)deleteTieZiWithUrl:(NSString *)url
                paramaters:(NSDictionary *)paramaters
                   success:(void (^)(StatusEntity *statusEntity))success
                   failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:nil];
                  StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                success(entity);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
}

- (void)postTieZiLIkeWithUrl:(NSString *)url
                  paramaters:(NSDictionary *)paramaters
                    success:(void (^)(StatusEntity *statusEntity))success
                    failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:nil];
                  StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                  //本地存储点赞记录
                  
                  [self saveLikeCookieWithPostId:paramaters[@"post_id"]];
                  success(entity);
              }
              
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)postReplyTieZiLikeWithUrl:(NSString *)url
                       paramaters:(NSDictionary *)paramaters
                          success:(void (^)(StatusEntity *))success
                          failure:(void (^)(NSString *))failure {
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:nil];
                  StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                  //本地存储点赞记录
                  
                  [self saveLikeCookieWithReplyId:paramaters[@"reply_id"]];
                  success(entity);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];

    
}
//保存点赞记录
- (void)saveLikeCookieWithPostId:(NSNumber *) postId{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *likeArr     = [userDefault objectForKey:TIEZI_LIKE_COOKIE];
    
    if (likeArr == nil ) {
        
        likeArr = [[NSMutableArray alloc] init];
    }
    else
    {
        likeArr = [NSMutableArray arrayWithArray:likeArr];
    }
    
    [likeArr addObject:postId];
    [userDefault setObject:likeArr forKey:TIEZI_LIKE_COOKIE];
    
}

//取消点赞记录
- (void)deleteLikeCookieWithPostId:(NSNumber *) postId{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *likeArr     = [userDefault objectForKey:TIEZI_LIKE_COOKIE];
    
    if (likeArr == nil ) {
        
        return;
    }
    else
    {
        likeArr = [NSMutableArray arrayWithArray:likeArr];
    }
    
    [likeArr removeObject:postId];
    [userDefault setObject:likeArr forKey:TIEZI_LIKE_COOKIE];
    
}

//判断是否有点赞记录
- (BOOL)isLikedTieZiWithTieZiId:(NSNumber *)postId {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *likeArr     = [userDefault objectForKey:TIEZI_LIKE_COOKIE];
    
    for (NSNumber *tieZiId in likeArr) {
        if ([tieZiId integerValue] == [postId integerValue]) {
            return YES;
        }
    }
    
    return NO;
}

//保存跟帖点赞记录
- (void)saveLikeCookieWithReplyId:(NSNumber *) replyId {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *likeArr     = [userDefault objectForKey:TIEZI_REPLY_LIKE_COOKIE];
    
    if (likeArr == nil ) {
        
        likeArr = [[NSMutableArray alloc] init];
    }
    else
    {
        likeArr = [NSMutableArray arrayWithArray:likeArr];
    }
    
    [likeArr addObject:replyId];
    [userDefault setObject:likeArr forKey:TIEZI_REPLY_LIKE_COOKIE];
    
}

//取消跟帖点赞记录
- (void)deleteLikeCookieWithReplyId:(NSNumber *) replyId {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *likeArr     = [userDefault objectForKey:TIEZI_REPLY_LIKE_COOKIE];
    
    if (likeArr == nil ) {
        
        return;
    }
    else
    {
        likeArr = [NSMutableArray arrayWithArray:likeArr];
    }
    
    [likeArr removeObject:replyId];
    [userDefault setObject:likeArr forKey:TIEZI_REPLY_LIKE_COOKIE];
    
}

//判断跟帖是否有点赞记录
- (BOOL)isLikedTieZiWithReplyId:(NSNumber *) replyId {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *likeArr     = [userDefault objectForKey:TIEZI_REPLY_LIKE_COOKIE];
    
    for (NSNumber *postId in likeArr) {
        if ([postId integerValue] == [replyId integerValue]) {
            return YES;
        }
    }
    
    return NO;
}


@end
