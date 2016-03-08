//
//  TroubleHistoryListCell.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/12.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "TroubleHistoryListCell.h"

@implementation TroubleHistoryListCell

// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height -10, rect.size.width, 2));
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TableCell";
    TroubleHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TroubleHistoryListCell *)[[[NSBundle mainBundle] loadNibNamed:@"TroubleHistoryListCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
