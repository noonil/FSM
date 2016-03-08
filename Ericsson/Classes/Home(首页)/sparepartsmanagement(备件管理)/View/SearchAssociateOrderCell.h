//
//  SearchAssociateOrderCell.h
//  Ericsson
//
//  Created by Min on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchAssociateOrderCell : UITableViewCell
/** 工单名称 */
@property (weak, nonatomic) IBOutlet UILabel *woNameLabel;
/** 结束时间 */
@property (weak, nonatomic) IBOutlet UILabel *preEndTimeLabel;

+ (instancetype)cellWithTableView:(UITableView*)tableView;
@end
