//
//  TTTAttributedLabel+Link.m
//  yingwo
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "TTTAttributedLabel+Link.h"

@implementation TTTAttributedLabel (Link)

- (void)replaceLinksWithPin{
    
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self.text
                                               options:0
                                                 range:NSMakeRange(0, [self.text length])];
    
    if (arrayOfAllMatches.count == 0) {
        return;
    }
    
    // add attribute for text
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:15.0],NSFontAttributeName,
                                   [UIColor colorWithHexString:THEME_COLOR_2].CGColor,
                                   NSForegroundColorAttributeName,nil];
    
    // new string
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text
                                                                                        attributes:attributeDict];
        
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        
        NSString *substringForMatch = [self.text substringWithRange:match.range];
        

        [attributeString replaceCharactersInRange:match.range withString:@"🔗网页链接"];
        
        NSRange newRange = NSMakeRange(match.range.location, 6);

        [self setText:attributeString];
        
        [self addLinkToURL:[NSURL URLWithString:substringForMatch] withRange:newRange];

    }
    
}
@end







