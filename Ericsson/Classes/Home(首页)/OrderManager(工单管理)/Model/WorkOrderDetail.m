//
//  WorkOrderDetail.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "WorkOrderDetail.h"

@implementation WorkOrderDetail

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"phaseFeedBack" : @"WorkOrderPhaseFeedBack",
             @"steps" : @"WorkOrderStep",
             @"resourceList" : @"WorkOrderResource"
             };
}

@end
