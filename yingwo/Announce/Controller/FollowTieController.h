//
//  FollowTieController.h
//  yingwo
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "AnnounceController.h"

typedef void(^ReplyTieZiBlock)(NSDictionary *paramters);

@interface FollowTieController : AnnounceController

//回调穿参，返回刚发布的贴子内容
@property (nonatomic, copy)  ReplyTieZiBlock replyTieZiBlock;

@end
