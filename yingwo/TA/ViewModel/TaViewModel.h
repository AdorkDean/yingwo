//
//  TaViewModel.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaEntity.h"
#import "TaResult.h"

@interface TaViewModel : NSObject


/**
 *  获取TA的详细资料
 *
 *  @param url        user/info
 *  @param paramaters 一个user_id
 *  @param success    返回TopicEntity
 *  @param failure    失败
 */
- (void)requestTaDetailInfoWithUrl:(NSString *)url
                        paramaters:(id)paramaters
                           success:(void (^)(TaEntity *ta))success
                             error:(void (^)(NSURLSessionDataTask *, NSError *))failure;


@end
