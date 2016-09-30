//
//  YWDropDownView.m
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDropDownView.h"
#import "YWDropDownViewCell.h"

@implementation YWDropDownView
{
    UITableView *_tableView;
    CGFloat _tableViewHeight;
    CGFloat _tableViewWidth;
}

- (instancetype)initWithTitlesArr:(NSMutableArray *) titles height:(CGFloat) height width:(CGFloat)width{
    
    self = [super init];
    if (self) {
        
        self.titleArr        = titles;
        _tableViewHeight     = height;
        _tableViewWidth      = width;
        self.backgroundColor = [UIColor blackColor];
        self.alpha           = 0.2;

        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    
    _tableView                     = [[UITableView alloc] initWithFrame:CGRectMake(30, 70, _tableViewWidth, 0) style:UITableViewStylePlain];
    _tableView.delegate            = self;
    _tableView.dataSource          = self;
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius  = 8;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    


}

static CGFloat ANIMATION_TIME = 0.3;

- (void)showDropDownView {
   
    self.hidden = NO;
    self.frame  = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    
    [self.superview addSubview:_tableView];

    
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
        _tableView.frame = CGRectMake(30, 70, _tableViewWidth, _tableViewHeight);
    }];
}

- (void)hideDropDownView{
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        _tableView.frame = CGRectMake(30, 70, _tableViewWidth, 0);

    } completion:^(BOOL finished) {
        self.hidden = YES;
        [_tableView removeFromSuperview];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"cell";
    YWDropDownViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[YWDropDownViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        
        cell.centerLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_1];
    }
    else
    {
        cell.centerLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
    }
    cell.centerLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    cell.tag              = 100 + indexPath.row;
    
        return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YWDropDownViewCell *cell;
    
    for (int i = 100; i <= 103; i ++)
    {
        cell                       = [_tableView viewWithTag:i];
        cell.centerLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
    }
    
    cell                       = [tableView cellForRowAtIndexPath:indexPath];
    cell.centerLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_1];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hideDropDownView];
    
    if ([_delegate respondsToSelector:@selector(seletedDropDownViewAtIndex:)]) {
        [_delegate seletedDropDownViewAtIndex:indexPath.row];
    }
    self.isPopDropDownView = NO;
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    //第一行不允许点击
//    if (indexPath.row == 0) {
//        YWDropDownViewCell *cell   = [tableView cellForRowAtIndexPath:indexPath];
//        cell.selectionStyle        = UITableViewCellSelectionStyleNone;
//        cell.centerLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_1];
//    }
//    else {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        
//        [self hideDropDownView];
//        
//        if ([_delegate respondsToSelector:@selector(seletedDropDownViewAtIndex:)]) {
//            [_delegate seletedDropDownViewAtIndex:indexPath.row];
//        }
//    }
//    
//    self.isPopDropDownView = NO;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

#pragma mark 点击背景View，收起DropDownView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        [self performSelector:@selector(hideDropDownView)];
        self.isPopDropDownView = NO;
    }
}

@end
