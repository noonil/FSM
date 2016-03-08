//
//  ToolBar.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/13.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ToolBar.h"

@implementation ToolBar

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    //    NSLog(@"initWithCoder");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [[[NSBundle mainBundle] loadNibNamed:@"ToolBar" owner:self options:nil] lastObject];
    [self addSubview:self.view];
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

+ (instancetype)toolBar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ToolBar" owner:nil options:nil] lastObject];
}


@end
