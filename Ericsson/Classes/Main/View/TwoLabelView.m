//
//  TwoLabelView.m
//  Ericsson
//
//  Created by xuming on 15/12/16.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "TwoLabelView.h"

@implementation TwoLabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib
{
    //    NSLog(@"awakeFromNib");
    [super awakeFromNib];
    
     [[[NSBundle mainBundle] loadNibNamed:@"TwoLabelView" owner:self options:nil] lastObject];
    [self addSubview:self.nibView];
    
}

@end
