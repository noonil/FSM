//
//  Search_3ViewController.h
//  Ericsson
//
//  Created by slark on 15/12/24.
//  Copyright © 2015年 范传斌. All rights reserved.

// 备件库存详情

#import <UIKit/UIKit.h>
@class SparePartStoresModel;
@class SparePartList;
@interface Search_3ViewController : BaseViewController

/** 选中的备件 */
@property (nonatomic,strong) SparePartList * spareList_3;
/** storeModel */
@property (nonatomic,strong) SparePartStoresModel * storeModel_3;

@property (weak, nonatomic) IBOutlet UILabel *beijianNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wareHouseLabel;
@property (weak, nonatomic) IBOutlet UILabel *warehouseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UITextField *applicationNumber;

- (IBAction)confirmClick:(id)sender;

@end
