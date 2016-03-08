//
//  TwoLabelWithButton.m
//  Ericsson
//
//  Created by xuming on 15/12/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "TwoLabelWithButton.h"

@interface TwoLabelWithButton()

- (IBAction)btn_TouchUpInside:(id)sender;

@end

@implementation TwoLabelWithButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)twoLabelWithButton
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TwoLabelWithButton" owner:nil options:nil] lastObject];
}

- (IBAction)btn_TouchUpInside:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(twoLabelViewButtonViewClick:)] ){
        [self.delegate twoLabelViewButtonViewClick:self.section];
    }
}
@end
