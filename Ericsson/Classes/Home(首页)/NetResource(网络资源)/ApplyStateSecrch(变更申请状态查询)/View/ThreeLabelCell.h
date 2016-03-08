//
//  ThreeLabelCell.h
//  Ericsson
//
//  Created by xuming on 15/12/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeLabelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *resourchNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
