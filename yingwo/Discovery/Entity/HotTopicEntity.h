//
//  HotTopicEntity.h
//  yingwo
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TopicEntity.h"

@interface HotTopicEntity : TopicEntity

//热点
@property (nonatomic, copy) NSString *hot;

//排序
@property (nonatomic, copy) NSString *sort;

//话题图片
@property (nonatomic, copy) NSString *big_img;

@end
