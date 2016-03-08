

//
//  ShareManager.m
//  Ericsson
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager
+(id)sharedManager {
    
    static ShareManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
        sharedMyManager.attachDataMutableArray = [[NSMutableArray alloc]init];
        sharedMyManager.dataArray = [[NSMutableArray alloc]init];
    });
    
    return sharedMyManager;
    
}
@end
