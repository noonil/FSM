//
//  LogSectionHeader.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "LogSectionHeader.h"

@implementation LogSectionHeader

+(LogSectionHeader *)SectionHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LogSectionHeader" owner:nil options:nil] lastObject];
}


- (IBAction)ChangeStatus:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SectionHeaderBtnClick:)]) {
        [self.delegate SectionHeaderBtnClick:self.section];
    }

}
@end
