//
//  DispatchUserViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UnAccpetedOrderViewController;

@protocol DispatchUserViewDelegate <NSObject>
-(void)DispatchUserSelectedCommit:(NSArray *)selectedDispatchUsers;
@end


@interface DispatchUserViewController : BaseViewController
//用于保存处理后续ViewController直接调回到此Controller
@property (nonatomic,strong)UnAccpetedOrderViewController *rootController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak)id<DispatchUserViewDelegate> delegate;
@end
