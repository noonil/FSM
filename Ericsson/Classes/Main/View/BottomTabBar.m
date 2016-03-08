//
//  BottomTabBar.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "BottomTabBar.h"

@implementation BottomTabBar

-(id)initWithCoder:(NSCoder *)aDecoder
{
    //    NSLog(@"initWithCoder");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}


-(void)setup
{
    [[[NSBundle mainBundle] loadNibNamed:@"BottomTabBar" owner:self options:nil] lastObject];
    [self addSubview:self.View];
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

@end
