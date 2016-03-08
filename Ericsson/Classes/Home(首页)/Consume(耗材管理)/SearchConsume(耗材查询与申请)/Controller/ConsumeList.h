//
//  ConsumeList.h
//  Ericsson
//
//  Created by xuming on 15/12/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ConsumeList : BaseViewController
@property(nonatomic, strong)NSString * vendor;//厂商
@property(nonatomic, strong)NSString * consumableName;// 耗材名称
@property(nonatomic, strong)NSString * consuableType;//

@end
