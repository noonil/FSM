//
//  UnAcceptedOrderAtSameTeamDetailViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnAcceptedOrderAtSameTeamViewController.h"
@class WorkOrder;

@interface UnAcceptedOrderAtSameTeamDetailViewController : BaseViewController


@property (nonatomic,strong) WorkOrder *unAcceptedOrder;
@property (weak, nonatomic) IBOutlet HeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *ContentScrollView;

- (IBAction)AcceptOrderAtSameTeam:(UIButton *)sender;


//用于保存处理后续ViewController直接调回到此Controller
@property (nonatomic,strong)UnAcceptedOrderAtSameTeamViewController *rootController;
@end
