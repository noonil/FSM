//
//  handingWokerTableViewCell.m
//  Ericsson
//
//  Created by Slark on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "handingWokerTableViewCell.h"

@implementation handingWokerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:201 / 255.0f green:201 / 255.0f blue:201 / 255.0f alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
    
    
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}


- (instancetype)valueForUndefinedKey:(NSString *)key{
    
    
    return nil;
}


- (void)loadDataFromModel:(HandingWokerListModel *)model{
    
    self.firstLabel.text = model.title;
    self.SecondLabel.text = model.ruleName;
    self.thirdLabel.text = model.state;
    
    
}

- (void)loadDataFromModelone:(feedBackModel *)model{
    self.firstLabel.text = model.title;
    self.SecondLabel.text = model.ruleName;
    self.thirdLabel.text = model.time;
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
