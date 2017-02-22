//
//  YWReplyCell.h
//  yingwo
//
//  Created by apple on 2017/2/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWDetailReplyCell.h"

@interface YWReplyCell : YWDetailReplyCell

@property (nonatomic, strong) YWCommentView     *selectedCommentView;
@property (nonatomic, strong) DetailViewModel   *detailViewModel;

@end
