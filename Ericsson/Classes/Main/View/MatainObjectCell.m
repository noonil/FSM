//
//  MatainObjectCell.m
//  Ericsson
//
//  Created by xuming on 15/10/10.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "MatainObjectCell.h"

@implementation MatainObjectCell


// 自绘分割线
- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor);
//    CGContextFillRect(context, CGRectMake(0, rect.size.height -20, rect.size.width, 10));
//    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(MatainObjectCell *)cellWithTableView:(UITableView *)tableView{

    static NSString *idd=@"matainObjectCell";
    MatainObjectCell *cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MatainObjectCell" owner:nil options:nil]lastObject];
    }
    return cell;

}

@end
