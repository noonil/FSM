//
//  Search_4ViewController.h
//  Ericsson
//
//  Created by slark on 15/12/24.
//  Copyright © 2015年 范传斌. All rights reserved.

// 备件申请

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class SparePartList;
@class SparePartStoresModel;
@class SparePartsAssociateOrderModel;

@interface Search_4ViewController : BaseViewController

/** 选中的备件 */
@property (nonatomic,strong) SparePartList * spareList_4;
/** storeModel */
@property (nonatomic,strong) SparePartStoresModel * storeModel_4;
/** 申请数量 */
@property (nonatomic,copy) NSString * applyNum;
/** 可关联工单返回的数据 */
@property (nonatomic,strong) SparePartsAssociateOrderModel * associateOrderModel;

@end
