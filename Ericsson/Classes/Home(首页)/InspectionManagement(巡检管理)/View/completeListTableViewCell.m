//
//  completeListTableViewCell.m
//  Ericsson
//
//  Created by Slark on 16/1/18.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "completeListTableViewCell.h"

@implementation completeListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadDataFromModel:(completeListModel *)model{
    
    self.leftLabel.text = model.title;
    self.rightLabel.text = model.time;
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
