//
//  MBProgressHUD+Dispaly.m
//  yingwo
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MBProgressHUD+Dispaly.h"

@implementation MBProgressHUD (Dispaly)

+ (void)showHUDToAddToView:(UIView *)view
                 labelText:(NSString *)text
                  animated:(Boolean)animated
                afterDelay:(float)delay
                   success:(void (^)())success {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];

    
    [hud showAnimated:YES whileExecutingBlock:^{
        
        hud.labelText                 = text;
        hud.mode                      = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:delay];

    } completionBlock:^{
        
        success();

    }];

}

+ (void)showErrorHUDToAddToView:(UIView *)view
                      labelText:(NSString *)text
                       animated:(Boolean)animated
                     afterDelay:(float)delay {
    
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.customView                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    hud.labelText                 = text;
    hud.labelFont                 = [UIFont systemFontOfSize:16];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

+ (MBProgressHUD *)showActivityIndicatorToView:(UIView *)view animated:(Boolean)animated {
    
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.mode                      = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (MBProgressHUD *)showProgressViewToView:(UIView *)view
                                 animated:(Boolean)animated {
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.mode                      = MBProgressHUDModeAnnularDeterminate;
    hud.removeFromSuperViewOnHide = YES;

    return hud;
}
@end
