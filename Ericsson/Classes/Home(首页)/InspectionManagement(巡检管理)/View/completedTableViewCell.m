//
//  completedTableViewCell.m
//  Ericsson
//
//  Created by Slark on 16/1/18.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "completedTableViewCell.h"

@implementation completedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)loadDataFromModel:(completeModel *)model{
    
    int a = [model.unfinishedNum intValue];
    int b = [model.total intValue];
    
    NSString * str = [NSString stringWithFormat:@"%d/%d",a,b];
    

    [self.rightButton setTitle:str forState:UIControlStateNormal];
    
    self.leftLabel.text = model.ruleName;
    
    
    
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
