//
//  YWTaTieziView.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaTieziView.h"
#import "TieZi.h"
#import "DetailController.h"
#import "TopicController.h"

//刷新的初始值
static int start_id = 0;

@protocol  YWHomeCellMiddleViewBaseProtocol;
@interface YWTaTieziView()


@property (nonatomic, strong) TieZi             *model;
@property (nonatomic, strong) RequestEntity     *requestEntity;

@end

@implementation YWTaTieziView

- (TieZi *)model {
    if (_model == nil) {
        
        _model = [[TieZi alloc] init];
    }
    return _model;
}


- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.URLString = MY_TIEZI_URL;
        //请求的事新鲜事
      //  _requestEntity.topic_id   = AllThingModel;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
}

-(NSMutableArray *)rowHeightArr {
    if (_rowHeightArr == nil) {
        _rowHeightArr = [[NSMutableArray alloc] init];
        _rowHeightArr = [NSMutableArray arrayWithCapacity:2];
    }
    return _rowHeightArr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor                = [UIColor whiteColor];
        UILabel *taTopicLabel               = [[UILabel alloc] init];
        taTopicLabel.text                   = @"TA的贴子";
        taTopicLabel.textColor              = [UIColor colorWithHexString:THEME_COLOR_4];
        taTopicLabel.font                   = [UIFont systemFontOfSize:SCREEN_HEIGHT / 667 * 16];
        
        UILabel *moreLabel                  = [[UILabel alloc] init];
        moreLabel.text                      = @"更多";
        moreLabel.textColor                 = [UIColor colorWithHexString:THEME_COLOR_4];
        moreLabel.font                      = [UIFont systemFontOfSize:SCREEN_HEIGHT / 667 * 16];
        
        UIView *separator                   = [[UIView alloc] init];
        separator.backgroundColor           = [UIColor colorWithHexString:@"#F5F5F5"];

        
        UIImageView *rightImageView         = [[UIImageView alloc] init];
        rightImageView.image                = [UIImage imageNamed:@"Row"];
        rightImageView.contentMode          = UIViewContentModeScaleAspectFill;
        
        [self addSubview:taTopicLabel];
        [self addSubview:rightImageView];
        [self addSubview:separator];
        [self addSubview:moreLabel];
        
        [taTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(taTopicLabel);
        }];
        
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(taTopicLabel.mas_bottom).offset(5);
            make.right.width.equalTo(self);
            make.height.equalTo(@1);
        }];
        
        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImageView.mas_left).offset(-10);
            make.top.equalTo(taTopicLabel);
        }];
        
    }
    return self;
}

- (void)addSomeTieZiWith:(NSMutableArray *)tieZiArr {
    
}

@end








