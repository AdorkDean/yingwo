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

@interface MessageViewModel : BaseViewModel

@property (nonatomic, strong)RACCommand *fecthTieZiEntityCommand;

- (void)setupModelOfCell:(YWMessageCell *)cell model:(MessageEntity *)model;

- (NSString *)idForRowByModel:(MessageEntity *)model;

/**
 *  带图片的cell
 *
 *  @param cell  YWImageMessageCell
 *  @param model MessageEntity
 */
- (void)setupModelOfImageCell:(YWImageMessageCell *)cell model:(MessageEntity *)model;

/**
 *  不带图片的cell
 *
 *  @param cell  YWImageMessageCell
 *  @param model MessageEntity
 */

- (void)setupModelOfNoImageCell:(YWMessageCell *)cell model:(MessageEntity *)model;

/**
 *  获取评论和跟贴或者点赞
 *
 *  @param url        /Post/my_reply_and_comment_list
 *  @param paramaters start_id
 *  @param success    返回含有MessageEntity的数组
 *  @param failure    获取失败
 */
- (void)requestMessageWithRequest:(RequestEntity *)request
                          success:(SuccessBlock)success
                            error:(ErrorBlock)failure;

@end
