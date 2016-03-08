//
//  ThreeLabelCell.m
//  Ericsson
//
//  Created by xuming on 15/12/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ThreeLabelCell.h"

@implementation ThreeLabelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    ThreeLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ThreeLabelCell *)[[[NSBundle mainBundle] loadNibNamed:@"ThreeLabelCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}
@end
