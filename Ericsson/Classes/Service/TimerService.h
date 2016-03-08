//
//  TimerService.h
//  Ericsson
//
//  Created by xuming on 16/2/4.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerService : NSObject
+(TimerService *)shareInstance;
-(void)fireTimer;
-(void)stopTimer;
@end
