//
//  ResourceInfoCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *resourceOwner;
@property (weak, nonatomic) IBOutlet UILabel *resourceOrder;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
