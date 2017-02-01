//
//  ReplyViewModel.h
//  yingwo
//
//  Created by apple on 2017/2/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "DetailViewModel.h"
#import "YWReplyCell.h"

@interface ReplyViewModel : DetailViewModel

@property (nonatomic, strong) RACCommand *fetchEntityCommand;

- (void)setupModelOfCell:(YWReplyCell *)cell
                   model:(TieZiReply *)model;

@end
