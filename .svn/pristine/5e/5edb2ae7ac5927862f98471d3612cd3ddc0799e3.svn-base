//
//  Search_2TableViewCell.m
//  Ericsson
//
//  Created by Min on 16/1/6.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "Search_2TableViewCell.h"

@implementation Search_2TableViewCell


+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString * ID = @"storeCell";
    Search_2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"Search_2TableViewCell" owner:nil options:nil]lastObject];
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
