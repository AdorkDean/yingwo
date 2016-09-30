//
//  TieZiResult.h
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TieZi.h"
/**
 *  网络获取的数据，先转化成 TieZiResult 的模型类，再将 info 数组转换成 TiZi 模型数组
 */
@interface TieZiResult : NSObject

@property (nonatomic, strong) NSArray  *info;
@property (nonatomic, assign) int      status;
@property (nonatomic, copy  ) NSString *url;


@end
