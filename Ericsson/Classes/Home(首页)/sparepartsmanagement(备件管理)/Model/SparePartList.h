//
//  SparePartList.h
//  Ericsson
//
//  Created by Min on 16/1/5.
//  Copyright © 2016年 范传斌. All rights reserved.

// 根据条件查询备件(厂商,专业,名称)列表

#import <Foundation/Foundation.h>

@interface SparePartList : NSObject

/** 备件名称 */
@property (nonatomic,copy) NSString * sparePartName;
/** 备件型号 */
@property (nonatomic,copy) NSString * sparePartType;
/** 备件id */
@property (nonatomic,copy) NSString * sparePartId;

@end
