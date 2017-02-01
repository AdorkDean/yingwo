//
//  FieldEntity.h
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubjectEntity.h"
#import "TopicEntity.h"

@interface FieldEntity : NSObject

@property (nonatomic, copy) NSString *field_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *field_description;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *top;


@end
