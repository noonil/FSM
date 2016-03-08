//
//  ConsumeDistanceList.h
//  Ericsson
//
//  Created by xuming on 15/12/17.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Consume.h"

@interface ConsumeDistanceList : BaseViewController
//@property(nonatomic, strong)NSString * consumableName;
//@property(nonatomic, strong)NSString * consumableId;
@property(nonatomic, strong)Consume * consume;

/** 经度 */
@property (nonatomic ,assign) double latitude;

@property (nonatomic ,assign) double longitude;

@end
