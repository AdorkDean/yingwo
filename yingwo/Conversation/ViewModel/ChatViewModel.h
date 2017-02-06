//
//  ChatViewModel.h
//  TEvaluatingSystem
//
//  Created by apple on 2017/2/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewModel.h"

typedef void(^TokenSuccessBlock)(id tokenSuccessBlock);
typedef void(^TokenFailureBlock)(id tokenFailureBlock);

@interface ChatViewModel : BaseViewModel

@property (nonatomic, strong) TokenSuccessBlock tokenSuccessBlock;
@property (nonatomic, strong) TokenFailureBlock tokenFailureBlock;

- (void)setTokenSuccessBlock:(TokenSuccessBlock)tokenSuccessBlock
           tokenFailureBlock:(TokenFailureBlock)tokenFailureBlock;

@end
