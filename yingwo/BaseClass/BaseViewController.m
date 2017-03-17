//
//  BaseViewController.m
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(backToFarword)];
    }
    return _leftBarItem;
}

- (YWActivityIndicatorViewTools *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[YWActivityIndicatorViewTools alloc] init];
    }
    return _indicatorView;
}

- (void)createSubviews {
    
}

- (void)layoutSubviews {
    
}

- (void)addAction {
    
}

- (void)initDataSourceBlock {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    [self createSubviews];
    [self layoutSubviews];
    [self initDataSourceBlock];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addAction];
    
    [YWNetworkTools networkStauts];

}

- (void)backToFarword {
    
    [self customPopToForward];
}

- (void)showLoadingViewOnFrontView:(UIView *)frontView {
    
    [self.indicatorView showActivityLoadingInController:self];
    frontView.alpha = 0;
    
}

- (void)showFrontView:(UIView *)frontView {
    
    [UIView animateWithDuration:0.8 animations:^{
        
        frontView.alpha = 1;
        [self.indicatorView stopIndicatorViewAnimation];
        
    } completion:^(BOOL finished) {
        
        self.indicatorView = nil;
    }];
    
    
}

/*
 animation.type = kCATransitionFade;
 
 animation.type = kCATransitionPush;
 
 animation.type = kCATransitionReveal;
 
 animation.type = kCATransitionMoveIn;
 
//左右翻转
 animation.type = @"cube";
 
 animation.type = @"suckEffect";
 
 // 页面旋转
 animation.type = @"oglFlip";

 //水波纹
 animation.type = @"rippleEffect";
 
 //翻页
 animation.type = @"pageCurl";
 //翻页
 animation.type = @"pageUnCurl";
 
 //相机打开
 animation.type = @"cameraIrisHollowOpen";
 //相机关闭
 animation.type = @"cameraIrisHollowClose";
 
 */
- (void)customPushToViewController:(UIViewController *)controller {
    
    CATransition *transition  = [CATransition animation];
    transition.duration       = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type           = @"rippleEffect";
    transition.subtype        = kCATransitionFromRight;

    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (void)customPopToForward {
    
    CATransition *transition  = [CATransition animation];
    transition.duration       = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type           = @"rippleEffect";
    transition.subtype        = kCATransitionFromRight;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
