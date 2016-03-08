//
//  HandingDetailViewController.h
//  Ericsson
//
//  Created by Slark on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopButtonsView.h"
#import "workOrder.h"

@class HeaderView;

@interface HandingDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (weak, nonatomic) IBOutlet HeaderView *headerView;
@property (nonatomic,copy)NSString * Maintitle;
@property (nonatomic,copy)NSString * woId;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
- (IBAction)firstClick:(id)sender;
- (IBAction)secondClick:(id)sender;
- (IBAction)thirdClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *RView;

@property (weak, nonatomic) IBOutlet UILabel *machineNumber;
@property (weak, nonatomic) IBOutlet UILabel *machineName;
@property (weak, nonatomic) IBOutlet UILabel *machineLevel;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *connectStyle;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *machineAddress;
@property (nonatomic,strong)NSNumber * ruleId;
//十二个按钮
@property (nonatomic,strong) PopButtonsView *popButtonView;
@property (nonatomic,strong) WorkOrder *workOrder;//工单
@property (nonatomic,assign) BOOL isGetFinishDetail; //已处理为true,正在处理为false

@end
