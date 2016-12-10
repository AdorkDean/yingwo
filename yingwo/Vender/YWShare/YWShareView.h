//
//  YWShareView.h
//  yingwo
//
//  Created by 王世杰 on 2016/11/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@class YWShareView;
typedef void(^UMSocialSharePlatformSelectionBlock)(YWShareView *NewsShareView,UMSocialPlatformType platformType);

@interface YWShareView : UIView
@property (nonatomic, assign) UMSocialPlatformType selectionPlatform;
@property (nonatomic, copy) UMSocialSharePlatformSelectionBlock shareSelectionBlock;
///可分享的数组
@property (nonatomic, strong) NSMutableArray *sharePlatformInfoArray;

- (void)show;
- (void)hiddenShareMenuView;

@end
