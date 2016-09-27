//
//  NSArray+(String).m
//  yingwo
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "NSArray+(String).h"

@implementation NSArray (String)

+ (NSString *)appendElementToString:(NSArray *)arr {
    
    NSString *fullString = @"";
    
    for (int i = 0; i < arr.count; i ++) {
        if (i == arr.count -1 ) {
            fullString = [fullString stringByAppendingString: [NSString stringWithFormat:@"%@",arr[i]]];
        }else {
            fullString = [fullString stringByAppendingString: [NSString stringWithFormat:@"%@,",arr[i]]];
        }
    }
    
    return fullString;
}

@end
