//
//  ListTableViewCell.h
//  Ericsson
//
//  Created by admin on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *genre;
@property (weak, nonatomic) IBOutlet UILabel *timecontent;

+ (instancetype)listcellWithTableView:(UITableView *)tableView;
@end
