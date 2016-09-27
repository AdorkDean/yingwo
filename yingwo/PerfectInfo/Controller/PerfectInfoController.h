//
//  PerfectInfoController.h
//  yingwo
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  完善信息
 */
@interface PerfectInfoController : UIViewController

@property (nonatomic, copy)NSString *signature;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *gender;
@property (nonatomic, copy)NSString *grade;
@property (nonatomic, copy)NSString *school;
@property (nonatomic, copy)NSString *academy;
@property (nonatomic, copy)NSString *school_id;
@property (nonatomic, copy)NSString *academy_id;

@property (nonatomic, copy)NSString *headImagePath;
//用来判断是否是修改信息
@property (nonatomic, assign)BOOL isModfiyInfo;

@end
