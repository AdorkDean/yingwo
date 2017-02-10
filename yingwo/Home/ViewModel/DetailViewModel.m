
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

- (void)setLikeSuccessBlock:(ReplyLikeTieZiBlock)likeSuccessBlock
           likeFailureBlock:(ReplyLikeFailureBlock)likeFailureBlock{
    _likeSuccessBlock = likeSuccessBlock;
    _likeFailureBlock = likeFailureBlock;
    
}

- (void)setCommentReplySuccessBlock:(CommentReplySuccessBlock)commentReplySuccessBlock
                            failure:(CommentReplyFailureBlock)commentReplyFailureBlock {
    _commentReplySuccessBlock = commentReplySuccessBlock;
    _commentReplyFailureBlock = commentReplyFailureBlock;
}


- (void)setCommentListSuccessBlock:(CommentListSuccessBlock)commentListSuccessBlock
                           failure:(CommentListFailureBlock)commentListFailureBlock {
    _commentListSuccessBlock = commentListSuccessBlock;
    _commentListFailureBlock = commentListFailureBlock;
}

- (void)setupRACComand {
    
    @weakify(self);
    _fetchDetailEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RequestEntity *requestEntity) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            
            [self requestReplyWithRequest:requestEntity
                                  success:^(NSArray *tieZi) {
                                  
                                      [subscriber sendNext:tieZi];
                                      [subscriber sendCompleted];
                                  
                              } failure:^(id error) {
                                  [subscriber sendError:error];
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

- (void)setupModelOfDetailCell:(YWDetailTableViewCell *)cell
                         model:(TieZi *)model {
    
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
    
    cell.imagesItem.URLArr = model.imageURLArr;
    
    if (model.imageUrlEntityArr.count > 0) {
        NSMutableArray *entities = [NSMutableArray arrayWithArray:model.imageUrlEntityArr];
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
    model.floor                                = (int)(indexPath.row +1);
    
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
    if ( [self isLikedTieZiWithReplyId:[NSNumber numberWithInt:model.reply_id]]) {
        [cell.bottomView.favour   setBackgroundImage:[UIImage imageNamed:@"heart_red"]
                                            forState:UIControlStateNormal];
        cell.bottomView.favour.isSpringReply = YES;
    }else {
        [cell.bottomView.favour setBackgroundImage:[UIImage imageNamed:@"heart_gray"]
                                          forState:UIControlStateNormal];
        cell.bottomView.favour.isSpringReply = NO;
    }
    
    cell.imagesItem.URLArr = model.imageURLArr;

    //加载跟帖图片
    if (model.imageUrlEntityArr.count > 0) {
        
        NSMutableArray *entities = [NSMutableArray arrayWithArray:model.imageUrlEntityArr];
        
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

<<<<<<< HEAD
- (void)requestDetailWithUrl:(NSString *)url
                  parameter:(NSDictionary *)parameter
                     success:(void (^)(TieZi *tieZi))success
                     failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:parameter
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
                 // TieZiDetail.imageUrlArrEntity = [NSString separateImageViewURLString:TieZiDetail.img];
                  
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


=======
>>>>>>> Developing
- (void)requestReplyWithRequest:(RequestEntity *)request
                        success:(void (^)(NSArray *tieZi))success
                        failure:(void (^)(id error))failure {
    
    [YWRequestTool YWRequestCachedPOSTWithRequest:request
                                     successBlock:^(id content) {
        
                                         StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
    
                                        
                                         NSMutableArray *replyList = [[NSMutableArray alloc] init];

                                         //字典转模型
                                         [self changeReplyDicArr:statusEntity.info toModelArr:replyList];
                                         //URL转模型
                                         [self changeImageUrlModelFor:replyList];
                                         
                                         success(replyList);
                                         
 
    } errorBlock:^(id error) {
        failure(error);
    }];
    
}

- (void)deleteReplyWithUrl:(NSString *)url
                parameter:(NSDictionary *)parameter
                   success:(void (^)(StatusEntity *statusEntity))success
                   failure:(void (^)(NSString *error))failure{
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:parameter
                           successBlock:^(id content) {
                               
                               StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                               success(entity);
        
    } errorBlock:^(id error) {
        
    }];
}

- (void)deleteCommentWithUrl:(NSString *)url
                  parameter:(NSDictionary *)parameter
                     success:(void (^)(StatusEntity *statusEntity))success
                     failure:(void (^)(NSString *error))failure{
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:parameter
                           successBlock:^(id content) {
                               
                               StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                               success(entity);
                               
                           } errorBlock:^(id error) {
                               
                           }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(TieZi *)model
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    NSString *share_title               = [NSString stringWithFormat:@"%@", model.topic_title];
    NSString *share_descr               = [NSString stringWithFormat:@"%@", model.content];
    NSString *share_thumbURL            = @"http://image.zhibaizhi.com/icon/share_img.png";
    
    if (model.imageUrlEntityArr > 0) {
        ImageViewEntity *entity         = [model.imageUrlEntityArr firstObject];
        share_thumbURL                  =entity.imageName;
        
    }
     
    UMShareWebpageObject *shareObject   = [UMShareWebpageObject shareObjectWithTitle:share_title
                                                                               descr:share_descr
                                                                           thumImage:share_thumbURL];
    //设置网页地址
    shareObject.webpageUrl =  [NSString stringWithFormat:@"https://share.yingwoo.com/share/post/%d",model.tieZi_id];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self completion:^(id data, NSError *error) {
                                    
                                    if (error) {
                                        UMSocialLogInfo(@"************Share fail with error %@*********",error);
                                    }else{
                                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                            UMSocialShareResponse *resp = data;
                                            //分享结果消息
                                            UMSocialLogInfo(@"response message is %@",resp.message);
                                            //第三方原始返回的数据
                                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                            
                                        }else{
                                            UMSocialLogInfo(@"response data is %@",data);
                                        }
                                    }
                                    [self alertWithError:error];
                                }];
}

//文本分享
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType withModel:(TieZi *)model
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    NSString *share_descr = model.content;
    if (model.content.length >= 45) {
        share_descr =  [model.content substringToIndex:45];
    }
    messageObject.text = [NSString stringWithFormat:@"%@···(%@的贴子,分享自@应我校园) https://share.yingwoo.com/share/post/%d #校内事，一起聊#",share_descr, model.user_name,model.tieZi_id];
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

//分享错误提示
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"贴子分享成功"];
    }
    else{
        if (error) {
            if (error.code == 2009) {
                result = [NSString stringWithFormat:@"用户取消分享"];
            }else {
                result = [NSString stringWithFormat:@"分享失败错误码: %d\n",(int)error.code];
            }
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)requestForReplyLikeTieZiWithRequest:(RequestEntity *)request {
    
    [YWRequestTool YWRequestPOSTWithURL:request.URLString
                              parameter:request.parameter
                           successBlock:^(id content) {
                               
                               StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                               //本地存储点赞记录
                               
                               if ([request.parameter[@"value"] integerValue] == 1) {
                                   
                                   [self saveLikeCookieWithReplyId:request.parameter[@"reply_id"]];
                               }
                               else {
                                   [self deleteLikeCookieWithReplyId:request.parameter[@"reply_id"]];
                               }
                               
                               self.likeSuccessBlock(entity);
                               
                           } errorBlock:^(id error) {
                               self.likeFailureBlock(error);
                           }];
    
}

- (void)postCommentWithRequest:(RequestEntity *)request {
    
    [YWRequestTool YWRequestPOSTWithRequest:request
                               successBlock:^(id content) {
                                   
                                   StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
                                   
                                   self.commentReplySuccessBlock(statusEntity);
        
    } errorBlock:^(id error) {
        self.commentReplyFailureBlock(error);
    }];
    
}

- (void)requestCommentWithRequest:(RequestEntity *)request {
    
    [YWRequestTool YWRequestPOSTWithRequest:request
                               successBlock:^(id content) {
                                   
                                   StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
                                   NSMutableArray *commentArr = [[NSMutableArray alloc] init];
                                   
                                   //回复字典转模型
                                   for (NSDictionary *comment in statusEntity.info) {
                                       TieZiComment *commentEntity = [TieZiComment mj_objectWithKeyValues:comment];
                                       [commentArr addObject:commentEntity];
                                   }
                                   
                                   self.commentListSuccessBlock(commentArr);

                               } errorBlock:^(id error) {
                                   self.commentListFailureBlock(error);
                               }];
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

- (void)changeReplyDicArr:(NSArray *)relpyList toModelArr:(NSMutableArray *)modelArr {
    
    for (NSDictionary *reply in relpyList) {
        
        TieZiReply *replyModel = [TieZiReply mj_objectWithKeyValues:reply];
        
        NSMutableArray *commentArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *comment in replyModel.commentArr) {
            
            
            TieZiComment *commentEntity = [TieZiComment mj_objectWithKeyValues:comment];
            [commentArr addObject:commentEntity];
        }
        replyModel.commentArr = commentArr;
        [modelArr addObject:replyModel];
    }
}

- (void)changeImageUrlModelFor:(NSArray *)tieZiArr {
    
    for (TieZi *tie in tieZiArr) {
        tie.imageURLArr       = [NSString separateImageViewURLString:tie.img];
        tie.imageUrlEntityArr = [NSString separateImageViewURLStringToModel:tie.img];
    }
    
}


@end
