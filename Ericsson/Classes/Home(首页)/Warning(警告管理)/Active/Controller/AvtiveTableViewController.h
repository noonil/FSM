//
//  AvtiveTableViewController.h
//  Ericsson
//
//  Created by admin on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandledOrderDetailController.h"
#import "HandlingOrderDetailController.h"
#import "HandingDetailViewController.h"
#import "completeDetailViewController.h"

@interface AvtiveTableViewController : UITableViewController

@property (nonatomic, copy) NSString *name;             //网元名称
@property (nonatomic, copy) NSString *alertTitle;       //告警标题

/** 维护对象ID  对应于工单中的 mObjectTypeId 字段*/
@property (nonatomic,copy) NSString * maintenanceType_Id;
/**  维护对象类型ID  maintenanceObjectId */
@property (nonatomic,copy) NSString * maintenance_Id;

@property (nonatomic, strong)HandlingOrderDetailController *handlingOrderDetail;
@property (nonatomic, strong)HandledOrderDetailController *handledOrderDetail;
@property (strong ,nonatomic) HandingDetailViewController * handlingDetail;
@property (strong ,nonatomic) completeDetailViewController * completeDetail;
@end
