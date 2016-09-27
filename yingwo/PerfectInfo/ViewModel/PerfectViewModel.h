//
//  PerfectViewModel.h
//  yingwo
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "College.h"

@interface PerfectViewModel : NSObject
/**
 *  请求学校
 *
 *  @param url     获取学校的url
 *  @param success
 *  @param failure
 */
- (void)requestForCollegeWithUrl:(NSString *)url
                         success:(void (^)(College *colleges))success
                         failure:(void (^)(NSString *error))failure;


/**
 *  获取学院
 *
 *  @param url        学院url
 *  @param paramaters 所对应的学校的school_id
 *  @param success
 *  @param failure
 */
- (void)requestForAcademyWithUrl:(NSString *)url
                      paramaters:(NSDictionary* )paramaters
                         success:(void (^)(College *colleges))success
                         failure:(void (^)(NSString *error))failure;

/**
 *  完善个人信息
 *
 *  @param url
 *  @param paramaters
 *  @param success
 *  @param failure    
 */
- (void)requestForFinishUserBaseInfoWithUrl:(NSString *)url
                                 paramaters:(NSDictionary *)paramaters
                                    success:(void (^)(StatusEntity *info))success
                                    failure:(void (^)(NSString *error))failure;
@end
