//
//  completeListViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/18.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface completeListViewController : BaseViewController
@property (nonatomic,copy)NSString * str;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
