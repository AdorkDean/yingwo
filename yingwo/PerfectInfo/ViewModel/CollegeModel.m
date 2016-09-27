//
//  CollegeViewModel.m
//  Test
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "CollegeModel.h"

@implementation CollegeModel

- (void)saveCollegeDataInUserDefault:(NSArray *)colleges {
    NSData *collegeData         = [NSKeyedArchiver archivedDataWithRootObject:colleges];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:collegeData forKey:@"college"];
}

- (NSArray *)getCollegeDataFromUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data                = [userDefault objectForKey:@"college"];
    NSArray *colleges           = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return colleges;
}

- (NSMutableArray *)getCollegeGroupNamesFromUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data                = [userDefault objectForKey:@"college"];
    NSArray *colleges           = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSMutableArray *groupNames  = [[NSMutableArray alloc] init];

    for (NSArray *list in colleges) {
        NSDictionary *item = [list objectAtIndex:0];
        [groupNames addObject:item[@"group"]];
    }
    return groupNames;
}

- (void)deleteAllCollegeData {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"college"];
}

@end
