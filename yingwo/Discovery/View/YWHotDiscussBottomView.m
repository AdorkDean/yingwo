//
//  HotDiscussBottomView.m
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWHotDiscussBottomView.h"

@implementation YWHotDiscussBottomView

- (instancetype)init {
    if (self = [super init]) {
        
        [self createSubviews];
        
    }
    return self;
}

- (void)createSubviews {
    
    _messageImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reyi_pinglunshu"]];
    _clockImageView   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reyi_shijian"]];
    _messageNumLabel  = [[UILabel alloc] init];
    _timeLabel        = [[UILabel alloc] init];

    _messageNumLabel.textColor = [UIColor colorWithHexString:@"DEDFE0"];
    _timeLabel.textColor = [UIColor colorWithHexString:@"DEDFE0"];

    _messageNumLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.font = [UIFont systemFontOfSize:12];

    [self addSubview:_messageImageView];
    [self addSubview:_clockImageView];
    [self addSubview:_messageNumLabel];
    [self addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right);
        
    }];
    
    [_clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(_timeLabel.mas_left).offset(-7.5);
    }];
    
    [_messageNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(_clockImageView.mas_left).offset(-7.5);

    }];
    
    [_messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(_messageNumLabel.mas_left).offset(-7.5);

    }];
    
    UIImageView *lastImageView;
    
    for (int i = 1; i < 7 ; i ++ ) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag          = i;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 12.5;
        
        [self addSubview:imageView];
        
        if (lastImageView != nil) {
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@25);
                make.centerY.equalTo(self);
                make.left.equalTo(lastImageView.mas_right).offset(2);
            }];
            
        }
        else {
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@25);
                make.centerY.equalTo(self);
                make.left.equalTo(self.mas_left);
            }];
            
        }
        

        
        lastImageView = imageView;
    }
    
}

- (void)addHeadImagesWith:(NSArray *)imageURLArr {
    
    for (int i = 0; i < 7; i ++) {
        
        UIImageView *imageView = [self viewWithTag:i+1];

        if (i < imageURLArr.count) {
            
            if ([imageURLArr objectAtIndex:i] != nil) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[imageURLArr objectAtIndex:i]]
                             placeholderImage:[UIImage imageNamed:@"ying"]];
            }

        }
        else {
            imageView.image = nil;
        }
    }
    
    
}

@end










