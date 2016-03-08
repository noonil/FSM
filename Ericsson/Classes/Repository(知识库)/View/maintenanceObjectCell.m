//
//  maintenanceObjectCell.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/10.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "maintenanceObjectCell.h"

@implementation maintenanceObjectCell

// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height -1, rect.size.width, 1));
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TableCell";
    maintenanceObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (maintenanceObjectCell *)[[[NSBundle mainBundle] loadNibNamed:@"maintenanceObjectCell" owner:nil options:nil] lastObject];
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
