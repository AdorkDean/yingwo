//
//  NotificationTools.h
//  yingwo
//
//  Created by apple on 2017/2/12.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const HomeNotification;
extern NSString * const CommentNotification;
extern NSString * const LikeNotification;
extern NSString * const ChatNotification;

@interface NotificationTools : NSObject

+ (void)postNotitficationForCommentWithBadgeValue:(int)value;

+ (void)postNotitficationForLikeWithBadgeValue:(int)value;

+ (void)postNotitficationForChatWithBadgeValue:(int)value;

+ (void)addObserverFor:(id)controller withAction:(SEL)selector WithName:(NSString *)name;

@end
