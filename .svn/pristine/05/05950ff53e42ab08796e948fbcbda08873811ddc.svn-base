//
//  MyResourceViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "MyResourceViewCell.h"

@implementation MyResourceViewCell


- (IBAction)chooseContactOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(CellChooseContactOrderInTableView:IndexPath:)]) {
        [self.delegate CellChooseContactOrderInTableView:self.tableView IndexPath:self.indexPath];
    }
}

- (IBAction)showDetail:(id)sender {
    if (self.isFree) return;
//    NSLog(@"点击了展示详细信息页面");
    if ([self.delegate respondsToSelector:@selector(CellDetailBtnClickInTableView:IndexPath:)]) {
        [self.delegate CellDetailBtnClickInTableView:self.tableView IndexPath:self.indexPath];
    }
}

- (IBAction)switchStatus:(id)sender {
    NSLog(@"点击了切换资源状态");
//    UIButton *switchBtn = sender;
    self.isFree = !self.isFree;
    [self.delegate CellSwitchBtnClickInTableView:self.tableView IndexPath:self.indexPath State:self.isFree];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 1, rect.size.width, 1));
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
    static NSString *ID = @"MyResourceCell";
    MyResourceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (MyResourceViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyResourceViewCell" owner:nil options:nil] lastObject];
    }

    cell.isFree = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setIsFree:(BOOL)isFree{
    _isFree = isFree;
    
    if (_isFree) {
        [self.switchBtn setImage:[UIImage imageNamed:@"resource_release"] forState:UIControlStateNormal];
        //47-77-124
        [self.name setTextColor:[UIColor colorWithRed:47/255.0 green:77/255.0 blue:124/255.0 alpha:1.0]];
        [self.code setTextColor:[UIColor colorWithRed:47/255.0 green:77/255.0 blue:124/255.0 alpha:1.0]];
    }else{
        [self.switchBtn setImage:[UIImage imageNamed:@"resource_take"] forState:UIControlStateNormal];
        [self.name setTextColor:[UIColor lightGrayColor]];
        [self.code setTextColor:[UIColor lightGrayColor]];
    }
}

@end
