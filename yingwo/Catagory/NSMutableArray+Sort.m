//
//  NSMutableArray+(Sort).m
//  yingwo
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "NSMutableArray+Sort.h"
#import "TieZiReply.h"

@implementation NSMutableArray (Sort)

/**
 *  升序排序
 *
 */
- (void)bubSortWithArrayByAsc{
    
    for (int i = 0; i < self.count; i  ++)
    {
        TieZiReply *left = [self objectAtIndex:i];

        for (int j = i; j < self.count; j ++)
        {
            
            TieZiReply *right = [self objectAtIndex:j];

            if (left.reply_id > right.reply_id)
            {
                TieZiReply *temp = right;
                //将大的放右边
                [self replaceObjectAtIndex:j withObject:right];
                //小的放左边
                [self replaceObjectAtIndex:i withObject:temp];

            }
        }
    }
}

@end
