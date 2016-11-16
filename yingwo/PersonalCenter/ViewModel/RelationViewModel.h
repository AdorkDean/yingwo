//
//  RelationViewModel.h
//  yingwo
//
//  Created by 王世杰 on 2016/11/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWMyRelationShipCell.h"

#import "RelationEntity.h"

@interface RelationViewModel : NSObject

@property (nonatomic, strong) RACCommand *fecthRelationEntityCommand;


- (void)setupModelOfCell:(YWMyRelationShipCell*)cell model:(RelationEntity *)model;


@end
