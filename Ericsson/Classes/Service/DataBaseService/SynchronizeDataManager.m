//
//  SynchronizeDataManager.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/17.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "SynchronizeDataManager.h"
#import "SqliteManager.h"

@implementation SynchronizeDataManager

+ (instancetype)shareManager
{
    static SynchronizeDataManager *sharedSynchronizeDataManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSynchronizeDataManagerInstance = [[self alloc] init];
    });
    
    return sharedSynchronizeDataManagerInstance;
}


#pragma mark - 同步数据库

- (void)DBCheck
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentDBVersion = [defaults objectForKey:@"dbVersion"];
    
    if (currentDBVersion == nil) {
        //初次安装登陆进行数据库建表操作
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:DBPATH] == NO){
            //创建数据库的目录/db/**.db
            [[LKDBHelper alloc]init];

            [self createOhterTables];
        }
        //保存初始数据库版本到沙盒供后续数据库版本比对
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%d",DBVERSION] forKey:@"dbVersion"];
        [defaults synchronize];
        
        [self syncOrgnaizeTable];
        
        [self syncOtherTables];
        
        
    }else if (DBVERSION > [currentDBVersion intValue]){
        //表示有数据库更新
        [self dbUpdate:DBVERSION];
    }
    

}


/*
 同步组织机构数据
 */
-(void)syncOrgnaizeTable{


    NSDictionary *params = @{@"userId":KUserId};
    
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMBase" methodName:@"FSMGetOrgData" sessonId:KSessionId requestData:params];

    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"] isEqual:@"-1"]) {
            // [self.view makeToast:@"请求失败"];
            
            NSLog(@"数据库请求失败");
            return ;
        }
        
        //[self.view makeToast:@"数据库更新成功"];
        NSLog(@"数据库更新成功");
        [self createOrgnizeTable];
        
        NSArray *data = dic[@"orgList"];
        
        [self syncOrgnaizeData:data];
        
        
        
    } falure:^(NSError *err) {
        NSLog(@"error:%@",err);
    }];


}
-(void)syncOtherTables{
    
    //每次登陆系统加载相关同步数据（更新频率低），避免频繁发送请求获取
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *lastUpdateTime = [defaults objectForKey:@"lastUpdateTime"];
    //表数据更新请求≥
    NSDictionary *params = @{@"lastUpdateTime":(lastUpdateTime == nil) ? @"" : lastUpdateTime,@"synTableInfos":[self querySyncTable]};
    
    NSString *modelName=@"FSMBase";
    NSString *methodName=@"synBaseData";
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:KSessionId requestData:params];
    // NSLog(@"sopeStr:%@",sopeStr);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"document-- %@",[paths lastObject]);
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"] isEqual:@"-1"]) {
           // [self.view makeToast:@"请求失败"];
            
            NSLog(@"数据库请求失败");
            return ;
        }
        
        //[self.view makeToast:@"数据库更新成功"];
        NSLog(@"数据库更新成功");

        if (YES) {
            //更新本地更新时间
            //请求数据示例
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dic[@"time"] forKey:@"lastUpdateTime"];
            
            //更新syn表相关表更新情况
            SynchronizeDataManager *synMgr = [SynchronizeDataManager shareManager];
            NSArray *needUpdateTableInfo = dic[@"needUpdateTableInfo"];
            if (needUpdateTableInfo != nil && needUpdateTableInfo.count > 0) {
                for (int i = 0; i < needUpdateTableInfo.count; i++) {
                    NSDictionary *updateTableInfo = needUpdateTableInfo[i];
                    [synMgr updateTableTime:updateTableInfo[@"tableName"] TableLastUpdateTime:updateTableInfo[@"tableLastUpdateTime"]];
                }
            }
            
            //更新需要更新的相关数据表
            NSArray *needUpdateData = dic[@"needUpdateData"];
            if (needUpdateData != nil && needUpdateData.count > 0) {
                for (int i = 0; i < needUpdateData.count; i++) {
                    NSDictionary *updateData = needUpdateData[i];
                    NSString *tableName = updateData[@"tableName"];
                    NSArray *data = updateData[@"data"];
                    
                    //同步拒收原因
                    if ([tableName isEqualToString:@"woRejectReasons"]) {
                        [synMgr synchronizeWORejectReason:data];
                    }else if ([tableName isEqualToString:@"startLaterReasons"]) {
                        //同步稍后出发原因
                        [synMgr synchronizeWOStartLaterReason:data];
                    }else if ([tableName isEqualToString:@"techFactories"]) {
                        //同步技术手册中的厂商列表
                        [synMgr synchronizeTechFactory:data];
                    }else if ([tableName isEqualToString:@"techTypes"]) {
                        //同步技术手册中的类型列表
                        [synMgr synchronizeTechType:data];
                    }else if ([tableName isEqualToString:@"techModels"]) {
                        //同步技术手册中的型号列表
                        [synMgr synchronizeTechModel:data];
                    }else if ([tableName isEqualToString:@"resTypes"]) {
                        //同步资源类型列表
                        [synMgr synchronizeResType:data];
                    }else if ([tableName isEqualToString:@"maintenanceObjectTypes"]) {
                        //同步维护对象类型
                        [synMgr synchronizeMOType:data];
                    }else if ([tableName isEqualToString:@"attachTypes"]) {
                        //同步附件类型
                        [synMgr synchronizeAttachType:data];
                    }else if ([tableName isEqualToString:@"spareTypes"]) {
                        //同步备件类别（所属专业）
                        [synMgr synchronizeSpareType:data];
                    }else if ([tableName isEqualToString:@"spareFactories"]) {
                        //同步备件厂商
                        [synMgr synchronizeSpareFactory:data];
                    }else if ([tableName isEqualToString:@"consumableVerdor"]) {
                        [synMgr synchronizeConsumableVerdor:data];
                    }else if ([tableName isEqualToString:@"gatherObjectType"]) {
                        //资源采集字段
                        [synMgr synchronizeGatherObjectType:data];
                    }else if ([tableName isEqualToString:@"allObjectPropertyValues"]) {
                        //资源采集缓存数据
                        [synMgr synchronizeAllObjectPropertyValues:data];
                    }
                }
            }
            
        }
    } falure:^(NSError *err) {
        NSLog(@"error:%@",err);
    }];
    
}

