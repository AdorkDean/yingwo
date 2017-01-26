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

/**
 *  任意文本缩进
 *
 *  @param content 文本
 *  @param indent  缩进距离
 *  @param size    文本大小
 *
 *  @return 返回富文本字体
 */
+ (NSMutableAttributedString *)changeContentWithText:(NSString *)content
                                      withTextIndext:(NSUInteger)indent
                                        withFontSize:(CGFloat)size;
@end
