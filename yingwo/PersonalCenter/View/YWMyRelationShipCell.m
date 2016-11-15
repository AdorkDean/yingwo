//
//  YWMyRelationShipCell.m
//  yingwo
//
//  Created by 王世杰 on 2016/11/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWMyRelationShipCell.h"

@implementation YWMyRelationShipCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self creatSubview];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius  = 25;
        
    }
    return self;
}

- (void) creatSubview {
    _headImageView                  = [[UIImageView alloc] init];
    _nameLabel                      = [[UILabel alloc] init];
    _signatureLabel                 = [[UILabel alloc] init];
    
    _nameLabel.font                 = [UIFont systemFontOfSize:15];
    _signatureLabel.font            = [UIFont systemFontOfSize:13];
    
    _nameLabel.textColor            = [UIColor colorWithHexString:THEME_COLOR_2];
    _signatureLabel.textColor       = [UIColor colorWithHexString:THEME_COLOR_3];
    
    _rightBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.layer.masksToBounds   = YES;
    _rightBtn.layer.cornerRadius    = 17;
    _rightBtn.titleLabel.font       = [UIFont systemFontOfSize:15];
    
    [_rightBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [_rightBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, SCREEN_WIDTH / 375 * 6, 0, 0)];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu_card"] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_headImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_signatureLabel];
    [self addSubview:_rightBtn];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.height.width.equalTo(@50);
        make.centerY.equalTo(self);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.width.equalTo(@150);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.right.equalTo(_rightBtn.mas_left).offset(-10);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@34);
        make.width.equalTo(@95);
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
