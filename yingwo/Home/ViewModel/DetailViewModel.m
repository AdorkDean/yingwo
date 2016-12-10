//
//  DetailViewModel.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DetailViewModel.h"

@implementation DetailViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setupRACComand];
        
    }
    return self;
}

- (TieZiViewModel *)tieZiViewModel {
    if (_tieZiViewModel == nil) {
        _tieZiViewModel = [[TieZiViewModel alloc] init];
    }
    return _tieZiViewModel;
}

- (void)setupRACComand {
    
    @weakify(self);
    _fetchDetailEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RequestEntity *requestEntity) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            
            [self requestReplyWithUrl:requestEntity.requestUrl
                           paramaters:requestEntity.paramaters
                              success:^(NSArray *tieZi) {
                                  
                                      [subscriber sendNext:tieZi];
                                      [subscriber sendCompleted];
                                                      
            } failure:^(NSString *error) {
                
            }];
            
            return nil;
        }];
    }];
}

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath model:(TieZiReply *)model{
    
    if (indexPath.row == 0 ) {
        
        return @"detailCell";
    }
    return @"replyCell";
}

- (void)setupModelOfCell:(YWDetailBaseTableViewCell *)cell
                   model:(TieZiReply *)model
               indexPath:(NSIndexPath *)indexPath{

    if ([cell isMemberOfClass:[YWDetailTableViewCell class]]) {
        [self setupModelOfDetailCell:(YWDetailTableViewCell *)cell
                               model:model];
    }
    else if ([cell isMemberOfClass:[YWDetailReplyCell class]]) {
        
        [self setupModelOfReplyCell:(YWDetailReplyCell *)cell
                              model:model
                          indexPath:indexPath];
    }
    
}

- (void)setupModelOfDetailCell:(YWDetailTableViewCell *)cell model:(TieZiReply *)model {
    
    [cell createSubview];

    //保存楼主的user_id
    self.master_id = model.user_id;
    
    if (model.topic_title.length == 0 && model.topic_id == 0) {
        cell.topView.label.label.text              = @"新鲜事";
    }
    else
    {
        cell.topView.label.label.text              = model.topic_title;
    }
    
    cell.topView.label.topic_id                = model.topic_id;
    cell.masterView.floorLabel.text            = @"第1楼";
    cell.contentLabel.text                     = model.content;
    cell.masterView.nicnameLabel.text          = model.user_name;
    NSString *dataString                       = [NSString stringWithFormat:@"%d",model.create_time];
    cell.masterView.timeLabel.text             = [NSDate getDateString:dataString];
    
    [cell.masterView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.user_face_img]
                                     placeholderImage:[UIImage imageNamed:@"touxiang"]];
    cell.masterView.headImageView.layer.cornerRadius = 20;
    
    cell.masterView.user_id                    = model.user_id;
    
    //如果非用户本人，不显示删除选项
    Customer *customer              = [User findCustomer];
    if (model.user_id != [customer.userId intValue]) {
        cell.topView.moreBtn.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",nil];
    }else {
        cell.topView.moreBtn.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",@"删除",nil];
    }
    
    if (model.imageUrlArrEntity.count > 0) {
        NSMutableArray *entities = [NSMutableArray arrayWithArray:model.imageUrlArrEntity];
        [cell addImageViewByImageArr:entities];
    }
}

