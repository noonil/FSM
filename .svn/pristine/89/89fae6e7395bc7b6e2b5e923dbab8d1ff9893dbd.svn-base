//
//  OneButtonCell.m
//  Ericsson
//
//  Created by xuming on 15/12/23.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "OneButtonCell.h"

@implementation OneButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)button_TouchDown:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnToSetupCoordinateOrWithCell:)]) {
        [self.delegate clickBtnToSetupCoordinateOrWithCell:self];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OneButtonCell";
    OneButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (OneButtonCell *)[[[NSBundle mainBundle] loadNibNamed:@"OneButtonCell" owner:nil options:nil] lastObject];
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
