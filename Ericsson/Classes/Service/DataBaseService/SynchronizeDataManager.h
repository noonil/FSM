//
//  SynchronizeDataManager.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/17.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SynchronizeDataManager : NSObject

+ (instancetype)shareManager;

//同步数据库的检查。
- (void)DBCheck;


//更新syn表相关本地数据库表数据更新情况
- (void)updateTableTime:(NSString *)tableName TableLastUpdateTime:(NSString *)tableLastUpdateTime;

//同步资源类型接口
- (void)synchronizeResType:(NSArray *)resTypeList;
//同步维护对象类型
- (void)synchronizeMOType:(NSArray *)mObjectTypeList;
//
- (void)synchronizeAttachType:(NSArray *)attachTypeList;
//同步拒收工单原因
- (void)synchronizeWORejectReason:(NSArray *)rejectReasonList;
//同步稍后出发原因列表
- (void)synchronizeWOStartLaterReason:(NSArray *)startLaterReasonList;
//同步技术手册类型
- (void)synchronizeTechType:(NSArray *)techTypeList;
//同步技术手册厂商
- (void)synchronizeTechFactory:(NSArray *)techFactoryList;
//同步字段表
- (void)synchronizeGatherObjectType:(NSArray *)gatherObjectTypeList;
//同步资源采集缓存数据
- (void)synchronizeAllObjectPropertyValues:(NSArray *)allObjectPropertyValues;
//同步技术手册型号
- (void)synchronizeTechModel:(NSArray *)techModelList;
//同步备件模块 备件查询条件中的厂商
- (void)synchronizeSpareFactory:(NSArray *)spareFactoryList;
//
- (void)synchronizeConsumableVerdor:(NSArray *)consumableVerdorList;
//同步备件模块 备件查询条件中的所属专业
- (void)synchronizeSpareType:(NSArray *)spareTypeList;

@end
