//
//  WorkOrderOilMachine.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//  油机信息(只有在发电工单的时候才会显示)

#import <Foundation/Foundation.h>

@interface WorkOrderOilMachine : NSObject

// 油机id
@property (nonatomic,strong)NSString *resourceId;
//厂商
@property (nonatomic,strong)NSString *vendor;
//油机编号
@property (nonatomic,strong)NSString *resSerial;
//油机功率
@property (nonatomic,strong)NSString *power;
//油机型号
@property (nonatomic,strong)NSString *oil_model;

@end
