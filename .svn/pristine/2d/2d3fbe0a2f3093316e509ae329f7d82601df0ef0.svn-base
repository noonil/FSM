//
//  RejectReasonsView.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//  原因选择列表（拒收，稍后出发）

#import <UIKit/UIKit.h>
@class RejectReason;

@protocol RejectReasonChooseDelegate <NSObject>
-(void)RejectReasonDidSelected:(RejectReason *)reason;
@end

@interface RejectReasonsView : UIView
@property (nonatomic,strong)NSArray *rejectReasons;

@property (nonatomic,strong)RejectReason *selectedReason;
@property (nonatomic,weak)id<RejectReasonChooseDelegate> delegate;
@end
