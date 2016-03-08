//
//  MyLKDBHelper.m
//  Ericsson
//
//  Created by xuming on 15/12/26.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "MyLKDBHelper.h"

@implementation MyLKDBHelper
//重载选择 使用的LKDBHelper
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        db = [[LKDBHelper alloc]init];
    });
    return db;
}

@end
