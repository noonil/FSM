//
//  HeaderView.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
-(id)initWithCoder:(NSCoder *)aDecoder
{
//    NSLog(@"initWithCoder");

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
   
    self.title.textColor = [UIColor colorWithRed:252/255.0 green:120/255.0 blue:38/255.0 alpha:1.0];
    
    self.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    return self;
}


-(void)setup
{
    [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil] lastObject];
    
    [self addSubview:self.view];
    
}

-(void)awakeFromNib
{
//    NSLog(@"awakeFromNib");
    [super awakeFromNib];

    [self setup];
    
    self.title.textColor = [UIColor colorWithRed:252/255.0 green:120/255.0 blue:38/255.0 alpha:1.0];
    
    self.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
}

+ (instancetype)HeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil] lastObject];
}

@end
