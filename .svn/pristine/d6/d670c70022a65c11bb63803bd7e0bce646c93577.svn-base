//
//  TwoLabelHorizontalCell.m
//  Ericsson
//
//  Created by xuming on 15/12/22.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "TwoLabelHorizontalCell.h"

@implementation TwoLabelHorizontalCell

- (void)awakeFromNib {
    // Initialization code
    [self.oneLabel setTextColor:[UIColor blackColor]];
    [self.twoLabel setTextColor:[UIColor blackColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)chooseCell{
    [self.oneLabel setTextColor:[UIColor whiteColor]];
    [self.twoLabel setTextColor:[UIColor whiteColor]];
    self.backgroundColor=KBaseBlue;
}

-(void)notChooseCell{
    [self.oneLabel setTextColor:[UIColor blackColor]];
    [self.twoLabel setTextColor:[UIColor grayColor]];
    self.backgroundColor=[UIColor whiteColor];
    
}


@end
