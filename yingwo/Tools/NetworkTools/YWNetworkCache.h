//
//  YWNetworkCache.h
//  yingwo
//
//  Created by apple on 2017/1/28.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CacheSccuss)(id cacheSuccess);
typedef void(^CacheFailure)(id cacheFailure);

@interface YWNetworkCache : NSObject

@end
