//
//  DetailViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandlingOrderDetailController.h"
#import "HandledOrderDetailController.h"

@interface DetailViewController : BaseViewController
@property (nonatomic,copy)NSString * woId;
@property (nonatomic,copy)NSString * moto;
@property (nonatomic,copy)NSString * idd;
@property (nonatomic, strong)HandlingOrderDetailController *handlingOrderDetail;
@property (nonatomic, strong)HandledOrderDetailController *handledOrderDetail;
@property (nonatomic,copy)NSString * remark;
@property (nonatomic,copy)NSString * statusDes;

- (IBAction)feedClick:(id)sender;
- (IBAction)completeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;




@end
