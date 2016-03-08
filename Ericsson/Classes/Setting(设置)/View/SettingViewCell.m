//
//  SettingViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/9/29.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell


// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height -1, rect.size.width, 1));
    
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Setting";
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
