//
//  OrderViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/13.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "OrderViewCell.h"

@implementation OrderViewCell

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height - 5, rect.size.width, 5));
    
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
    static NSString *ID = @"OrderProcessingCell";
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (OrderViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"OrderViewCell" owner:nil options:nil] lastObject];
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
