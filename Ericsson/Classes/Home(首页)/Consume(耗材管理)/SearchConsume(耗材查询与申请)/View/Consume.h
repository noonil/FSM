//
//  Consume.h
//  Ericsson
//
//  Created by xuming on 15/12/16.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Consume : NSObject

//耗材名称
@property(nonatomic, strong)NSString *consumableName;
//耗材型号
@property(nonatomic, strong)NSString *consumableModel;
//耗材id
@property(nonatomic, strong)NSString *consumableId;

//仓库距离
@property(nonatomic, strong) NSString *distinction;
//仓库名称
@property(nonatomic, strong) NSString *depotName;
//仓库id
@property(nonatomic, strong) NSString *depotId;
//仓库库存数
@property(nonatomic, strong) NSString *depotNumber;
//仓库电话
@property(nonatomic, strong) NSString *phoneNumber;


//申请数量
@property(nonatomic, strong) NSString *applyNumber;




@end
