//
//  SearchCell.m
//  Ericsson
//
//  Created by xuming on 15/12/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "SearchCell.h"
@interface SearchCell()

@end

@implementation SearchCell

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
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}




- (IBAction)textField_EditDidBegin:(id)sender {

}



- (IBAction)textFieldBtn_TouchUpInside:(id)sender {
    
    if (self.btn.hidden ==true) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(searchCellEditDidBegin: searchCell:)]) {
        [self.delegate performSelector:@selector(searchCellEditDidBegin: searchCell:) withObject:_indexPath withObject:self];
    }
}






@end
