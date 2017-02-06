//
//  ChatController.h
//  TEvaluatingSystem
//
//  Created by apple on 2017/2/3.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ChatController : RCConversationViewController

- (id)initWithConversationType:(RCConversationType)conversationType
                      customer:(Customer *)customer;


@end
