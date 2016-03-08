//
//  ResourceInfoCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ResourceInfoCell.h"

@implementation ResourceInfoCell


//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ResourceInfo";
    ResourceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ResourceInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"ResourceInfoCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
