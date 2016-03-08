//
//  HandlingOrderDetailController.h
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandlingOrderViewController.h"
#import "PopButtonsView.h"


@class HeaderView,BottomTabBar,WorkOrder;

@interface HandlingOrderDetailController : BaseViewController
@property (weak, nonatomic) IBOutlet HeaderView *HeaderView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet BottomTabBar *BottomBar;

@property (nonatomic,strong) NSString *woId; //工单id，用于查询工单详情
@property (nonatomic,assign) BOOL isGetFinishDetail; //已处理为true,正在处理为false
@property (nonatomic,strong) PopButtonsView *popButtonView;



@property (nonatomic,strong) WorkOrder *workOrder;//工单

//用于保存处理后续ViewController直接调回到此Controller
@property (nonatomic,strong)HandlingOrderViewController *rootController;
@end
