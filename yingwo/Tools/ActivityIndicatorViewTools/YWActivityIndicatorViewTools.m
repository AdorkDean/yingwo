//
//  YWActivityIndicatorViewTools.m
//  yingwo
//
//  Created by apple on 2017/3/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWActivityIndicatorViewTools.h"

@interface YWActivityIndicatorViewTools()

@property (nonatomic, strong) DGActivityIndicatorView *indicatorView;

@end

@implementation YWActivityIndicatorViewTools

- (void)showActivityLoadingInController:(BaseViewController *)controller{
    
    _indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce
                                                                                 tintColor:[UIColor colorWithHexString:THEME_COLOR_1]
                                                                                      size:60];
    
    _indicatorView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-60);
    [controller.view addSubview:_indicatorView];
    
    [_indicatorView startAnimating];
    
}

- (void)stopIndicatorViewAnimation {
    
    [_indicatorView stopAnimating];
    
}



@end
