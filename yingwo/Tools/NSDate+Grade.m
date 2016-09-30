//
//  NSDate+Grade.m
//  yingwo
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "NSDate+Grade.h"

@implementation NSDate (Grade)

+ (NSArray *)gradeInRecentYears {
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:currentDate];
    NSInteger thisYear = [components year];
    
    NSArray *recentYears = @[@(thisYear-3),@(thisYear-2),@(thisYear-1),@(thisYear),@(thisYear+1),@(thisYear+2),@(thisYear+3)];
    
    return recentYears;
}

@end
