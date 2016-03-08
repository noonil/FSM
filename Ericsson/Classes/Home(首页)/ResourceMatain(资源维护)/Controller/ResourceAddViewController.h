//
//  ResourceAddViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HandlingOrderDetailController.h"
#import "HandledOrderDetailController.h"
@class HeaderView;

@interface ResourceAddViewController : UIViewController
@property (weak, nonatomic) IBOutlet HeaderView *ResourceCategory;
@property (weak, nonatomic) IBOutlet HeaderView *SearchCode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@property (nonatomic, strong)HandlingOrderDetailController *handlingOrderDetail;
@property (nonatomic, strong)HandledOrderDetailController *handledOrderDetail;


- (IBAction)searchClick:(id)sender;

@end
