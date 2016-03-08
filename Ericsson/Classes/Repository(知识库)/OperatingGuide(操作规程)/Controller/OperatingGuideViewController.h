//
//  OperatingGuideViewController.h
//  Ericsson
//
//  Created by 张永鹏 on 16/1/6.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandledOrderDetailController.h"
#import "HandlingOrderDetailController.h"

@interface OperatingGuideViewController : BaseViewController
/** 工单类型name */
@property (nonatomic,strong) NSString * woType;
/** 工单类型Id */
@property (nonatomic,strong) NSString * woTypeId;
/** 工单子类型name */
@property (nonatomic,strong) NSString * woChildType;
/** 工单子类型Id */
@property (nonatomic,strong) NSString * woChildTypeId;

@property (nonatomic, strong)HandlingOrderDetailController *handlingOrderDetail;
@property (nonatomic, strong)HandledOrderDetailController *handledOrderDetail;

@end
