//
//  ContactOrderViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ContactOrderViewCell.h"

@implementation ContactOrderViewCell

- (IBAction)doneClick:(id)sender {
    if (self.switchFlag) {
        self.doneBtn.selected = !self.doneBtn.selected;
    }
    
    if ([self.delegate respondsToSelector:@selector(CellChooseClickInTableView:IndexPath:)]) {
        [self.delegate CellChooseClickInTableView:self.tableView IndexPath:self.indexPath];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ContactOrderCell";
    ContactOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ContactOrderViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ContactOrderViewCell" owner:nil options:nil] lastObject];
    }
    
//    cell.chooseFlag = false;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
