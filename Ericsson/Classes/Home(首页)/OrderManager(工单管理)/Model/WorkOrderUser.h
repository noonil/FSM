//
//  WorkOrderUser.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkOrderUser : NSObject

//人员id
@property (nonatomic,strong)NSString *id;
//人员姓名
@property (nonatomic,strong)NSString *name;
//正在做的工作
@property (nonatomic,strong)NSString *skill;
//状态（0 蓝色代表闲（无其他工单），1红色代表有故障工单，2黄色代表有非故障类工单）
@property (nonatomic,strong)NSString *state;

@end
