//
//  YWDiscoveryBaseCell.h
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXScrollView.h"
#import "SMPagerTabView.h"

#import "FieldOneController.h"
#import "FieldTwoController.h"
#import "FieldThreeController.h"


@interface YWDiscoveryBaseCell : UITableViewCell

@property (nonatomic,strong ) NSMutableArray       *images;
@property (nonatomic, strong) MXImageScrollView    *mxScrollView;

@property (nonatomic, strong) SMPagerTabView       *discoverySegmentView;
@property (nonatomic, strong) NSMutableArray       *catalogVcArr;

@property (nonatomic, strong) FieldOneController   *oneFieldVc;
@property (nonatomic, strong) FieldTwoController   *twoFieldVc;
@property (nonatomic, strong) FieldThreeController *threeFieldVc;

@end
