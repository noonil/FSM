//
//  SearchAssociateOrderCell.m
//  Ericsson
//
//  Created by Min on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "SearchAssociateOrderCell.h"

@implementation SearchAssociateOrderCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"associatOrderCell";
    SearchAssociateOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchAssociateOrderCell" owner:nil options:nil]lastObject];
        
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
