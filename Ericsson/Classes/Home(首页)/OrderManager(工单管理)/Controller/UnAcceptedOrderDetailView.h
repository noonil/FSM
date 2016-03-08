//
//  UnAcceptedOrderDetailView.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkOrderBaseInfo;

@protocol UnAcceptedOrderDetailViewDelegate <NSObject>

- (void)ShowmaintenanceObjectInfo;
@end

@interface UnAcceptedOrderDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *woNumber;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceObject;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceObjectType;
@property (weak, nonatomic) IBOutlet UILabel *priority;
@property (weak, nonatomic) IBOutlet UILabel *woType;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *planArriveTime;
@property (weak, nonatomic) IBOutlet UILabel *planFinishTime;
@property (weak, nonatomic) IBOutlet UILabel *contentDescribe;
@property (weak, nonatomic) IBOutlet UILabel *state;


@property (nonatomic,weak)id<UnAcceptedOrderDetailViewDelegate> delegate;

@property (nonatomic,strong)WorkOrderBaseInfo *unAcceptedOrderDetail;

@end