- (void)setupModelOfReplyCell:(YWDetailReplyCell *)cell
                        model:(TieZiReply *)model
                    indexPath:(NSIndexPath *)indexPath{
    
    //解决cell复用带来的问题
    //移除所有的子试图，再添加
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    //子view的创建延迟到viewmodel中
    [cell createSubview];
    
    //所在楼层
  //  cell.masterView.floorLabel.text            = [NSString stringWithFormat:@"第%d楼",model.reply_id];
    cell.masterView.floorLabel.text            = [NSString stringWithFormat:@"第%d楼",(int)(indexPath.row +1)];
    //回复内容
    cell.contentLabel.text                     = model.content;
    if (model.user_name.length == 0) {
        cell.masterView.nicnameLabel.text          = @"匿名";
    }
    else
    {
        //昵称
        cell.masterView.nicnameLabel.text          = model.user_name;

    }
    //时间
    NSString *dataString                       = [NSString stringWithFormat:@"%d",model.create_time];
    cell.masterView.timeLabel.text             = [NSDate getDateString:dataString];
    
    //获取正确的头像url
    model.user_face_img = [NSString selectCorrectUrlWithAppendUrl:model.user_face_img];
    
    //头像
    [cell.masterView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.user_face_img]
                                     placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    //圆角头像
    cell.masterView.headImageView.layer.cornerRadius = 20;
    
    //user_id
    cell.masterView.user_id                          = model.user_id;
    
    cell.bottomView.favourLabel.text                 = model.like_cnt;

    //回复评论的数量
    cell.bottomView.messageLabel.text                = [NSString stringWithFormat:@"%d",model.comment_cnt];
    
    //当前回复的id，不是楼主的贴子id！！
    cell.bottomView.post_reply_id                          = model.reply_id;
    cell.bottomView.favour.reply_id                        = model.reply_id;
    
    //其他人可以删除自己的跟帖
    Customer *customer              = [User findCustomer];
    if (model.user_id != [customer.userId intValue]) {
        cell.moreBtn.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",nil];
    }else {
        cell.moreBtn.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",@"删除",nil];
    }
    //楼主删除可以所有跟帖
    if (self.master_id == [customer.userId intValue]) {
        cell.moreBtn.names = [NSMutableArray arrayWithObjects:@"复制",@"举报",@"删除",nil];
    }
    
    //判断是否有点赞过
    if ( [self.tieZiViewModel isLikedTieZiWithReplyId:[NSNumber numberWithInt:model.reply_id]]) {
        [cell.bottomView.favour   setBackgroundImage:[UIImage imageNamed:@"heart_red"]
                                            forState:UIControlStateNormal];
        cell.bottomView.favour.isSpringReply = YES;
    }else {
        [cell.bottomView.favour setBackgroundImage:[UIImage imageNamed:@"heart_gray"]
                                          forState:UIControlStateNormal];
        cell.bottomView.favour.isSpringReply = NO;
    }
    
    //加载跟帖图片
    if (model.imageUrlArrEntity.count > 0) {
        
        NSMutableArray *entities = [NSMutableArray arrayWithArray:model.imageUrlArrEntity];
        
        self.imageUrlEntity      = entities;
        
        [cell addImageViewByImageArr:entities];
    }
    
    //加载评论
    if (model.commentArr.count > 0) {
        NSMutableArray *entities = [NSMutableArray arrayWithArray:model.commentArr];
        [cell addCommentViewByCommentArr:entities withMasterId:self.master_id];
    }
    else
    {
        //如果没有任何评论隐藏cell的下划线
        cell.bottomView.bottomLine.hidden = YES;
    }
}

- (void)requestDetailWithUrl:(NSString *)url
                  paramaters:(NSDictionary *)paramaters
                     success:(void (^)(TieZi *tieZi))success
                     failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content      = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                  NSLog(@"detail:%@",content);
                  TieZi *TieZiDetail         = [TieZi mj_objectWithKeyValues:content[@"info"]];
                  
                  //图片实体
                  TieZiDetail.imageUrlArrEntity = [NSString separateImageViewURLString:TieZiDetail.img];
                  
                  success(TieZiDetail);
              }
              else
              {
                  NSLog(@"原帖获取失败");
              }
              
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"获取失败");
          }];
}

- (void)requestReplyWithUrl:(NSString *)url
                 paramaters:(NSDictionary *)paramaters
                    success:(void (^)(NSArray *tieZi))success
                    failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content      = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                  StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
                  NSLog(@"reply:%@",content);
                  //没有评论直接返回nil
                  if (statusEntity.info.count == 0) {
                      success(nil) ;
                  }
                  
                  //保存跟贴数据对象TieZiReply
                 NSMutableArray *replyArr        = [[NSMutableArray alloc] init];
                  //计数
                 __block NSUInteger currentIndex = 0;
                  
                //  NSLog(@"reply:%@",content);
                  
                  //单例实现多线程下载，这里不能用for循环实现，否则会出现数据混乱现象，即使最后排序也没用！！！
                  DetailViewModelHepler *loadHepler  = [DetailViewModelHepler shareInstance];
                  __weak typeof(loadHepler) weakself = loadHepler;

                  weakself.singleSuccessBlock = ^(NSArray *commentArr){
                      
                      TieZiReply *replyEntity       = [TieZiReply mj_objectWithKeyValues:statusEntity.info[currentIndex]];

                      replyEntity.imageUrlArrEntity = [NSString separateImageViewURLString:replyEntity.img];

                      currentIndex ++ ;

                      replyEntity.commentArr        = [commentArr mutableCopy];
                      
                      [replyArr addObject:replyEntity];
                      
                      if (currentIndex == statusEntity.info.count) {
                          success(replyArr);
                      }
                      else
                      {
                          //currentIndex已经++
                          TieZiReply *replyEntity       = [TieZiReply mj_objectWithKeyValues:statusEntity.info[currentIndex]];

                          NSDictionary *paramaters      = @{@"post_reply_id":@(replyEntity.reply_id)};

                          [self requestForCommentWithUrl:TIEZI_COMMENT_LIST_URL
                                              paramaters:paramaters
                                                 success:weakself.singleSuccessBlock
                                                 failure:weakself.singleFailureBlock];
                      }
                  };
                  
                  if (statusEntity.info.count > 0) {
                      
                      TieZiReply *replyEntity       = [TieZiReply mj_objectWithKeyValues:statusEntity.info[0]];
                      //获取图片链接
                      replyEntity.imageUrlArrEntity = [NSString separateImageViewURLString:replyEntity.img];
                      NSDictionary *paramaters      = @{@"post_reply_id":@(replyEntity.reply_id)};
                      
                      [self requestForCommentWithUrl:TIEZI_COMMENT_LIST_URL
                                          paramaters:paramaters
                                             success: weakself.singleSuccessBlock
                                             failure:weakself.singleFailureBlock];

                  }
                  
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"回贴获取失败");
          }];
}

