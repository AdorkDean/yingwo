//
//  YWMyRelationShipCell.h
//  yingwo
//
//  Created by 王世杰 on 2016/11/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWMyRelationShipCellDelegate;

@interface YWMyRelationShipCell : UITableViewCell

@property (nonatomic, strong) UIImageView        *headImageView;

@property (nonatomic, strong) UILabel            *nameLabel;

@property (nonatomic, strong) UILabel            *signatureLabel;

@property (nonatomic, strong) UIButton           *rightBtn;

@property (nonatomic, assign) int                user_id;

@property (nonatomic, assign) id<YWMyRelationShipCellDelegate> delegate;


@end

@protocol YWMyRelationShipCellDelegate <NSObject>

//点击关注话题的按钮
//- (void)didSelectRightBtnWith:(int)value;

@end


