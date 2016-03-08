//
//  WithWorkResultViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//  巡检类处理结束主界面

#import <UIKit/UIKit.h>
#import "HandlingOrderViewController.h"

@class WorkOrder,WorkOrderStep;

@interface WithWorkResultViewController : BaseViewController

@property (nonatomic,strong)WorkOrder *workOrder;       //工单
@property (nonatomic,strong)WorkOrderStep *currentStep; //当前步骤

//用于保存处理后续ViewController直接调回到此Controller
@property (nonatomic,strong)HandlingOrderViewController *rootController;
@end
