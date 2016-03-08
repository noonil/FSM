

//
//  SpareApplyTableViewCell.m
//  Ericsson
//
//  Created by Min on 16/1/6.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "SpareApplyTableViewCell.h"

@implementation SpareApplyTableViewCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString * ID = @"applyCell";
    SpareApplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SpareApplyTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
