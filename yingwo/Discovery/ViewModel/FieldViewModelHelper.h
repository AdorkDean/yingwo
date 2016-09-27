//
//  FieldViewModelHelper.h
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

//单例
@interface FieldViewModelHelper : NSObject

@property (nonatomic,copy) void (^singleSuccessBlock)(NSArray *);
@property (nonatomic,copy) void (^singleFailureBlock)(NSString *);

//单例
+ (instancetype)shareInstance;

@end
