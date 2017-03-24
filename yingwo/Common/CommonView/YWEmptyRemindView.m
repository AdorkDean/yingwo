//
//  EmptyRemindView.m
//  yingwo
//
//  Created by 王世杰 on 2017/3/20.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWEmptyRemindView.h"

@implementation YWEmptyRemindView

-(instancetype)initWithFrame:(CGRect)frame andText:(NSString *)remindText {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self creatSubViewWithText:remindText];
        self.hidden = YES;
    }
    return self;
}

-(void)creatSubViewWithText:(NSString *)text {
    self.imageView                  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyRemind"]];    
    self.remindLabel                = [[UILabel alloc] init];
    self.remindLabel.text           = text;
    self.remindLabel.textAlignment  = NSTextAlignmentCenter;
    self.remindLabel.textColor      = [UIColor colorWithHexString:THEME_COLOR_3];
    self.remindLabel.font           = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.imageView];
    [self addSubview:self.remindLabel];
    
    CGFloat viewWidth = SCREEN_WIDTH / 2;

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT / 6);
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH - viewWidth) / 2);
        make.width.mas_equalTo(viewWidth);
        make.height.mas_equalTo(viewWidth);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.right.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView.mas_bottom).offset(20);
    }];

}
@end
