//
//  YWHomeTableViewCellBase.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWHomeTableViewCellBase.h"

@implementation YWHomeTableViewCellBase

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubview];
        self.backgroundColor                 = [UIColor clearColor];
        self.backgroundView.backgroundColor     = [UIColor whiteColor];
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.layer.cornerRadius  = 10;
        self.backgroundView.frame = CGRectMake(0, 0, self.width - self.width * 0.05, 0);

    }
    return self;
}

- (void)createSubview {
    
}

- (void)addImageViewByImageArr:(NSMutableArray *)imageArr {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
