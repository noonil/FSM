//
//  Organization.h
//  Ericsson
//
//  Created by xuming on 15/12/11.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organization : NSObject

//组织机构id
@property(nonatomic, strong)NSString* orgId;

//组织机构名称
@property(nonatomic, strong)NSString* orgName;

//父组织机构id
@property(nonatomic, strong)NSString* paraentOrgId;


@end
