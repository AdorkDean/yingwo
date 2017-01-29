//
//  YWNetworkCache.m
//  yingwo
//
//  Created by apple on 2017/1/28.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWNetworkCache.h"

static NSURLCache *sharedCache = nil;

@implementation YWNetworkCache

+ (NSURLCache *)sharedCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *diskPath = [NSString stringWithFormat:@"RequestCacheCenter"];
        // 10M内存，100M磁盘
        sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * 10
                                                    diskCapacity:1024 * 1024 * 100
                                                        diskPath:diskPath];
        
    });
    return sharedCache;
}

+(void)getCacheWithUrl:(NSString *)url
                option:(NSURLRequestCachePolicy)option
            parameters:(NSDictionary *)parameters
               success:(CacheSccuss)success
               failure:(CacheFailure)failure {
    
    NSError *error = nil;
    NSString *URLString = [[NSURL URLWithString:url relativeToURL:nil] absoluteString];
    
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:URLString
                                                                     parameters:parameters
                                                                          error:&error];
    NSCachedURLResponse *cachedResponse = [[self sharedCache] cachedResponseForRequest:request];
    
    if (cachedResponse) {
        id content = [NSJSONSerialization JSONObjectWithData:cachedResponse.data
                                                     options:NSJSONReadingMutableLeaves
                                                       error:nil];
        DLog(@"缓存后的数据  %@",content);
    }
}

@end
