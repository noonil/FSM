//
//  MyResourceSectionHeaderView.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "MyResourceSectionHeaderView.h"

@implementation MyResourceSectionHeaderView

+ (instancetype)myResourceSectionHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MyResourceSectionHeaderView" owner:nil options:nil] lastObject];
}

@end
