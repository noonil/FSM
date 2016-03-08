//
//  HomeTable_SectionHeadView.h
//  Ericsson
//
//  Created by xuming on 15/10/7.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTable_SectionHeadViewDelegate <NSObject>
@optional
- (void)didSelectMoreInfoBtn:(UIButton *)sender;

@end

@interface HomeTable_SectionHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,weak) id<HomeTable_SectionHeadViewDelegate> delegate;

@end
