//
//  CollegeViewModel.h
//  Test
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "College.h"

@interface CollegeModel : NSObject

/**
 *  保存学校数据
 *
 *  @param collegeData
 */
- (void)saveCollegeDataInUserDefault:(NSArray *)collegeData;
/**
 *  取得学校
 *
 *  @return 所有学校的数组
 */
- (NSArray *)getCollegeDataFromUserDefault;

/**
 *  保存学校所在的分组（即中文首字母）
 *
 *  @return 返回首字母数组
 */
- (NSMutableArray *)getCollegeGroupNamesFromUserDefault;

/**
 *  删除所有的学校
 */
- (void)deleteAllCollegeData;

@end
