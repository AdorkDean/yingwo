//
//  YWDetailBaseTableViewCell.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailBaseTableViewCell.h"

@implementation YWDetailBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //createSubview 这个方法的调用延迟到子类中，不然无法解决cell复用带来的重叠问题
        //createSubView 在ViewModel中添加子view的时候调用，即setupModelOfCell这个方法中
        //下面实现圆角的代码要迁移到子类中去
        
     //   [self createSubview];
//        self.backgroundColor                    = [UIColor clearColor];
//        self.backgroundView.backgroundColor     = [UIColor whiteColor];
//        self.backgroundView.layer.masksToBounds = YES;
//        self.backgroundView.layer.cornerRadius  = 10;        
    }
    return self;
}

- (void)createSubview {
    
}

- (void)addImageViewByImageArr:(NSMutableArray *)imageArr {
    
}

- (void)addCommentViewByCommentArr:(NSMutableArray *)commentArr withMasterId:(NSInteger)master_id {

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
