//
//  GalleryViewModel.m
//  YWGalleryView
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "GalleryViewModel.h"

@implementation GalleryViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupRACComand];
        
    }
    return self;
}

- (void)setDeleteSuccessBlock:(DeleteTieZiSuccessBlock)deleteSuccessBlock
                 failureBlock:(DeleteFailureBlock)deleteFailureBlock {
    
    _deleteSuccessBlock = deleteSuccessBlock;
    _deleteFailureBlock = deleteFailureBlock;
    
}

- (void)setLikeSuccessBlock:(LikeTieZiBlock)likeSuccessBlock
           likeFailureBlock:(LikeFailureBlock)likeFailureBlock {
    
    _likeSuccessBlock  = likeSuccessBlock;
    _likeFailureBlock  = likeFailureBlock;
    
}

- (void)setupRACComand {
    
    @weakify(self);
    _fecthTieZiEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            RequestEntity *requestEntity = (RequestEntity *)input;
            
            NSDictionary *parameter = nil;
            
            if (requestEntity.filter == 0) {
                
                if (requestEntity.subject_id != 0) {
                    
                    if (requestEntity.topic_id != 0) {
                        
                        parameter = @{@"start_id":@(requestEntity.start_id),
                                      @"topic_id":@(requestEntity.topic_id)};
                        
                    }else {
                        
                        parameter = @{@"start_id":@(requestEntity.start_id),
                                      @"subject_id":@(requestEntity.subject_id)};
                        
                    }
                    
                    
                }else {
                    
                        parameter = @{@"start_id":@(requestEntity.start_id),
                                        @"user_id":@(requestEntity.user_id)};
                }
            }
            else
            {
                parameter = @{@"filter":@(requestEntity.filter),
                               @"start_id":@(requestEntity.start_id),
                               @"user_id":@(requestEntity.user_id)};
            }
            
            
            [self requestTieZiWithUrl:requestEntity.URLString
                            parameter:parameter
                              success:^(NSArray *tieZi) {
                                  
                                  [subscriber sendNext:tieZi];
                                  [subscriber sendCompleted];
                                  
                              } error:^(id error) {
                                  [subscriber sendError:error];
                              }];
            
            return nil;
        }];
    }];
    
}

- (NSString *)idForRowByModel:(TieZi *)model {
    
    //不能用model.imageUrlArr.count 返回的是<nil>,系统默认为1😭
    if (model.imageURLArr.count == 0) {
        return @"noImageCell";
    }else if (model.imageURLArr.count == 1) {
        return @"oneImageCell";
    }else if (model.imageURLArr.count == 2) {
        return @"twoImageCell";
    }else if (model.imageURLArr.count == 3) {
        return @"threeImageCell";
    }else if (model.imageURLArr.count == 4) {
        return @"fourImageCell";
    }else if (model.imageURLArr.count <= 6) {
        return @"sixImageCell";
    }else if (model.imageURLArr.count <= 9) {
        return @"nineImageCell";
    }else if (model.imageURLArr.count > 9) {
        return @"moreNineImageCell";
    }
    
    return @"noImageCell";
}

- (void)setupModelOfCell:(YWGalleryBaseCell *)cell model:(TieZi *)model {
    
    if (model.topic_id != 0) {
        
        cell.titleView.title.topic_id   = model.topic_id;
        cell.titleView.title.label.text = model.topic_title;
        
    }
    else
    {
        cell.titleView.title.topic_id   = 0;
        cell.titleView.title.label.text = @"新鲜事";
    }
    
    cell.contentText.text                            = model.content;
    
    [cell.contentText replaceLinksWithPin];

    cell.bottemView.nickname.text                    = model.user_name;
    cell.bottemView.favourLabel.text                 = model.like_cnt;
    cell.bottemView.messageLabel.text                = model.reply_cnt;
    NSString *dataString                             = [NSString stringWithFormat:@"%d",model.create_time];
    cell.bottemView.time.text                        = [NSDate getDateString:dataString];
    cell.bottemView.favour.post_id                   = model.tieZi_id;
    
    cell.bottemView.user_id                          = model.user_id;
    
    //如果非用户本人，不显示删除选项
    Customer *customer              = [User findCustomer];
    if (model.user_id != [customer.userId intValue]) {
        cell.bottemView.more.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",nil];
    }else {
        cell.bottemView.more.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",@"删除",nil];
    }
    
    //获取正确的头像url
    model.user_face_img = [NSString selectCorrectUrlWithAppendUrl:model.user_face_img];
    
    [cell.bottemView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.user_face_img]
                                     placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    //判断是否有点赞记录
    if (model.user_post_like == 1) {
        [cell.bottemView.favour setBackgroundImage:[UIImage imageNamed:@"heart_red"]
                                          forState:UIControlStateNormal];
        cell.bottemView.favour.isSpring = YES;
    }else {
        [cell.bottemView.favour setBackgroundImage:[UIImage imageNamed:@"heart_gray"]
                                          forState:UIControlStateNormal];
        cell.bottemView.favour.isSpring = NO;
    }
    
    cell.middleView.imagesItem.URLArr = model.imageURLArr;
    
    
    if (model.imageURLArr.count > 9) {
        
        cell.middleView.imageCnt = model.imageURLArr.count;
    }
    
    [model.imageURLArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * stop) {
        
        UIImageView *imageView = [cell viewWithTag:idx+1];
        
        [self showImageView:imageView WithURL:obj cutByCount:(int)model.imageURLArr.count];
        
    }];

}

