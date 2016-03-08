//
//  TwoButtonCell.m
//  Ericsson
//
//  Created by xuming on 15/12/23.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "TwoButtonCell.h"

@implementation TwoButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TwoButtonCell";
    TwoButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TwoButtonCell *)[[[NSBundle mainBundle] loadNibNamed:@"TwoButtonCell" owner:nil options:nil] lastObject];
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//拍照
- (IBAction)oneButton_TouchDown:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(twoButtonCell_firstButton_touchUpInside)]) {
        [self.delegate performSelector:@selector(twoButtonCell_firstButton_touchUpInside)];
    }

}


//选择图片
- (IBAction)twoButton_TouchDown:(id)sender {
    if ([self.delegate respondsToSelector:@selector(twoButtonCell_secondButton_touchUpInside)]) {
        [self.delegate performSelector:@selector(twoButtonCell_secondButton_touchUpInside)];
    }
}




@end


