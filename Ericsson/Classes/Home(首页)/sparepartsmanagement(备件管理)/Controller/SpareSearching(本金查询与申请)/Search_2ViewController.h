//
//  Search_2ViewController.h
//  Ericsson
//
//  Created by slark on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.

// 仓库库存列表

#import <UIKit/UIKit.h>
@class SparePartList;

@interface Search_2ViewController : BaseViewController

/** 选中的备件的model */
@property (nonatomic,strong) SparePartList * spareList;

@property (weak, nonatomic) IBOutlet UILabel *employmentNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) double latitude_2;
@property (nonatomic,assign) double longitude_2;

- (IBAction)RefreshClick:(id)sender;

@end