- (void)dbUpdate:(int)version
{
    //以后数据库版本更新操作实现于此
    switch (version) {
        case 1:
            break;
        default:
            break;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d",DBVERSION] forKey:@"dbVersion"];
    [defaults synchronize];
}

//新建组织机构表
- (void)createOrgnizeTable{
    SqliteManager *sqliteMgr = [SqliteManager shareManager];
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if (db.open) {
            [sqliteMgr createTableWithTableName:@"organization" talbeFields:@"'orgId' TEXT, 'orgName' TEXT, 'paraentOrgId' TEXT"];
        [db close];
    }

}

//新建数据库其他表
- (void)createOhterTables{
    //注：每次版本更新有设计表结构改动等操作，请在此处连带修改
    SqliteManager *sqliteMgr = [SqliteManager shareManager];
    
    //
    //    #define DBPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/db/ericsson.db"]
    //
    //    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
    //    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    //    NSAssert(bo,@"创建目录失败");
    
    
    
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if (db.open) {
        [sqliteMgr createTableWithTableName:@"alertInfoTableName" talbeFields:@"'id' BIGINT,'name' TEXT,'level' TEXT,'time' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"allObjectPropertyValues" talbeFields:@"'type' TEXT,'value' TEXT,'name' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"applySubject" talbeFields:@"'subjectName' TEXT,'subjectValue' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"attach" talbeFields:@"'id' BIGINT,'mainType' TEXT,'mainRecId' TEXT,'attachSpec' INTEGER,'fileTitle' TEXT,'attachType' TEXT,'fileType' TEXT,'fileName' TEXT,'filePath' TEXT,'attachGroupId' TEXT,'tableName' TEXT,'serverSavedFileName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"attachTypes" talbeFields:@"'attachTypeId' TEXT, 'attachTypeName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"consumableVerdor" talbeFields:@"'consumableVendor' TEXT,'consumableType' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"gatherObjectType" talbeFields:@"'maintenanceTypeName' TEXT,'maintenanceTypeId' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"maintenanceObjectTypes" talbeFields:@"'maintenanceTypeId' TEXT,'maintenanceTypeName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"myDraft" talbeFields:@"'title' TEXT, 'content' TEXT, 'name' TEXT, 'departName' TEXT, 'time' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"resTypes" talbeFields:@"'resourceTypeId' TEXT, 'resourceTypeName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"spareFactories" talbeFields:@"'spareFactoryName' TEXT,'spareTypeName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"spareTypes" talbeFields:@"'spareTypeName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"startLaterReasons" talbeFields:@"'reasonId' TEXT,'reasonName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"syn" talbeFields:@"'tableName' TEXT,'tableLastUpdateTime' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"techFactories" talbeFields:@"'record_id' TEXT, 'factory' TEXT, 'typeId' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"techModels" talbeFields:@"'record_id' TEXT, 'model' TEXT, 'factoryId' TEXT, 'typeId' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"techTypes" talbeFields:@"'typeId' TEXT, 'typeName' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"uploadlog" talbeFields:@"'uploadfilepath' TEXT,'sourceid' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"userLocation" talbeFields:@"'userID' TEXT, 'latitude' TEXT, 'longitude' TEXT, 'accuracy' TEXT, 'uploadTime' TEXT, 'uploadFlag' INTEGER"];
        
        [sqliteMgr createTableWithTableName:@"woLinkedSpareApply" talbeFields:@"'id' TEXT,'storeRoomId' TEXT, 'storeRoomName' TEXT, 'applyReason' TEXT,'destination' TEXT,'applier' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"woLinkedSpareInfo" talbeFields:@"'spareId' TEXT, 'spareName' TEXT, 'storeRoomId' TEXT, 'storeRoomName' TEXT, 'applyNumber' TEXT,'applier' TEXT,'spareModel' TEXT, 'consumableVerdor' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"woOperateItem" talbeFields:@"'id' BIGINT,'woId' TEXT,'operateId' TEXT,'time' TEXT,'remark' TEXT,'option' TEXT,'qrType' TEXT,'operateItemState' TEXT,'abnormalDesc' TEXT,'getFromServer' TEXT,'allOptions' TEXT,'desInfoId' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"woOperItemAttachTmp" talbeFields:@"'woOperId' TEXT, 'attachId' TEXT,'fileTitle' TEXT,'attachType' TEXT,'fileType' TEXT,'fileName' TEXT,'filePath' TEXT,'upload' TEXT,'del' TEXT,'desc' TEXT,'applier' TEXT"];
        
        [sqliteMgr createTableWithTableName:@"woRejectReasons" talbeFields:@"'reasonId' TEXT,'reasonName' TEXT"];
        
        [db close];
    }
    
}

- (void)initSqliteData{
    SqliteManager *sqliteMgr = [SqliteManager shareManager];
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if (db.open) {
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'woRejectReasons','0'"];
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'startLaterReasons','0'"];
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'techFactories','0'"];
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'applySubject','0'"];
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'allObjectPropertyValues','0'"];
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'resTypes','0'"];
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'organization','0'"];
        [sqliteMgr insertTableWithTableName:@"syn" Column:@"'tableName','tableLastUpdateTime'" Values:@"'gatherObjectType','0'"];
        [db close];
    }
}

- (NSMutableArray *)querySyncTable{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    NSMutableArray *syncTables = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        NSString * sql = @"select * from syn";
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            NSString * tableName = [rs stringForColumn:@"tableName"];
            NSString * tableLastUpdateTime = [rs stringForColumn:@"tableLastUpdateTime"];
            [syncTables addObject:@{@"tableName":tableName,@"tableLastUpdateTime":tableLastUpdateTime}];
        }
        [db close];
    }
    return syncTables;
}


