//
//  OneLabelOneTextFieldOneBtnCell.m
//  Ericsson
//
//  Created by xuming on 15/12/22.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "OneLabelOneTextFieldOneBtnCell.h"

@interface OneLabelOneTextFieldOneBtnCell ()
- (IBAction)oneButton_TouchDown:(id)sender;
- (IBAction)oneTextField_EditingDidEnd:(id)sender;


@end


@implementation OneLabelOneTextFieldOneBtnCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OneLabelOneTextFieldOneBtnCell";
    OneLabelOneTextFieldOneBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (OneLabelOneTextFieldOneBtnCell *)[[[NSBundle mainBundle] loadNibNamed:@"OneLabelOneTextFieldOneBtnCell" owner:nil options:nil] lastObject];
       // cell.oneTextField.delegate=self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)oneButton_TouchDown:(id)sender {
    if ([self.delegate respondsToSelector:@selector(OneLabelOneTextFieldOneBtnCellTouchDown:)]) {
        [self.delegate performSelector:@selector(OneLabelOneTextFieldOneBtnCellTouchDown:) withObject:self];
    }
}

- (IBAction)oneTextField_EditingDidEnd:(id)sender {
    if ([self.delegate respondsToSelector:@selector(OneLabelOneTextFieldOneBtnCell_textFieldDidEndEditing:)]) {
        [self.delegate performSelector:@selector(OneLabelOneTextFieldOneBtnCell_textFieldDidEndEditing:) withObject:self];
    }
}

#warning 这样写不行，奇怪
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//
//    if ([self.delegate respondsToSelector:@selector(OneLabelOneTextFieldOneBtnCell_textFieldDidEndEditing:)]) {
//        [self.delegate performSelector:@selector(OneLabelOneTextFieldOneBtnCell_textFieldDidEndEditing:) withObject:self];
//    }
//    
//}
@end
