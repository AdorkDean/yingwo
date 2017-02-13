//
//  MyCommentViewModel.m
//  yingwo
//
//  Created by apple on 2017/2/9.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "MyCommentViewModel.h"

#import "MessageEntity.h"

@implementation MyCommentViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupRACComand];
        
    }
    return self;
}

- (void)setDeleteReplySuccessBlock:(DeleteReplySuccessBlock)deleteReplySuccessBlock
                           failure:(DeleteReplyFailureBlock)failure {
    _deleteReplySuccessBlock = deleteReplySuccessBlock;
    _deleteReplyFailureBlock = failure;
}

- (void)setDeleteCommentSuccessBlock:(DeleteCommentSuccessBlock)deleteCommentSuccessBlock
                             failure:(DeleteCommentFailureBlock)failure {
    _deleteCommentSuccessBlock = deleteCommentSuccessBlock;
    _deleteCommentFailureBlock = failure;
}



- (void)setupRACComand {
    
    @weakify(self);
    _fecthCommentEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            RequestEntity *requestEntity = (RequestEntity *)input;
            
            [self requestMessageWithRequest:requestEntity
                                    success:^(id messages) {
                                        
                                        [subscriber sendNext:messages];
                                        [subscriber sendCompleted];
                                        
                                    } error:^(id error) {
                                        
                                        [subscriber sendError:error];
                                        
                                    }];
            
            return nil;
        }];
    }];
    
}


- (void)requestMessageWithRequest:(RequestEntity *)request
                          success:(SuccessBlock)success
                            error:(ErrorBlock)failure {
    
    [YWRequestTool YWRequestCachedPOSTWithRequest:request
                                     successBlock:^(id content) {
                                         
                                         StatusEntity *result = [StatusEntity mj_objectWithKeyValues:content];
                                         
                                         NSArray *messageArr    = [MessageEntity mj_objectArrayWithKeyValuesArray:result.info];
                                         
                                         //  NSLog(@"messageArr:%@",result.info);
                                         
                                         [self changeImageUrlModelFor:messageArr];
                                         
                                         success(messageArr);
                                         
                                     } errorBlock:^(id error) {
                                         failure(error);
                                     }];
}

- (void)deleteReplyWithRequest:(RequestEntity *)request {
    
    [YWRequestTool YWRequestPOSTWithRequest:request
                               successBlock:^(id content) {
                                   
                                   StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                                   self.deleteReplySuccessBlock(entity);
 
    } errorBlock:^(id error) {
        self.deleteReplyFailureBlock(error);
    }];

}

- (void)deleteCommentWithRequest:(RequestEntity *)request {
    
    [YWRequestTool YWRequestPOSTWithRequest:request
                               successBlock:^(id content) {
                                   
                                   StatusEntity *entity = [StatusEntity mj_objectWithKeyValues:content];
                                   self.deleteCommentSuccessBlock(entity);
                                   
                               } errorBlock:^(id error) {
                                   self.deleteCommentFailureBlock(error);
                               }];
}



#pragma mark private
- (void)changeImageUrlModelFor:(NSArray *)messageArr {
    
    for (MessageEntity *message in messageArr) {
        message.imageUrlEntityArr = [NSString separateImageViewURLStringToModel:message.img];
        message.imageURLArr = [NSString separateImageViewURLStringToModel:message.img];
    }
    
}


@end
