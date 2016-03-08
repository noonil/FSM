//
//  UnAcceptedOrderAtSameTeamViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//  同组待受理工单主界面

#import <UIKit/UIKit.h>

@class HeaderView,WorkOrder;

@interface UnAcceptedOrderAtSameTeamViewController : BaseViewController
@property (weak, nonatomic) IBOutlet HeaderView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
