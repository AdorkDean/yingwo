//
//  YWInputButton.h
//  yingwo
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWInputButton : UIButton

@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *centerLabel;

-(instancetype)initWithFrame:(CGRect)frame leftLabel:(NSString *)left centerLabel:(NSString *)center;
- (void)showRightView;

@end
