//
//  BkView.m
//  Ericsson
//
//  Created by 陶山强 on 16/1/13.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "BkView.h"
#define KBackGroundColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7]
@implementation BkView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =KBackGroundColor;
        
    }
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    }

@end
