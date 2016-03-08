//
//  StartTypeView.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "StartTypeView.h"

@implementation StartTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)Start:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(StartOrderWithType:)]) {
        [self.delegate StartOrderWithType:sender.tag];
    }
}
@end