- (void)requestForCommentWithUrl:(NSString *)url
                 paramaters:(NSDictionary *)paramaters
                    success:(void (^)(NSArray *commentArr))success
                    failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content      = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                  StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
                  NSMutableArray *commentArr = [[NSMutableArray alloc] init];
                  
                //  NSLog(@"commentList:%@",content);
                  //回复字典转模型
                  for (NSDictionary *comment in statusEntity.info) {
                      TieZiComment *commentEntity = [TieZiComment mj_objectWithKeyValues:comment];
                      [commentArr addObject:commentEntity];
                  }

               //   NSLog(@"commentArr.count:%lu",commentArr.count);
                  success(commentArr);
              }
              
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"评论获取失败");
          }];
    
}

- (void)postCommentWithUrl:(NSString *)url
                paramaters:(NSDictionary *)paramaters
                   success:(void (^)(StatusEntity *status))success
                   failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content      = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                  StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
                  
                  NSLog(@"postcomment:%@",content);
                  
                  success(statusEntity);
              }
              
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"评论失败");
          }];
    
}

- (void)deleteReplyWithUrl:(NSString *)url
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

- (void)deleteCommentWithUrl:(NSString *)url
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


//- (void)downloadCompletedImageViewByUrls:(NSArray *)imageEntities
//                                progress:(void (^)(CGFloat))progress
//                                 success:(void (^)(NSMutableArray *imageArr))imageArr
//                                 failure:(void (^)(NSString *error))failure{
//    
//    
//    ImageViewEntity *imageEntity = [imageEntities objectAtIndex:0];
//    NSMutableArray *imageUrls    = [ImageViewEntity getImageUrlsFromImageEntities:imageEntities];
//    Boolean hasExsitImages       = [YWSandBoxTool isExistImageByName:imageEntity.imageName];
//    
//    //先从沙盒中找图片
//    if (hasExsitImages) {
//        imageArr([YWSandBoxTool getImagesFromCacheByUrlsArr:imageUrls]);
//        progress(1);
//    }
//    else
//    {
//        [YWAvatarBrowser downloadImagesWithUrls:imageUrls
//                                       progress:^(CGFloat progressNum) {
//                                           //这个不能写
//                                           progress(progressNum);
//                                       }
//                                        success:^(NSMutableArray *success) {
//                                            
//                                            imageArr(success);
//                                            
//                                        } failure:^(NSString *error) {
//                                            failure(error);
//                                            NSLog(@"failure:%@",error);
//                                        }];
//    }
//    
//}


//- (void)requestReplyWithUrl:(NSString *)url
//                 paramaters:(NSDictionary *)paramaters
//                    success:(void (^)(NSArray *tieZi))success
//                    failure:(void (^)(NSString *error))failure {
//
//    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
//    YWHTTPManager *manager = [YWHTTPManager manager];
//
//    [manager POST:fullUrl
//       parameters:paramaters
//         progress:nil
//          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//
//              if (httpResponse.statusCode == SUCCESS_STATUS) {
//
//                NSDictionary *content      = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                                             options:NSJSONReadingMutableContainers
//                                                                               error:nil];
//                StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
//
//                  //没有评论直接返回nil
//                  if (statusEntity.info.count == 0) {
//                      success(nil) ;
//                  }
//
//                  NSMutableArray *replyArr = [[NSMutableArray alloc] init];
//
//                  NSLog(@"reply:%@",content);
//
//                  //回复字典转模型
//                  for (NSDictionary *reply in statusEntity.info) {
//
//                      TieZiReply *replyEntity       = [TieZiReply mj_objectWithKeyValues:reply];
//                      //获取图片链接
//                      replyEntity.imageUrlArrEntity = [NSString separateImageViewURLString:replyEntity.img];
//
//                      NSDictionary *paramaters      = @{@"post_reply_id":@(replyEntity.reply_id)};
//
//                      [self requestForCommentWithUrl:TIEZI_COMMENT_LIST_URL
//                                          paramaters:paramaters
//                                             success:^(NSArray *commentArr) {
//
//
//                                                 replyEntity.commentArr = [commentArr mutableCopy];
//
//                                                 //这里使用的是一步加载，因此replyArr add的顺序是可能改变的
//                                                 //需要按照reply_id进行排序
//
//                                                 [replyArr addObject:replyEntity];
//
//                                                 //这里获取完所有的评论才回调数据！！
//                                                 if (replyArr.count == statusEntity.info.count && replyArr.count != 0) {
//                                                     //升序排序
//                                                     [replyArr bubSortWithArrayByAsc];
//
//                                                     success(replyArr);
//                                                 }
//
//                      } failure:^(NSString *error) {
//
//                      }];
//
//                  }
//
//
//
//              }
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"回帖获取失败");
//    }];
//}



@end