- (void)requestTieZiWithUrl:(NSString *)url
                  parameter:(id)parameter
                    success:(void (^)(NSArray *))success
                      error:(void (^)(id error))failure {

    [YWRequestTool YWRequestCachedPOSTWithURL:url
                                    parameter:parameter
                                 successBlock:^(id content) {
        
                               TieZiResult *tieZiResult = [TieZiResult mj_objectWithKeyValues:content];
                               
                               NSArray *tieZiArr        = [TieZi mj_objectArrayWithKeyValuesArray:tieZiResult.info];
                               
                               //需要将返回的url字符串，转化
                               //为imageUrl数组
                               [self changeImageUrlModelFor:tieZiArr];
                               
                               success(tieZiArr);

                               
    } errorBlock:^(id error) {
        
        NSLog(@"error:%@",error);
        failure(error);
    }];
    
}

- (void)deleteTieZiWithRequest:(RequestEntity *)request {
    
    [YWRequestTool YWRequestPOSTWithRequest:request
                               successBlock:^(id content) {
        
                                   StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                                   self.deleteSuccessBlock(entity);
                                   
    } errorBlock:^(id error) {
        self.deleteFailureBlock(error);
    }];

}

- (void)requestForLikeTieZiWithRequest:(RequestEntity *)request {
    
    [YWRequestTool YWRequestPOSTWithURL:request.URLString
                              parameter:request.parameter
                           successBlock:^(id content) {
                               
                               StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                               //本地存储点赞记录
                               
                               if ([request.parameter[@"value"] integerValue] == 1) {
                                   
                                   [self saveLikeCookieWithPostId:request.parameter[@"post_id"]];
                               }
                               else {
                                   [self deleteLikeCookieWithPostId:request.parameter[@"post_id"]];
                               }

                   
                               self.likeSuccessBlock(entity);

                           } errorBlock:^(id error) {
                               self.likeFailureBlock(error);
                           }];
    
}


- (void)requestDetailWithUrl:(NSString *)url
                  parameter:(NSDictionary *)parameter
                     success:(SuccessBlock)success
                     failure:(ErrorBlock)error {
    

    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:parameter
                           successBlock:^(id content) {
                               
                               TieZi *TieZiDetail         = [TieZi mj_objectWithKeyValues:content[@"info"]];
                               
                               //图片实体
                               TieZiDetail.imageURLArr = [NSString separateImageViewURLString:TieZiDetail.img];
                               
                               success(TieZiDetail);
        
                               
                               
    } errorBlock:^(id error) {
        
    }];

}


- (void)changeImageUrlModelFor:(NSArray *)tieZiArr {
    
    for (TieZi *tie in tieZiArr) {
        tie.imageURLArr       = [NSString separateImageViewURLString:tie.img];
        tie.imageUrlEntityArr = [NSString separateImageViewURLStringToModel:tie.img];
    }
    
}

- (void)showImageView:(UIImageView *)imageView WithURL:(NSString *)url cutByCount:(int)count {
    
    int imageWidth;
    
    //这里算出的宽度值要乘以2变成像素值
    if (count == 1) {
        imageWidth = (SCREEN_WIDTH - 10*2 - 5 *2)*2;
    }
    else if (count == 2 || count == 4) {
        imageWidth = (SCREEN_WIDTH - 10*2 - 5 *2 - 5 * 1)/2*2;
    }
    else if(count > 2) {
        imageWidth = (SCREEN_WIDTH - 10*2 - 5 *2 - 5 * 2)/3*2;
    }
    
    
    NSString *correctURL   = [NSString selectCorrectUrlWithAppendUrl:url];
    //图片模式，这里请求的是正方形图片
    NSString *imageMode    = [NSString stringWithFormat:QINIU_BLUR_IMAGE_MODEL,imageWidth,imageWidth];
    NSString *fullurl      = [correctURL stringByAppendingString:imageMode];
    NSURL *imageUrl        = [NSURL URLWithString:fullurl];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"ying"]];
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


@end



