//
//  Topic.h
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

//主题数组
@property (nonatomic, strong) NSMutableArray *subjectArr;

//主题下话题数组
@property (nonatomic, strong) NSMutableArray *topicArr;

@end
