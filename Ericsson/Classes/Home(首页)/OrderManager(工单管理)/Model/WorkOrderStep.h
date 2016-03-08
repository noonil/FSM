//
//  WorkOrderStep.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//  工步骤列表

#import <Foundation/Foundation.h>

@interface WorkOrderStep : NSObject

@property (nonatomic,strong)NSString *taskName;
//工单的操作步骤名字
@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *taskId;

//该操作步骤是否已经完成
@property (nonatomic,assign)BOOL finish;

//操作步骤的id
@property (nonatomic,strong)NSString *id;

@end

