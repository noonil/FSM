//
//  HandledOrderCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandledOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
