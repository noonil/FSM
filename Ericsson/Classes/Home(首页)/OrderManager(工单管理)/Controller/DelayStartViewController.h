//
//  DelayStartViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UnAcceptedOrderAtSameTeamViewController;

@interface DelayStartViewController : BaseViewController



//用于保存处理后续ViewController直接调回到此Controller
@property (nonatomic,strong)UnAcceptedOrderAtSameTeamViewController *rootController;
@property (nonatomic,strong)NSMutableArray *workOrders;
@end
