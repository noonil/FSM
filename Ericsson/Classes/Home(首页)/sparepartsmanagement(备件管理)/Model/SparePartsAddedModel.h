//
//  SparePartsAddedModel.h
//  Ericsson
//
//  Created by Min on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SparePartList;
@class SparePartStoresModel;

@interface SparePartsAddedModel : NSObject

/** 备件id */
@property (nonatomic,copy) NSString * sparePartId;

/** 备件名称 */
@property (nonatomic,copy) NSString * sparePartName;
/** 备件型号 */
@property (nonatomic,copy) NSString * sparePartType;
/** 备件型号 */
@property (nonatomic,copy) NSString * spareApplyNum;

@property (nonatomic,strong) SparePartList * list;
@property (nonatomic,strong) SparePartStoresModel * storeModel;

@end
