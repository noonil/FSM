//
//  AnnoucneItemDetailModel.m
//  Ericsson
//
//  Created by Min on 16/1/15.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "AnnoucneItemDetailModel.h"

@implementation AnnoucneItemDetailModel

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
