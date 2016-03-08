//
//  HandledOrderDetailController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopButtonsView.h"

@class HeaderView,WorkOrder;

@interface HandledOrderDetailController : BaseViewController
@property (weak, nonatomic) IBOutlet HeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic,strong) NSString *woId; //工单id，用于查询工单详情
@property (nonatomic,assign) BOOL isGetFinishDetail; //已处理为true,正在处理为false

@property (nonatomic,strong)WorkOrder *workOrder;//工单
@property (nonatomic,strong) PopButtonsView *popButtonView;


@end
