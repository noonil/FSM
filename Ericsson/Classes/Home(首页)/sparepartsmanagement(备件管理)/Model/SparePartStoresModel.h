//
//  SparePartStoresModel.h
//  Ericsson
//
//  Created by Min on 16/1/6.
//  Copyright © 2016年 范传斌. All rights reserved.
// 根据备件Id获取该备件的各库存列表  的数据模型
/**
 “sparePartStoreList”:[{
 “distance”:””,  距离
 “storeNumber”:””,    库存量
 “storeroomName”:””,    仓库名称
 “storeroomId”:”“    仓库id
 */

#import <Foundation/Foundation.h>

@interface SparePartStoresModel : NSObject

/** 距离 */
@property (nonatomic,copy) NSString * distance;
/** 库存量 */
@property (nonatomic,copy) NSString * storeNumber;
/** 仓库名称 */
@property (nonatomic,copy) NSString * storeroomName;
/** 仓库id */
@property (nonatomic,copy) NSString * storeroomId;

@end