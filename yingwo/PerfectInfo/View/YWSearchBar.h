//
//  YWSearchBar.h
//  yingwo
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWSearchBar : UISearchBar

@property (nonatomic,strong) UIColor* boardColor;

@property (nonatomic,copy)    NSString *placeholderString;

@property (nonatomic,assign) CGFloat boardLineWidth;

- (instancetype) initWithFrame:(CGRect)frame boardColor:(UIColor *)color placeholderString:(NSString *)placehoderString;


@end
