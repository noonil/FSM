//
//  OneButtonView.h
//  Ericsson
//
//  Created by xuming on 15/12/17.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneButtonViewDelegate <NSObject>

-(void)OneButtonViewDidTouchDown;

@end

@interface OneButtonView : UIView

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIView *nibView;
@property (nonatomic, weak) id<OneButtonViewDelegate> delegate;

@end
