//
//  AddAnnounceSectionView.m
//  Ericsson
//
//  Created by Min on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AddAnnounceSectionView.h"

@implementation AddAnnounceSectionView

+(AddAnnounceSectionView *)SectionHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AddAnnounceSectionView" owner:nil options:nil] lastObject];
}



- (IBAction)foldSectionBtn:(UIButton*)sender {
    
    if ([self.delegate respondsToSelector:@selector(SectionHeaderBtnClick:)]) {
        [self.delegate SectionHeaderBtnClick:self.section];
    }
    
}
- (IBAction)sectionViewEvent:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(changeSectionSelectedBtn:)]) {
        [self.delegate changeSectionSelectedBtn:self.section];
    }
    
}


@end
