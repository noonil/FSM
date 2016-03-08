//
//  HeadView.m
//  Ericsson
//
//  Created by xuming on 15/12/3.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "HeadView.h"

@interface HeadView ()

@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation HeadView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:self options:nil] lastObject];
    [self addSubview:self.view];
    
}
@end
