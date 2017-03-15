//
//  SubjectPostController.h
//  yingwo
//
//  Created by 王世杰 on 2017/3/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

typedef enum : NSInteger {
    FieldOne = 1,
    FieldTwo = 2,
    FieldThree = 3,
} FieldType;

#import "GalleryController.h"
#import "SubjectEntity.h"

@interface SubjectPostController : GalleryController

@property (nonatomic, strong) YWTabBar      *tabBar;
@property (nonatomic, assign) int           subject_id;
@property (nonatomic, strong) SubjectEntity *subjectEntity;

@end
