//
//  HandledOrderViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandledOrderViewController : BaseViewController

@property (nonatomic, assign)int searchWoType;  //是否为巡检类工单
@property (nonatomic,strong) UITableView *tableView;
@end
