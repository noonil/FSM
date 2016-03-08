//
//  OrderSectionHeaderView.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "OrderSectionHeaderView.h"

@implementation OrderSectionHeaderView

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height - 5, rect.size.width, 5));
    
}

+ (instancetype)orderSectionHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"OrderSectionHeaderView" owner:nil options:nil] lastObject];
}

- (IBAction)HeaderClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(OrderSectionHeaderViewClick:)]) {
        [self.delegate OrderSectionHeaderViewClick:self.section];
    }
}
@end
