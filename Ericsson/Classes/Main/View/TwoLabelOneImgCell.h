//
//  TwoLabelOneImgCell.h
//  Ericsson
//
//  Created by xuming on 15/12/16.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLabelOneImgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
+(instancetype )cellWithTableView:(UITableView *)tableView;

@end