#pragma mark -


//更新syn表相关本地数据库表数据更新情况
- (void)updateTableTime:(NSString *)tableName TableLastUpdateTime:(NSString *)tableLastUpdateTime
{
    SqliteManager *sqliteMgr = [SqliteManager shareManager];
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select count(*) count from %@ where tableName = %@",sqliteMgr.synTableName,tableName];        FMResultSet * rs = [db executeQuery:sql];
        int count = 0;
        while ([rs next]) {
            count = [rs intForColumn:@"count"];
        }
        
        if (count == 0) {
            [sqliteMgr insertTableWithTableName:sqliteMgr.synTableName Column:@"'tableName','tableLastUpdateTime'" Values:[NSString stringWithFormat:@"'%@','%@'",tableName,tableLastUpdateTime]];
        }else{
            NSString *updateSql = [[NSString alloc] initWithFormat:@"UPDATE %@ SET 'tableLastUpdateTime' = '%@' where 'tableName' = %@",sqliteMgr.synTableName,tableLastUpdateTime,tableName];
            
            BOOL res = [db executeUpdate:updateSql];
            if (!res) {
                NSLog(@"error when update db table");
            } else {
                NSLog(@"success to update db table");
            }
        }
        
        [db close];
    }
    
}


#pragma mark 同步数据库

