//
//  DetailViewModelHepler.h
//  yingwo
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewModelHepler : NSMutableArray


@property (nonatomic,copy) void (^singleSuccessBlock)(NSArray *);
@property (nonatomic,copy) void (^singleFailureBlock)(NSString *);

//单例
+ (instancetype)shareInstance;


@end
