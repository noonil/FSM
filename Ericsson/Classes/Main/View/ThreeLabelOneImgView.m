//
//  ThreeLabelOneImgView.m
//  Ericsson
//
//  Created by xuming on 15/12/20.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ThreeLabelOneImgView.h"

@implementation ThreeLabelOneImgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)threeLabelOneImgView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ThreeLabelOneImgView" owner:self options:nil] lastObject];
}


- (IBAction)button_TouchDown:(id)sender {
    if ([self.delegate respondsToSelector:@selector(ThreeLabelOneImgViewClick:)]) {
        [self.delegate ThreeLabelOneImgViewClick:self.section];
    }
}
@end
