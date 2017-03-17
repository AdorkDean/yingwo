//
//  SCPopView.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCPopView.h"
#import "CommonMacro.h"

@implementation SCPopView

#pragma mark - Private Methods
#pragma mark -
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles) {
        CGSize size = [title sizeWithAttributes:
                       @{NSFontAttributeName: _titleFont}];
        CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        NSNumber *width = [NSNumber numberWithFloat:adjustedSize.width + 40.0f];
        [widths addObject:width];
    }
    
    return widths;
}

- (void)updateSubViewsWithItemWidths:(NSArray *)itemWidths;
{
    
    CGFloat marginWidth = 16;
    CGFloat marginHeight = 16;
    CGFloat buttonX = DOT_COORDINATE + marginWidth;
    CGFloat buttonY = DOT_COORDINATE + 35;
    
    UIImage *image = [self creatColorImage];
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:_itemNames.count];
    
    for (NSInteger index = 0; index < [itemWidths count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake(buttonX, buttonY, [itemWidths[index] floatValue], ITEM_HEIGHT - 5);
        [button setTitle:_itemNames[index] forState:UIControlStateNormal];
        button.titleLabel.font = _titleFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:image forState:UIControlStateSelected];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = (ITEM_HEIGHT - 5) / 2;
        button.layer.borderColor = [UIColor colorWithHexString:THEME_COLOR_5].CGColor;
        button.layer.borderWidth = 1;
        
        [self addSubview:button];
        [buttons addObject:button];
        
        buttonX += [itemWidths[index] floatValue] + marginWidth;
        
        @try {
            if ((buttonX + [itemWidths[index + 1] floatValue]) >= SCREEN_WIDTH)
            {
                buttonX = DOT_COORDINATE + marginWidth;
                buttonY += ITEM_HEIGHT + marginHeight;
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    self.buttons = buttons;
    //第一次弹出 全部 标签为选中状态
    UIButton *button = self.buttons.firstObject;
    [button setSelected:YES];
}

- (UIImage *)creatColorImage {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:THEME_COLOR_1].CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)itemPressed:(UIButton *)button
{
    [_delegate itemPressedWithIndex:button.tag];
}

- (void)addLabel {
    UILabel *changeLabel = [[UILabel alloc] init];
    changeLabel.text = @"切换主题";
    changeLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_4];
    changeLabel.textAlignment = NSTextAlignmentLeft;
    changeLabel.frame = CGRectMake(15, 0, 100, 20);
    changeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:changeLabel];

}

#pragma mark - Public Methods
#pragma marl -
- (void)setItemNames:(NSArray *)itemNames
{
    _itemNames = itemNames;
    
    NSArray *itemWidths = [self getButtonsWidthWithTitles:itemNames];
    [self addLabel];
    [self updateSubViewsWithItemWidths:itemWidths];
}

@end
