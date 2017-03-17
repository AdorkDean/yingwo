//
//  TieZi.m
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TieZi.h"

@implementation TieZi

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tieZi_id":@"id"};
}

- (NSString *)reply_cnt {
    if (_reply_cnt.length == 0) {
        _reply_cnt = @"0";
    }
    return _reply_cnt;
}

- (NSString *)like_cnt {
    if (_like_cnt.length == 0) {
        _like_cnt = @"0";
    }
    return _like_cnt;
}


@end
