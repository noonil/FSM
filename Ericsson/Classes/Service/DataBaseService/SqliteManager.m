//
//  SqliteManager.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "SqliteManager.h"
#import "FMDatabase.h"

@implementation SqliteManager

+ (instancetype)shareManager
{
    static SqliteManager *sharedSqliteManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSqliteManagerInstance = [[self alloc] init];
        sharedSqliteManagerInstance.maintenanceObjectTypeTableName = @"maintenanceObjectTypes";// 维护对象类型表名
        sharedSqliteManagerInstance.spareTypeTableName = @"spareTypes";// 备件类型
        sharedSqliteManagerInstance.spareFactoryTableName = @"spareFactories";// 备件厂商列表
        sharedSqliteManagerInstance.consumableVerdorTableName = @"consumableVerdor";// 耗材厂商列表
        sharedSqliteManagerInstance.startLaterReasonTableName = @"startLaterReasons";// 稍后出发原因表名
        sharedSqliteManagerInstance.woRejectReasonTableName = @"woRejectReasons";// 工单拒收原因表名
        sharedSqliteManagerInstance.factoryTableName = @"techFactories";// 技术手册查询中的厂家表
        sharedSqliteManagerInstance.gatherObjectType = @"gatherObjectType";// 资源采集字段表
        sharedSqliteManagerInstance.allObjectPropertyValues = @"allObjectPropertyValues";
        sharedSqliteManagerInstance.techTypeTableName = @"techTypes";// 技术手册查询中的类型表
        sharedSqliteManagerInstance.techModelTableName = @"techModels";// 技术手册查询中的型号表
        sharedSqliteManagerInstance.resourceTypeTableName = @"resTypes";// 资源查找时的资源类型表
        sharedSqliteManagerInstance.attachTypeTableName = @"attachTypes";// 资源查找时的资源类型表
        
        sharedSqliteManagerInstance.applySubjectTableName = @"applySubject";// 费用查询中的申请科目信息表
        
        sharedSqliteManagerInstance.organizationTableName = @"organization";// 组织机构表
        sharedSqliteManagerInstance.synTableName = @"syn";// 同步管理类表(id,tableName,lastSynIndex)
        sharedSqliteManagerInstance.attachTableName = @"attach";// 附件上传表名
        sharedSqliteManagerInstance.uploadLogTableName = @"uploadlog";// 附件上传日志表
        sharedSqliteManagerInstance.synTimeTableName = @"synTime";
        sharedSqliteManagerInstance.operateItemTableName = @"woOperateItem";// 工单操作项
        sharedSqliteManagerInstance.spareApplyTableName = @"woLinkedSpareApply";// 关联工单的备件申请表
        sharedSqliteManagerInstance.spareInfoTableName = @"woLinkedSpareInfo";// 关联工单的备件信息表
        sharedSqliteManagerInstance.woOperItemAttachTmp = @"woOperItemAttachTmp";// 工单操作项临时附件表
        sharedSqliteManagerInstance.alertInfoTableName = @"alertInfoTableName";
    });
    return sharedSqliteManagerInstance;
}


/****************************************
 * 创建数据表
 *
 * @param tableName
 *            : 数据表的名称
 * @param tableFields
 *            ： 表的字段名称
 ****************************************/
- (void)createTableWithTableName:(NSString *)tableName talbeFields:(NSString *)tableFields{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if ([db open]) {
        // create it
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE if not exists '%@'(%@)",tableName,tableFields];
        
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"succ to creating db table");
        }
        [db close];
    }
}


/****************************************
 * 向数据表中，插入数据
 * @param tableName
 *            : 数据表的名称
 * @param columns
 *            ： 插入的字段名称
 * @param values
 *            ： 字段值数组
 */

- (void)insertTableWithTableName:(NSString *)tableName Column:(NSString *)columns Values:(NSString *)values{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values(%@)",tableName,columns,values];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
    }
}

/****************************************
 * 更新数据表中数据
 * @param tableName
 *            : 数据表的名称
 * @param values
 *            ： 新的数据值
 * @param whereClause
 *            ： 更新的条件
 */

- (void)updateTableWithTableName:(NSString *)tableName Values:(NSString *)values WhereClause:(NSString *)whereClause;{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ set %@ where %@",tableName,values,whereClause];
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        [db close];
    }
}

/****************************************
 * 清除表数据
 * @param tableName
 *            : 数据表的名称
 */

- (void)ClearTableWithTableName:(NSString *)tableName{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@",tableName];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to delete db data");
        } else {
            NSLog(@"succ to deleta db data");
        }
        [db close];
    }
}

@end
