//
//  ConsumeDistanceInfo.h
//  Ericsson
//
//  Created by xuming on 15/12/17.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumeDistanceInfo : NSObject

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


@end
