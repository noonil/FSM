//
//  WorkOrderBaseInfo.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "WorkOrderBaseInfo.h"

@implementation WorkOrderBaseInfo

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_woNumber forKey:@"woNumber"];
    [aCoder encodeObject:_maintenanceObjectId forKey:@"maintenanceObjectId"];
    [aCoder encodeObject:_contentDescribe forKey:@"contentDescribe"];
    [aCoder encodeObject:_maintenanceObject forKey:@"maintenanceObject"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.woNumber = [aDecoder decodeObjectForKey:@"woNumber"];
        self.maintenanceObjectId = [aDecoder decodeObjectForKey:@"maintenanceObjectId"];
        self.contentDescribe = [aDecoder decodeObjectForKey:@"contentDescribe"];
        self.maintenanceObject = [aDecoder decodeObjectForKey:@"maintenanceObject"];
    }
    return self;
}

@end
