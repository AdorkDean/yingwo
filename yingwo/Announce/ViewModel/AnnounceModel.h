//
//  AnnounceModel.h
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnounceModel : NSObject

- (void)postFreshThingWithUrl:(NSString *)url
                   paramaters:(id)paramaters
                      success:(void (^)(NSString * result))success
                      failure:(void (^)(NSError *error))failure;

@end
