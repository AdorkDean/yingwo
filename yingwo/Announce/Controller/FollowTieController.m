//
//  FollowTieController.m
//  yingwo
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "FollowTieController.h"

@interface FollowTieController ()

@end

@implementation FollowTieController


- (void)setReplyTieZiBlock:(ReplyTieZiBlock)replyTieZiBlock {
    _replyTieZiBlock = replyTieZiBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.announceTextView.contentTextView.placeholder = @"跟贴～";
}

/**
 *  既有图片又有内容
 *
 *  @param photoArr 图片数组
 *  @param content  贴子内容
 */
- (void)postTieZiWithImages:(NSArray *)photoArr andContent:(NSString *)content {
    
    //   MBProgressHUD *hud = [MBProgressHUD showProgressViewToView:self.view animated:YES];
    [YWQiNiuUploadTool uploadImages:photoArr
                           progress:^(CGFloat progress) {
                               
                               [SVProgressHUD showProgress:progress];
                               
                           } success:^(NSArray *arr) {
                               
                               NSString *allUrlString          = [NSArray appendElementToString:arr];
                               
                               RequestEntity *request = [[RequestEntity alloc] init];
                               
                               request.URLString = TIEZI_REPLY;
                               request.parameter = @{@"post_id":@(self.post_id),@"content":content,@"img":allUrlString};
                               
                               [self.viewModel postTieZiWithRequest:request
                                                            success:^(id content) {
                                                                
                                                                [SVProgressHUD showSuccessStatus:@"发布成功" afterDelay:HUD_DELAY];
                                                                
                                                                self.replyTieZiBlock(request.parameter);
                                                                
                                                                [self backToFarword];
                                                                
                                                            } failure:^(id error) {
                                                                [SVProgressHUD showErrorStatus:@"发布失败" afterDelay:HUD_DELAY];
                                                                
                                                            }];
                               
                           } failure:^{
                               [SVProgressHUD showErrorStatus:@"发布失败" afterDelay:HUD_DELAY];
                               
                           }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
