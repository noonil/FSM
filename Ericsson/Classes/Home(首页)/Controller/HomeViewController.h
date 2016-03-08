//
//  HomeViewController.h
//  Ericsson
//
//  Created by xuming on 15/10/2.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface HomeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * unhandleWorkList;
@property (nonatomic,strong)NSMutableArray * leastNotice;
@property (nonatomic,strong)NSMutableArray * handlingWork;


- (IBAction)resourceMatain_TouchUpInside:(id)sender;
- (IBAction)netResource_TouchUpInside:(id)sender;
- (IBAction)routingInspection_TouchUpInside:(id)sender;
- (IBAction)workOrder_TouchUpInside:(id)sender;
- (IBAction)sparePartsManagement_TouchUpInside:(id)sender;
- (IBAction)warning_TouchUpInside:(id)sender;


@end
