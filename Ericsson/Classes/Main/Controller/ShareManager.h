//
//  ShareManager.h
//  Ericsson
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject
@property(nonatomic,strong)NSMutableArray *attachDataMutableArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *titleText;

+(id)sharedManager;
@end
