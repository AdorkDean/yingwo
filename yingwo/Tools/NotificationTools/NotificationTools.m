//
//  NotificationTools.m
//  yingwo
//
//  Created by apple on 2017/2/12.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "NotificationTools.h"

NSString * const HomeNotification    = @"HomeNotification";
NSString * const CommentNotification = @"CommentNotification";
NSString * const LikeNotification    = @"LikeNotification";
NSString * const ChatNotification    = @"ChatNotification";

@implementation NotificationTools

+ (void)postNotitficationForCommentWithBadgeValue:(int)value {
    
    [NotificationTools postNotificationForModel:CommentNotification withValue:value];
}

+ (void)postNotitficationForLikeWithBadgeValue:(int)value  {
    
    [NotificationTools postNotificationForModel:LikeNotification withValue:value];

}

+ (void)postNotitficationForChatWithBadgeValue:(int)value  {
    
    [NotificationTools postNotificationForModel:ChatNotification withValue:value];

}

+ (void)addObserverFor:(id)controller withAction:(SEL)selector WithName:(NSString *)name {
    
    [[NSNotificationCenter defaultCenter] addObserver:controller
                                             selector:selector
                                                 name:name
                                               object:nil];
}

+ (void)postNotificationForModel:(NSString *)notificationModel withValue:(int)value {
    
    NSDictionary *object = @{@"value":@(value)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationModel object:object];

}

@end
