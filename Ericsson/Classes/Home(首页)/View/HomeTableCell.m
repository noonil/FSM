//
//  HomeTableCell.m
//  Ericsson
//
//  Created by slark on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HomeTableCell.h"

@implementation HomeTableCell


- (void)loadDataFromModel:(HomeTableCellModel *)model{
    
    if (model.id != nil) {
//        self.woTypeLabel.text = model.woType;
        self.timeLabel.text = model.time;
        self.woContentLabel.text = model.content; // 左下
        self.objectTypeLabel.text = model.title;
        
    }else {
        
    self.woTypeLabel.text = [NSString stringWithFormat:@"工单类型:%@",model.woType]; // 右下
    self.timeLabel.text = model.time;
    self.woContentLabel.text = [NSString stringWithFormat:@"维护对象类型:%@",model.objectType]; // 左下
    self.objectTypeLabel.text = model.objectName; // 左上
    }
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
