//
//  xunjian_2.m
//  Ericsson
//
//  Created by Slark on 15/12/29.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "xunjian_2.h"

@implementation xunjian_2

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        self.idd = value;
        
        
        
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    
    return nil;
}



@end
