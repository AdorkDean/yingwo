//
//  BaseViewModel.m
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)setSuccessBlock:(SuccessBlock)successBlock
             errorBlock:(ErrorBlock)errorBlock {
    
    _successBlock = successBlock;
    _errorBlock   = errorBlock;
    
}

- (RequestEntity *)request {
    if (_request == nil) {
        _request = [[RequestEntity alloc] init];
    }
    return _request;
}

@end
