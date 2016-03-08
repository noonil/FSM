//
//  MyResourceSectionHeaderView.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyResourceSectionHeaderView : UIView
+ (instancetype)myResourceSectionHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end
