//
//  OneButtonView.m
//  Ericsson
//
//  Created by xuming on 15/12/17.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "OneButtonView.h"

@implementation OneButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[[NSBundle mainBundle] loadNibNamed:@"OneButtonView" owner:self options:nil] lastObject];
    [self addSubview:self.nibView];
    
}

- (IBAction)btn_TouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(OneButtonViewDidTouchDown)]) {
        
        [self.delegate performSelector:@selector(OneButtonViewDidTouchDown)];
    }
}



@end