//
//  YWHomeCellMiddleViewMoreNineImage.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWHomeCellMiddleViewMoreNineImage.h"

@implementation YWHomeCellMiddleViewMoreNineImage

- (void)addImageViewsFrameToView {
    
    [self setImageHeightByDivide:3];
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *arr3 = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < 3; i ++) {
        [arr1 addObject:[self.imagesArr objectAtIndex:i]];
    }
    for (int j = 3; j < 6; j ++) {
        [arr2 addObject:[self.imagesArr objectAtIndex:j]];
    }
    
    for (int k = 6; k < 9; k ++) {
        [arr3 addObject:[self.imagesArr objectAtIndex:k]];
    }
    
    [arr1 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:self.margin leadSpacing:0 tailSpacing:0];
    
    [arr2 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:self.margin leadSpacing:0 tailSpacing:0];
    
    [arr3 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:self.margin leadSpacing:0 tailSpacing:0];
    
    [arr1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(self.YWOneImageHeight));
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
    [arr2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(self.YWOneImageHeight));
        make.top.equalTo(arr1).offset(self.YWOneImageHeight+self.margin);
        
    }];
    
    [arr3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(self.YWOneImageHeight));
        make.top.equalTo(arr2).offset(self.YWOneImageHeight+self.margin);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
    }];
    
    //显示总张数
    YWLabel *numbersLabel = [[YWLabel alloc] init];
    numbersLabel.label.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)self.imagesArr.count];
    numbersLabel.label.textColor = [UIColor whiteColor];
    numbersLabel.backgroundColor = [UIColor blackColor];
    numbersLabel.alpha = 0.5;
    [self addSubview:numbersLabel];
    
    [numbersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}


@end
