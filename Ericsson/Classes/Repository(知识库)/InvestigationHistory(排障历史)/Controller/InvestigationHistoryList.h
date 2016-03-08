//
//  InvestigationHistoryList.h
//  Ericsson
//
//  Created by 张永鹏 on 16/1/9.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestigationHistoryList : BaseViewController

@property (nonatomic, strong) NSString *maintenanceObjectTypeId;//维护对象类型ID
@property (nonatomic, strong) NSString *orgId;//组织机构ID
@property (nonatomic, strong) NSString *maintenanceObjectName;//维护对象名称
@property (nonatomic, strong) UITableView *tableView;
@end
