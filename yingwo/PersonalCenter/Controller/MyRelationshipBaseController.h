//
//  MyRelationshipBaseController.h
//  yingwo
//
//  Created by 王世杰 on 2016/11/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

//关系类型 1我的好友 2我的关注 3我的粉丝 4我的访客 5Ta的关注 6Ta的粉丝

typedef NS_ENUM(NSInteger,RelationType) {
    FriendRelationShip = 1,
    ConcernRelationShip = 2,
    FansRelationShip = 3,
    VisitorRelationShip = 4,
    HisRelationShip = 5,
    HisFansRelationShip = 6
};

@interface MyRelationshipBaseController : BaseViewController

@property (nonatomic, strong) RequestEntity *requestEntity;
@property (nonatomic, assign) RelationType  relationType;
@property (nonatomic, assign) int           friendCnt;
@property (nonatomic, assign) int           followCnt;
@property (nonatomic, assign) int           fansCnt;

- (instancetype)initWithRelationType:(RelationType)type;

@end
