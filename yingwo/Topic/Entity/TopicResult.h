//
//  TopicResult.h
//  yingwo
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicResult : NSObject

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, assign) int          status;
@property (nonatomic, copy  ) NSString     *url;

@end
