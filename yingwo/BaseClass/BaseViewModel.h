//
//  BaseViewModel.h
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestEntity.h"

typedef void(^SuccessBlock)(id success);
typedef void(^ErrorBlock)(id error);

@interface BaseViewModel : NSObject

@property (nonatomic, strong) SuccessBlock  successBlock;
@property (nonatomic, strong) ErrorBlock    errorBlock;
@property (nonatomic, strong) RequestEntity *request;

- (void)setSuccessBlock:(SuccessBlock)returnBlock
             errorBlock:(ErrorBlock)errorBlock;


@end
