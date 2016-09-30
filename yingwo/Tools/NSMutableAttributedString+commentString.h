//
//  NSMutableAttributedString+commentString.h
//  yingwo
//
//  Created by apple on 16/9/30.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (commentString)

/**
 *  评论缩进实现
 *
 *  @param content 评论内容
 *  @param indent  缩进长度
 *
 *  @return 返回富文本字体
 */
+ (NSMutableAttributedString *)changeCommentContentWithString:(NSString *)content
                                               WithTextIndext:(NSUInteger)indent;
@end
