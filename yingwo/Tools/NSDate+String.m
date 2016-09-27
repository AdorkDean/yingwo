//
//  YWDateTools.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

+ (NSString *)getDateString:(NSString *)spString
{
    NSString *dateString;

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];

    [dateFormat setDateFormat:@"yyyy"];
    NSString *year        = [dateFormat stringFromDate:confromTimesp];
    NSString *nowYear     = [dateFormat stringFromDate:[NSDate new]];

    [dateFormat setDateFormat:@"MM"];
    NSString *month       = [dateFormat stringFromDate:confromTimesp];
    NSString *nowMonth    = [dateFormat stringFromDate:[NSDate new]];

    [dateFormat setDateFormat:@"dd"];
    NSString *day         = [dateFormat stringFromDate:confromTimesp];
    NSString *nowDay      = [dateFormat stringFromDate:[NSDate new]];

    [dateFormat setDateFormat:@"HH"];
    NSString *hour        = [dateFormat stringFromDate:confromTimesp];
    NSString *nowHour     = [dateFormat stringFromDate:[NSDate new]];

    [dateFormat setDateFormat:@"mm"];
    NSString *minute        = [dateFormat stringFromDate:confromTimesp];
    NSString *nowMinute     = [dateFormat stringFromDate:[NSDate new]];
   
    
    //如果是同一天，显示有几种情况
    //0～1分钟显示刚刚
    //1～60分钟显示分钟数
    //1小时～23小时显示小时数
    //其他显示日期：xxxx年xx月xx日
    if ([year isEqualToString:nowYear] && [month isEqualToString:nowMonth] && [day isEqualToString:nowDay]) {
        
        //发布小时差
        int hourReduce = (int)(nowHour.integerValue - hour.integerValue);
        //小于1小时
        if (hourReduce < 1) {
            //分钟差
            int minuteReduce = (int)(nowMinute.integerValue - minute.integerValue);
            
            if (minuteReduce <= 1) {
                
                dateString = @"刚刚";

            }else {
                dateString = [NSString stringWithFormat:@"%d分钟前",minuteReduce];
            }
        }
        else {
            dateString = [NSString stringWithFormat:@"%d小时前",(int)(nowHour.integerValue - hour.integerValue)];
        }
        
    }else {
        
        [dateFormat setDateFormat:@"yyyy年MM月dd日"];
        dateString = [dateFormat stringFromDate:confromTimesp];
    }
    
    return dateString;
}


@end