//同步资源类型接口
- (void)synchronizeResType:(NSArray *)resTypeList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (resTypeList != nil && resTypeList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.resourceTypeTableName];
        for (int i = 0; i < resTypeList.count; i++) {
            NSDictionary *resType = resTypeList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.resourceTypeTableName Column:[NSString stringWithFormat:@"'resourceTypeId','resourceTypeName'"] Values:[NSString stringWithFormat:@"'%@','%@'",resType[@"resourceTypeId"],resType[@"resourceTypeName"]]];
        }
    }
}


//同步维护对象类型
- (void)synchronizeMOType:(NSArray *)mObjectTypeList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (mObjectTypeList != nil && mObjectTypeList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.maintenanceObjectTypeTableName];
        for (int i = 0; i < mObjectTypeList.count; i++) {
            NSDictionary *mObjectType = mObjectTypeList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.maintenanceObjectTypeTableName Column:[NSString stringWithFormat:@"'maintenanceTypeId','maintenanceTypeName'"] Values:[NSString stringWithFormat:@"'%@','%@'",mObjectType[@"maintenanceTypeId"],mObjectType[@"maintenanceTypeName"]]];
        }
    }
}

- (void)synchronizeAttachType:(NSArray *)attachTypeList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (attachTypeList != nil && attachTypeList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.attachTypeTableName];
        for (int i = 0; i < attachTypeList.count; i++) {
            NSDictionary *attachType = attachTypeList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.attachTypeTableName Column:[NSString stringWithFormat:@"'attachTypeId','attachTypeName'"] Values:[NSString stringWithFormat:@"'%@','%@'",attachType[@"attachTypeId"],attachType[@"attachTypeName"]]];
        }
    }
}


//同步拒收工单原因
- (void)synchronizeWORejectReason:(NSArray *)rejectReasonList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (rejectReasonList != nil && rejectReasonList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.woRejectReasonTableName];
        for (int i = 0; i < rejectReasonList.count; i++) {
            NSDictionary *rejectReason = rejectReasonList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.woRejectReasonTableName Column:[NSString stringWithFormat:@"'reasonId','reasonName'"] Values:[NSString stringWithFormat:@"'%@','%@'",rejectReason[@"reasonId"],rejectReason[@"reasonName"]]];
        }
    }
}

//同步稍后出发原因列表
- (void)synchronizeWOStartLaterReason:(NSArray *)startLaterReasonList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (startLaterReasonList != nil && startLaterReasonList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.startLaterReasonTableName];
        for (int i = 0; i < startLaterReasonList.count; i++) {
            NSDictionary *startLaterReason = startLaterReasonList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.startLaterReasonTableName Column:[NSString stringWithFormat:@"'reasonId','reasonName'"] Values:[NSString stringWithFormat:@"'%@','%@'",startLaterReason[@"reasonId"],startLaterReason[@"reasonName"]]];
        }
    }

}

//同步技术手册类型
- (void)synchronizeTechType:(NSArray *)techTypeList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (techTypeList != nil && techTypeList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.techTypeTableName];
        for (int i = 0; i < techTypeList.count; i++) {
            NSDictionary *techType = techTypeList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.techTypeTableName Column:[NSString stringWithFormat:@"'typeId','typeName'"] Values:[NSString stringWithFormat:@"'%@','%@'",techType[@"typeId"],techType[@"typeName"]]];
        }
    }
}

//同步技术手册厂商
- (void)synchronizeTechFactory:(NSArray *)techFactoryList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (techFactoryList != nil && techFactoryList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.factoryTableName];
        for (int i = 0; i < techFactoryList.count; i++) {
            NSDictionary *techFactory = techFactoryList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.factoryTableName Column:[NSString stringWithFormat:@"'record_id','factory','typeId'"] Values:[NSString stringWithFormat:@"'%@','%@','%@'",techFactory[@"record_id"],techFactory[@"factory"],techFactory[@"typeId"]]];
        }
    }
}

