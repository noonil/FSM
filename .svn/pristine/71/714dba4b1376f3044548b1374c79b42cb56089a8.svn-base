//
//  TroubleResultViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//  故障类工单处理结束操作

#import <UIKit/UIKit.h>
#import "HandlingOrderViewController.h"
#import "ElectricTime.h"

@class WorkOrder,WorkOrderStep,WorkOrderDetail;

@interface TroubleResultViewController : BaseViewController

@property (nonatomic,strong)WorkOrderDetail *workOrderDetail;
@property (nonatomic,strong)WorkOrder *workOrder;       //工单
@property (nonatomic,strong)WorkOrderStep *currentStep; //当前步骤
@property (nonatomic,strong)ElectricTime *electricTime; //开始发电时间，结束发电时间


//用于保存处理后续ViewController直接调回到此Controller
@property (nonatomic,strong)HandlingOrderViewController *rootController;

@end
