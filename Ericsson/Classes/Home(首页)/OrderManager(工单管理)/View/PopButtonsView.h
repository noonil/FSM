//
//  PopButtonsView.h
//  Ericsson
//
//  Created by xuming on 16/1/11.
//  Copyright (c) 2016年 范传斌. All rights reserved.
//

@protocol PopButtonsViewDelegate<NSObject>

- (void) PopButtonsViewTap;
- (void) PopButtonsViewButtonTouchDown:(UIButton *)button;

@end

#import <UIKit/UIKit.h>


@interface PopButtonsView : UIView

@property (nonatomic,strong)NSMutableArray *buttonTitleArray ;
@property (assign, nonatomic) id <PopButtonsViewDelegate> delegate;
@property(nonatomic, strong)UIButton * electricButton;//发电时间按钮
@end