//同步字段表
- (void)synchronizeGatherObjectType:(NSArray *)gatherObjectTypeList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (gatherObjectTypeList != nil && gatherObjectTypeList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.gatherObjectType];
        for (int i = 0; i < gatherObjectTypeList.count; i++) {
            NSDictionary *gatherObjectType = gatherObjectTypeList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.gatherObjectType Column:[NSString stringWithFormat:@"'maintenanceTypeId','maintenanceTypeName'"] Values:[NSString stringWithFormat:@"'%@','%@'",gatherObjectType[@"maintenanceTypeId"],gatherObjectType[@"maintenanceTypeName"]]];
        }
    }
}

//同步资源采集缓存数据
- (void)synchronizeAllObjectPropertyValues:(NSArray *)allObjectPropertyValues
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (allObjectPropertyValues != nil && allObjectPropertyValues.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.allObjectPropertyValues];
        for (int i = 0; i < allObjectPropertyValues.count; i++) {
            NSDictionary *data = allObjectPropertyValues[i];
            [sqliteManager insertTableWithTableName:sqliteManager.allObjectPropertyValues Column:[NSString stringWithFormat:@"'type','name','value'"] Values:[NSString stringWithFormat:@"'%@','%@','%@'",data[@"maintenanceTypeId"],data[@"maintenanceTypeName"],data[@"value"]]];
        }
    }
}

//同步技术手册型号
- (void)synchronizeTechModel:(NSArray *)techModelList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (techModelList != nil && techModelList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.techModelTableName];
        for (int i = 0; i < techModelList.count; i++) {
            NSDictionary *techModel = techModelList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.techModelTableName Column:[NSString stringWithFormat:@"'record_id','model','factoryId','typeId'"] Values:[NSString stringWithFormat:@"'%@','%@','%@','%@'",techModel[@"record_id"],techModel[@"model"],techModel[@"factoryId"],techModel[@"typeId"]]];
        }
    }
}


//同步备件模块 备件查询条件中的厂商
- (void)synchronizeSpareFactory:(NSArray *)spareFactoryList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (spareFactoryList != nil && spareFactoryList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.spareFactoryTableName];
        for (int i = 0; i < spareFactoryList.count; i++) {
            NSDictionary *spareFactory = spareFactoryList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.spareFactoryTableName Column:[NSString stringWithFormat:@"'spareFactoryName','spareTypeName'"] Values:[NSString stringWithFormat:@"'%@','%@'",spareFactory[@"spareFactoryName"],spareFactory[@"spareTypeName"]]];
        }
    }

}

//
- (void)synchronizeConsumableVerdor:(NSArray *)consumableVerdorList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (consumableVerdorList != nil && consumableVerdorList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.consumableVerdorTableName];
        for (int i = 0; i < consumableVerdorList.count; i++) {
            NSDictionary *consumableVerdor = consumableVerdorList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.consumableVerdorTableName Column:[NSString stringWithFormat:@"'consumableVendor','consumableType'"] Values:[NSString stringWithFormat:@"'%@','%@'",consumableVerdor[@"consumableVendor"],consumableVerdor[@"consumableType"]]];
        }
    }

}

//同步备件模块 备件查询条件中的所属专业
- (void)synchronizeSpareType:(NSArray *)spareTypeList
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (spareTypeList != nil && spareTypeList.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.spareTypeTableName];
        for (int i = 0; i < spareTypeList.count; i++) {
            NSDictionary *spareType = spareTypeList[i];
            [sqliteManager insertTableWithTableName:sqliteManager.spareTypeTableName Column:[NSString stringWithFormat:@"'spareTypeName'"] Values:[NSString stringWithFormat:@"'%@'",spareType[@"spareTypeName"]]];
        }
    }
}

//同步组织机构数据
- (void)syncOrgnaizeData:(NSArray *)arr
{
    SqliteManager *sqliteManager = [SqliteManager shareManager];
    if (arr != nil && arr.count > 0) {
        [sqliteManager ClearTableWithTableName:sqliteManager.organizationTableName];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            [sqliteManager insertTableWithTableName:sqliteManager.organizationTableName
                                             Column:[NSString stringWithFormat:@"'orgId','orgName','paraentOrgId'"]
                                             Values:[NSString stringWithFormat:@"'%@','%@','%@'",dic[@"orgId"],dic[@"orgName"],dic[@"paraentOrgId"]]];
        }
    }
}




@end
