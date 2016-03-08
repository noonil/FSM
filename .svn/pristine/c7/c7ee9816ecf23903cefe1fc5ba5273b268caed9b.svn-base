//
//  PhaseFeedBackViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/2.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkOrderStep,WorkOrder;

@interface PhaseFeedBackViewController : BaseViewController
- (IBAction)InputFeedBack:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *InputContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InputContentLabelHeight;

@property (nonatomic,strong)WorkOrder *workOrder;       //工单
@property (nonatomic,strong)WorkOrderStep *currentStep; //工单步骤
- (IBAction)PhaseFeedBackCommit:(UIButton *)sender;

@end
