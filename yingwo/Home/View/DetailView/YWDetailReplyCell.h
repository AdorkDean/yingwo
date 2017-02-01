//
//  YWDetailReplyCell.h
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailBaseTableViewCell.h"

#import "TieZiComment.h"
#import "YWCommentView.h"
#import "YWCommentReplyView.h"
#import "DetailViewModel.h"

@interface YWDetailReplyCell : YWDetailBaseTableViewCell

- (void)comment:(UITapGestureRecognizer *)sender;
- (void)showMenuController:(UILongPressGestureRecognizer *)sender;

@end
