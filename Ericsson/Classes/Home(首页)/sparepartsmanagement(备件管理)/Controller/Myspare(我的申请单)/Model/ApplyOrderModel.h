//
//  ApplyOrderModel.h
//  Ericsson
//
//  Created by Min on 16/1/8.
//  Copyright © 2016年 范传斌. All rights reserved.

// MySpareApplyOrderList 备件申请的列表
/**
 “spareApplyId”:””,   申请单编号
 “status”:””,     申请状态
 “applyDate”:””,  申请时间
 */


#import <Foundation/Foundation.h>

@interface ApplyOrderModel : NSObject

/** 申请单编号 */
@property (nonatomic,copy) NSString * spareApplyId;
/** 申请状态 */
@property (nonatomic,copy) NSString * status;
/** 申请时间 */
@property (nonatomic,copy) NSString * applyDate;



@end
