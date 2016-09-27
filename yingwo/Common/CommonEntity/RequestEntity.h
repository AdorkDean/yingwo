//
//  RequestEntity.h
//  yingwo
//
//  Created by apple on 16/9/4.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestEntity : NSObject

//请求网址
@property (nonatomic, copy  ) NSString     *requestUrl;

//请求所需参数
@property (nonatomic, strong) NSDictionary *paramaters;

//话题的id
@property (nonatomic, assign) int          topic_id;

//回贴偏移量
@property (nonatomic, assign) int          page;

//下拉刷新需要的偏移量
@property (nonatomic, assign) int          start_id;


@end
