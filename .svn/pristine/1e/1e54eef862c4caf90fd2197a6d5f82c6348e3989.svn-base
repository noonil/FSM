//
//  UnAcceptedOrderDetailViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderView,WorkOrder,UnAccpetedOrderViewController;

@interface UnAcceptedOrderDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet HeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *ContentScrollView;

- (IBAction)AcceptOrder:(UIButton *)sender;
- (IBAction)TransferOrder:(id)sender;
- (IBAction)RejectOrder:(UIButton *)sender;

@property (nonatomic,strong) WorkOrder *unAcceptedOrder;

//用于保存处理后续ViewController直接调回到此Controller
@property (nonatomic,strong)UnAccpetedOrderViewController *rootController;
@end
