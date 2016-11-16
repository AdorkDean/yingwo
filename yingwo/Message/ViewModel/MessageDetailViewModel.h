//
//  MessageDetailViewModel.h
//  yingwo
//
//  Created by apple on 2016/11/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DetailViewModel.h"

@interface MessageDetailViewModel : DetailViewModel

/**
 *  请求原贴
 *
 *  @param url        Post/detail
 *  @param paramaters post_id
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)requestDetailWithUrl:(NSString *)url
                  paramaters:(NSDictionary *)paramaters
                     success:(void (^)(TieZi *tieZi))success
                     failure:(void (^)(NSString *error))failure;

@end
