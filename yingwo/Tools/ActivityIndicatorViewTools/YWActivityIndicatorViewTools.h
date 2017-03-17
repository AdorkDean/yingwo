//
//  YWActivityIndicatorViewTools.h
//  yingwo
//
//  Created by apple on 2017/3/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWActivityIndicatorViewTools : NSObject

- (void)showActivityLoadingInController:(BaseViewController *)controller;
- (void)stopIndicatorViewAnimation;
@end
