//
//  AttachTableViewCell.m
//  Ericsson
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "AttachTableViewCell.h"

@implementation AttachTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Attach";
    AttachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttachTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
