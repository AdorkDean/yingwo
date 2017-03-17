//
//  YWVisitorNumLabel.m
//  yingwo
//
//  Created by apple on 2017/3/5.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWVisitorNumLabel.h"

@implementation YWVisitorNumLabel

- (void)setVisitorNumber:(NSString *)visitorNumber {
    
    if (visitorNumber.length != 0) {
        self.text = [NSString stringWithFormat:@"访问量为:%@",visitorNumber];
    }
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
        self.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

@end
