
//
//  AddAnnounceTableViewCell.m
//  Ericsson
//
//  Created by Min on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AddAnnounceTableViewCell.h"

@implementation AddAnnounceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (AddAnnounceTableViewCell*)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"departCell";
    AddAnnounceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddAnnounceTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (IBAction)chooseTheDepartment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chooseBtnClick:)]) {
        [self.delegate chooseBtnClick:self];
    }
    
}

@end
