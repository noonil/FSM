//
//  ProcessResult.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/18.
//  Copyright © 2015年 范传斌. All rights reserved.
//  已经处理订单处理结束相关信息

#import <Foundation/Foundation.h>

@interface ProcessResult : NSObject

@property (nonatomic,strong)NSArray *attachFiles;       //附件
@property (nonatomic,strong)NSString *handleSummary;    //处理总结
@property (nonatomic,strong)NSString *remark;           //备注
@property (nonatomic,strong)NSString *finishType;       //完成类型
@property (nonatomic,strong)NSString *legacyProblemDesc;//遗留问题描述
@property (nonatomic,strong)NSString *endTime;//实际结算时间
@property (nonatomic,strong)NSString *powerTime;//发电时长


@end
