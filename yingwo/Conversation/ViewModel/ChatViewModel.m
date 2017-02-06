//
//  ChatViewModel.m
//  TEvaluatingSystem
//
//  Created by apple on 2017/2/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "ChatViewModel.h"
#import "TokenEntity.h"
@implementation ChatViewModel

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self requestForRongCloudToken];
    }
    return self;
}

- (void)setTokenSuccessBlock:(TokenSuccessBlock)tokenSuccessBlock
           tokenFailureBlock:(TokenFailureBlock)tokenFailureBlock {
    _tokenSuccessBlock = tokenSuccessBlock;
    _tokenFailureBlock = tokenFailureBlock;
}

- (void)requestForRongCloudToken {
    
    Customer *customer        = [User findCustomer];
    
    NSDictionary *parameter = @{@"userId":customer.userId,
                                @"name":customer.name,
                                @"portraitUri":customer.face_img};
    
    [RongCloudTools requestForRongCloudTokenWithURL:RongCloud_Token_URL
                                          parameter:parameter
                                rongCloudTokenValue:^(id rongCloudTokenValue) {
        
                                    TokenEntity *token = [TokenEntity mj_objectWithKeyValues:rongCloudTokenValue];
                                    [self requestForRongCloudLoginWithToken:token];
                                    
    } rongCloudTokenError:^(id rongCloudError) {
        
    }];
    
}

- (void)requestForRongCloudLoginWithToken:(TokenEntity *)tokenEntity {
    
    [RongCloudTools initRongCloudWithAppKey:RongCloud_Key
                                      token:tokenEntity.token
                                    success:^(id rongCloudReturnValue) {
        
                                        self.tokenSuccessBlock(rongCloudReturnValue);
                                        
                                        
    } failure:^(id rongCloudReturnError) {
        
    }];
    
}

@end
