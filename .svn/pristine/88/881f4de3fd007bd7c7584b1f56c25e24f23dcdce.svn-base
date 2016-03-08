//
//  HandingDeatilModel.m
//  Ericsson
//
//  Created by Slark on 16/1/4.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "HandingDeatilModel.h"

@implementation HandingDeatilModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    
    
    return nil;
}

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
