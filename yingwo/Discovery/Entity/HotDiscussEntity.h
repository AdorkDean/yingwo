//
//  HotDiscussEntity.h
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TieZi.h"

@interface HotDiscussEntity : TieZi

@property (nonatomic, assign) int       count;
@property (nonatomic, assign) int       topicId;
@property (nonatomic, copy) NSString    *imageURL;
@property (nonatomic, copy) NSString    *time;
@property (nonatomic, copy) NSString    *body;
@property (nonatomic, copy) NSArray     *listURL;
@property (nonatomic, copy) NSString    *replyCount;

@end

