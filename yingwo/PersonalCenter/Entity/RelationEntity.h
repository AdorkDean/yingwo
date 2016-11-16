//
//  RelationEntity.h
//  yingwo
//
//  Created by 王世杰 on 2016/11/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationEntity : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *liked_user_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_signature;
@property (nonatomic, copy) NSString *user_face_img;



@end
