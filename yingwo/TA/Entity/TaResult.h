//
//  TaResult.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaResult : NSObject

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, assign) int          status;
@property (nonatomic, copy  ) NSString     *url;

@end
