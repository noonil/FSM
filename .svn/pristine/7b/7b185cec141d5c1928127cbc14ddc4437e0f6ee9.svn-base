//
//  FeedBackInfoSectionHeaderView.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "FeedBackInfoSectionHeaderView.h"

@implementation FeedBackInfoSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    //22-126-251
    UIColor *color = [UIColor colorWithRed:22/255.0 green:126/255.0 blue:251/255.0 alpha:1.0];
    
    self.time.textColor = color;
    self.content.textColor = color;
}

+ (instancetype)feedBackInfoSectionHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FeedBackInfoSectionHeaderView" owner:nil options:nil] lastObject];
}
@end
