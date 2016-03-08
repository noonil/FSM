//
//  UnAcceptedOrderDetailView.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "UnAcceptedOrderDetailView.h"
#import "WorkOrderBaseInfo.h"

@implementation UnAcceptedOrderDetailView

-(void)setUnAcceptedOrderDetail:(WorkOrderBaseInfo *)unAcceptedOrderDetail{
    _unAcceptedOrderDetail = unAcceptedOrderDetail;
    self.woNumber.text = unAcceptedOrderDetail.woNumber;
    self.maintenanceObject.text = unAcceptedOrderDetail.maintenanceObject;
    self.maintenanceObjectType.text = unAcceptedOrderDetail.maintenanceObjectType;
    self.priority.text = unAcceptedOrderDetail.priority;
    self.woType.text = unAcceptedOrderDetail.woType;
    self.address.text = unAcceptedOrderDetail.address;
    self.planArriveTime.text = unAcceptedOrderDetail.planArriveTime;
    self.planFinishTime.text = unAcceptedOrderDetail.planFinishTime;
    self.contentDescribe.text = unAcceptedOrderDetail.contentDescribe;
    self.state.text = unAcceptedOrderDetail.state;
}

- (IBAction)ShowDetail:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ShowmaintenanceObjectInfo)]) {
        [self.delegate ShowmaintenanceObjectInfo];
    }
}

@end
