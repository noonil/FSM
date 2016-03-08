//
//  SqliteManager.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface SqliteManager : NSObject
@property (nonatomic,strong)NSString *maintenanceObjectTypeTableName;// 维护对象类型表名
@property (nonatomic,strong)NSString *spareTypeTableName;// 备件类型
@property (nonatomic,strong)NSString *spareFactoryTableName;// 备件厂商列表
@property (nonatomic,strong)NSString *consumableVerdorTableName;// 耗材厂商列表
@property (nonatomic,strong)NSString *startLaterReasonTableName;// 稍后出发原因表名
@property (nonatomic,strong)NSString *woRejectReasonTableName;// 工单拒收原因表名
@property (nonatomic,strong)NSString *factoryTableName;// 技术手册查询中的厂家表
@property (nonatomic,strong)NSString *gatherObjectType;// 资源采集字段表
@property (nonatomic,strong)NSString *allObjectPropertyValues;
@property (nonatomic,strong)NSString *techTypeTableName;// 技术手册查询中的类型表
@property (nonatomic,strong)NSString *techModelTableName;// 技术手册查询中的型号表
@property (nonatomic,strong)NSString *resourceTypeTableName;// 资源查找时的资源类型表
@property (nonatomic,strong)NSString *attachTypeTableName;// 资源查找时的资源类型表

@property (nonatomic,strong)NSString *applySubjectTableName;// 费用查询中的申请科目信息表
@property (nonatomic,strong)NSString *organizationTableName;// 组织机构表
@property (nonatomic,strong)NSString *synTableName;// 同步管理类表(id,tableName,lastSynIndex)
@property (nonatomic,strong)NSString *attachTableName;// 附件上传表名
@property (nonatomic,strong)NSString *uploadLogTableName;// 附件上传日志表
@property (nonatomic,strong)NSString *synTimeTableName;
@property (nonatomic,strong)NSString *operateItemTableName;// 工单操作项
@property (nonatomic,strong)NSString *spareApplyTableName;// 关联工单的备件申请表
@property (nonatomic,strong)NSString *spareInfoTableName;// 关联工单的备件信息表
@property (nonatomic,strong)NSString *woOperItemAttachTmp;// 工单操作项临时附件表
@property (nonatomic,strong)NSString *alertInfoTableName;


+ (instancetype)shareManager;

- (void)createTableWithTableName:(NSString *)tableName talbeFields:(NSString *)tableFields;

- (void)insertTableWithTableName:(NSString *)tableName Column:(NSString *)columns Values:(NSString *)values;

- (void)updateTableWithTableName:(NSString *)tableName ContentValues:(NSString *)values;

- (void)ClearTableWithTableName:(NSString *)tableName;
@end
