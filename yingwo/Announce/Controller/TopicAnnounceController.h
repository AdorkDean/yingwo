//
//  TopicAnnounceController.h
//  yingwo
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "AnnounceController.h"

@interface TopicAnnounceController : AnnounceController

//话题的id
@property (nonatomic, assign) int                        topic_id;
@property (nonatomic, copy  ) NSString                   *topic_title;


@end
