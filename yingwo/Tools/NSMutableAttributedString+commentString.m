//
//  NSMutableAttributedString+commentString.m
//  yingwo
//
//  Created by apple on 16/9/30.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "NSMutableAttributedString+commentString.h"

@implementation NSMutableAttributedString (commentString)

+ (NSMutableAttributedString *)changeContentWithText:(NSString *)content
                                      withTextIndext:(NSUInteger)indent
                                        withFontSize:(CGFloat)size {
    
    //创建富文本字体
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor clearColor]
                    range:NSMakeRange(0, indent)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                     range:NSMakeRange(indent, content.length-indent)];
    return attrStr;

    
}

+ (NSMutableAttributedString *)changeCommentContentWithString:(NSString *)content
                                               WithTextIndext:(NSUInteger)indent {
    
    
    //创建富文本字体
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor clearColor]
                    range:NSMakeRange(0, indent)];
    
    return attrStr;
}

//+ (NSMutableAttributedString *)changeCommentReplyContentWithString:(NSString *)content {
//    
//    //创建富文本字体
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                    value:[UIColor clearColor]
//                    range:NSMakeRange(0, content.length)];
//    
//    return attrStr;
//}

@end
