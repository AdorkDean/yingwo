//
//  CustomDismissSegue.m
//  yingwo
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "CustomDismissSegue.h"

@implementation CustomDismissSegue

- (void)perform {
    [self dismissPerform];
}

- (void)dismissPerform {
    
    UIViewController *sourceVc = self.sourceViewController;
    UIViewController *destinationVc = self.destinationViewController;
    destinationVc.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor whiteColor];
    [sourceVc dismissViewControllerAnimated:YES completion:nil];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        destinationVc.view.transform = CGAffineTransformMakeScale(1, 1);

        
    } completion:nil];
}

@end
