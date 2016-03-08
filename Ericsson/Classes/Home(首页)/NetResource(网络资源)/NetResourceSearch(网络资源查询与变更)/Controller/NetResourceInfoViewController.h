//
//  NetResourceInfoViewController.h
//  Ericsson
//
//  Created by xuming on 15/12/3.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MatainObject.h"
#import "HandlingOrderDetailController.h"
#import "HandledOrderDetailController.h"

@interface NetResourceInfoViewController : BaseViewController
@property(nonatomic, strong)MatainObject *matainObject;
@property (nonatomic, strong)HandlingOrderDetailController *handlingOrderDetail;
@property (nonatomic, strong)HandledOrderDetailController *handledOrderDetail;

@end
