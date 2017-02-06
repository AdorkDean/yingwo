//
//  YWWebViewController.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "NJKWebViewProgress.h"

//  这里YWWebViewController命名冲突，改为
@interface MyWebViewController : BaseViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic, strong)NSURL *url;


- (instancetype)initWithURL:(NSURL *)url;

@end
