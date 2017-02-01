//
//  YWDropDownViewCell.m
//  Test
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDropDownViewCell.h"

@implementation YWDropDownViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    _centerLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _centerLabel.textAlignment   = NSTextAlignmentCenter;
    _centerLabel.font            = [UIFont systemFontOfSize:14];
    [self addSubview:_centerLabel];
    

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
