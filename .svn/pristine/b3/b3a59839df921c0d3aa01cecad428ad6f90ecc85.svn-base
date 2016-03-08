//
//  BindOilMachine.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "BindOilMachine.h"

@implementation BindOilMachine
- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bindOilMachineWithCancelType)]) {
        [self.delegate bindOilMachineWithCancelType];
    }
}


- (IBAction)bindOilMachine:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bindOilMachineWithBindType)]) {
        [self.delegate bindOilMachineWithBindType];
    }
}

@end
