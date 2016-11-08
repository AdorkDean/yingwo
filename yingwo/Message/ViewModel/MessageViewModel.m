//
//  MessageViewModel.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessageViewModel.h"

@implementation MessageViewModel

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
            
            NSDictionary *paramaters = @{@"start_id":@(requestEntity.start_id)};
            
            [self requestMessageWithUrl:requestEntity.requestUrl
                             paramaters:paramaters
                                success:^(NSArray *messages) {
                
                                    [subscriber sendNext:messages];
                                    [subscriber sendCompleted];
                                            
            } error:^(NSURLSessionDataTask *task, NSError *error) {
                
                [subscriber sendError:error];

            }];
            
            return nil;
        }];
    }];
    
}


- (NSString *)idForRowByModel:(MessageEntity *)model {
    
    //不能用model.imageUrlArr.count 返回的是<nil>,系统默认为1😭
    if (model.img.length == 0) {
        return @"noImage";
    }else {
        return @"hasImage";
    }
}

- (void)setupModelOfCell:(YWMessageCell *)cell model:(MessageEntity *)model {
    
    cell.topView.nickname.text = model.follow_user_name;
    NSString *dataString       = [NSString stringWithFormat:@"%d",model.create_time];
    cell.topView.time.text     = [NSDate getDateString:dataString];
    [cell.topView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.follow_user_face_img]
                                  placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    //回复的内容
    if (model.follow_img.length != 0) {
        cell.replyContent.text = [model.follow_content stringByAppendingString:@"跟帖：[图片内容]"];
    }
    else
    {
        cell.replyContent.text     = model.follow_content;
        
        if ([model.source_type isEqualToString:@"POST"]) {
            cell.replyContent.text = [NSString stringWithFormat:@"跟贴：%@", cell.replyContent.text];
        }else{
            cell.replyContent.text = [NSString stringWithFormat:@"回复：%@", cell.replyContent.text];
        }
    }
    

    if ([cell isMemberOfClass:[YWImageMessageCell class]]) {
        
        [self setupModelOfImageCell:(YWImageMessageCell *)cell model:model];
    }
    else
    {
        [self setupModelOfNoImageCell:cell model:model];
    }
    
}

- (void)setupModelOfImageCell:(YWImageMessageCell *)cell model:(MessageEntity *)model {
    
    cell.imageBottomView.username.text = [model.user_name stringByAppendingString:@":"];
    //原帖内容
    if (model.content.length == 0) {
        cell.imageBottomView.content.text = @"发布了一条帖子";
    }
    else
    {
        cell.imageBottomView.content.text = model.content;
    }

    [cell.imageBottomView.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.img]
                                          placeholderImage:[UIImage imageNamed:@"yingwo"]];
    

    
}

- (void)setupModelOfNoImageCell:(YWMessageCell *)cell model:(MessageEntity *)model {
    
    cell.bottomView.username.text = [model.user_name stringByAppendingString:@":"];
    //原帖内容
    if (model.content.length == 0) {
        cell.bottomView.content.text = @"发布了一条帖子";
    }
    else
    {
        cell.bottomView.content.text = model.content;
    }
    
    NSString *content                      = [NSString stringWithFormat:@"%@占%@",model.user_name,model.content];
    
    cell.bottomView.content.attributedText = [NSMutableAttributedString
                                              changeCommentContentWithString:content
                                              WithTextIndext:model.user_name.length+1];
    
}


- (void)requestMessageWithUrl:(NSString *)url
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
              
              
              StatusEntity *result = [StatusEntity mj_objectWithKeyValues:content];
              
              NSArray *messageArr    = [MessageEntity mj_objectArrayWithKeyValuesArray:result.info];
              
              NSLog(@"messageArr:%@",result.info);
              
              [self changeImageUrlModelFor:messageArr];
              
              success(messageArr);
              

              //  NSLog(@"content:%@",content);
              //  NSLog(@"tieZiArr:%@",tieZiResult.info);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"error:%@",error);
              failure(task,error);
              
          }];
    
}

- (void)changeImageUrlModelFor:(NSArray *)messageArr {
    
    for (MessageEntity *message in messageArr) {
        message.imageUrlArrEntity = [NSString separateImageViewURLString:message.img];
        
    }
    
}


@end
