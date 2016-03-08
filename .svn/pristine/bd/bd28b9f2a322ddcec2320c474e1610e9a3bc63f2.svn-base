//
//  NumberViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/12.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "NumberViewCell.h"

@implementation NumberViewCell

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
    
}

- (void)loadDataFromModel:(Xunjian_1 *)model{
    
    
    self.content.text = model.ruleName;
    
    NSString * str = [NSString stringWithFormat:@"%@/%@",model.unfinishedNum,model.total];
    
    [self.number setTitle:str forState:UIControlStateNormal];
    
    
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
    static NSString *ID = @"NumberCell";
    NumberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (NumberViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"NumberViewCell" owner:nil options:nil] lastObject];
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
