//
//  ThreeLabelOneImgCell.m
//  Ericsson
//
//  Created by xuming on 15/12/17.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ThreeLabelOneImgCell.h"

@implementation ThreeLabelOneImgCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(instancetype )cellWithTableView:(UITableView *)tableView{
    static NSString *idd=@"cell";
    ThreeLabelOneImgCell *cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=(ThreeLabelOneImgCell *)[[[NSBundle mainBundle] loadNibNamed:@"ThreeLabelOneImgCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}
@end
