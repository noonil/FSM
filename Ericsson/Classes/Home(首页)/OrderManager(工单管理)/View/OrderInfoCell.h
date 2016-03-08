//
//  OrderInfoCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkOrderBaseInfo,WorkOrderBaseInfoFrame;

@interface OrderInfoCell : UITableViewCell


@property (nonatomic,strong)WorkOrderBaseInfoFrame *workOrderBaseInfoFrame;
@property (nonatomic,strong)WorkOrderBaseInfo *workOrderBaseInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
