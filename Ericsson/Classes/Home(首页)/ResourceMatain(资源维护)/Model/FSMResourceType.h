//
//  FSMResourceType.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/16.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSMResourceType : NSObject
/** 资源类型ID */
@property (nonatomic,strong)NSString *resourceTypeId;
/** 资源类型名称 */
@property (nonatomic,copy)NSString *resourceTypeName;

@end
