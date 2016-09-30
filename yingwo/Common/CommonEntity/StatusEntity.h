//
//  StatusEntity.h
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusEntity : NSObject

//返回信息
@property (nonatomic, strong) NSArray  *info;

//返回状态
@property (nonatomic, assign) int      status;

//暂无实义
@property (nonatomic, copy  ) NSString *url;

//错误返回信息
@property (nonatomic, assign) int      error_code;


@end
