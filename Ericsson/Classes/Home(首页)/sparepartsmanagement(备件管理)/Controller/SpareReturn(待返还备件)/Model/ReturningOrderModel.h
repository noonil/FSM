//
//  ReturningOrderModel.h
//  Ericsson
//
//  Created by Min on 16/1/9.
//  Copyright © 2016年 范传斌. All rights reserved.

//  获取我待返还的工单信息  spareApplyList
/*
 
 “storeRoomId”:””,
 “spareApplyId”:””,   申请单编号
 “woId”:””,     工单id
 “appliedDate ”:””,   申请日期
 “storeRoomName”:””    仓库名称
 */

#import <Foundation/Foundation.h>

@interface ReturningOrderModel : NSObject

/** "" */
@property (nonatomic,copy) NSString * storeRoomId;
/** 申请单编号 */
@property (nonatomic,copy) NSString * spareApplyId;
/** 工单id */
@property (nonatomic,copy) NSString * woId;
/** 申请时间 */
@property (nonatomic,copy) NSString * appliedDate;
/** 仓库名称 */
@property (nonatomic,copy) NSString * storeRoomName;
@end
