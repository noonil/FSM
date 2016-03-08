//
//  TwoLabelWithButton.h
//  Ericsson
//
//  Created by xuming on 15/12/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TwoLabelViewButtonDelegate <NSObject>

-(void)twoLabelViewButtonViewClick:(NSInteger)section;

@end

@interface TwoLabelWithButton : UIView
@property (weak, nonatomic) IBOutlet UILabel *attributeName;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (assign, nonatomic) NSInteger section;

@property (weak, nonatomic) id<TwoLabelViewButtonDelegate> delegate;
+ (instancetype)twoLabelWithButton;
@end
