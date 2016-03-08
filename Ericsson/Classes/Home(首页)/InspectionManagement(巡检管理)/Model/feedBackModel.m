//
//  feedBackModel.m
//  Ericsson
//
//  Created by Slark on 15/12/31.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "feedBackModel.h"

@implementation feedBackModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        self.idd = value;
        
    }
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    
    return nil;
}

@end
