//
//  AcceptWithView.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/10.
//  Copyright © 2015年 范传斌. All rights reserved.
//  并同受理（在受理工单时可同时受理同站点未完成工单）

#import <UIKit/UIKit.h>
@protocol AcceptWithViewDelegate <NSObject>

-(void)acceptWithViewDidCancel;
-(void)acceptWithViewDidCommitWith:(NSMutableArray *)sameSiteOrders;

@end

@class WorkOrderBaseInfo;

@interface AcceptWithView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)WorkOrderBaseInfo *orderBaseInfo;

@property (nonatomic,weak)id<AcceptWithViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commit:(id)sender;
- (IBAction)cancel:(id)sender;


@property (nonatomic,strong)NSMutableArray *sameSiteOrders; //可选同受理工单列表
@end
