//
//  YWWebViewController.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "NJKWebViewProgress.h"

@interface YWWebViewController : BaseViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic, strong)NSURL *url;


- (instancetype)initWithURL:(NSURL *)url;

@end
