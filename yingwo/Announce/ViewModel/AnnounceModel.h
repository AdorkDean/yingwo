//
//  AnnounceModel.h
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnounceModel : NSObject

/* 这里是发布贴子包括三种类型：1.发布新鲜事，2.发布跟贴，3.发布话题
 * @prama url   post/add_new
 * @prama       paramaters post_id
 */

- (void)postTieZiWithUrl:(NSString *)url
              paramaters:(id)paramaters
                 success:(void (^)(NSString * result))success
                 failure:(void (^)(NSError *error))failure;

@end
