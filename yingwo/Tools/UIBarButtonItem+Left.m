//
//  UIBarButtonItem+(Left).m
//  yingwo
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "UIBarButtonItem+Left.h"

@implementation UIBarButtonItem (Left)



- (instancetype)initLeftBarButtonItemWithImage {
    
    self = [self  init];
    if (self == nil) {
        self = [self initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(popToForwardControllerWithSender:)];
    }
    return self;
}

- (void)popToForwardControllerWithSender:(UIViewController *) sender{

    [sender.navigationController popViewControllerAnimated:YES];
    
}

@end
