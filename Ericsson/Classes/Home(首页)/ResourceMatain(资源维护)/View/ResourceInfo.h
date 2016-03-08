//
//  ResourceInfo.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSMResource;

@interface ResourceInfo : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *resourceName;
@property (weak, nonatomic) IBOutlet UILabel *resouceCode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic,strong) FSMResource *resource;
@end
