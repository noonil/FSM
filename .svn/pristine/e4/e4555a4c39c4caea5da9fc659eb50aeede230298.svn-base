//
//  ListTableViewCell.m
//  Ericsson
//
//  Created by admin on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)listcellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ListTableCell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ListTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:nil options:nil] lastObject];
    }
     return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
