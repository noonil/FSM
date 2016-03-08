//
//  TwoLabelOneImgCell.m
//  Ericsson
//
//  Created by xuming on 15/12/16.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "TwoLabelOneImgCell.h"

@implementation TwoLabelOneImgCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype )cellWithTableView:(UITableView *)tableView{
    static NSString *idd=@"cell";
    TwoLabelOneImgCell *cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=(TwoLabelOneImgCell *)[[[NSBundle mainBundle] loadNibNamed:@"TwoLabelOneImgCell" owner:nil options:nil] lastObject];
    }
    return cell;

}



@end
