//
//  MessageViewModel.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageEntity.h"
#import "YWMessageCell.h"
#import "YWImageMessageCell.h"

@interface MessageViewModel : NSObject

@property (nonatomic, strong)RACCommand *fecthTieZiEntityCommand;

- (void)setupModelOfCell:(YWMessageCell *)cell model:(MessageEntity *)model;

- (NSString *)idForRowByModel:(MessageEntity *)model;

/**
 *  获取评论和跟贴或者点赞
 *
 *  @param url        /Post/my_reply_and_comment_list
 *  @param paramaters start_id
 *  @param success    返回含有MessageEntity的数组
 *  @param failure    获取失败
 */
- (void)requestMessageWithUrl:(NSString *)url
                   paramaters:(id)paramaters
                      success:(void (^)(NSArray *))success
                        error:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
