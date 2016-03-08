//
//  MyResourceViewCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResourceViewCellClickDelegate <NSObject>

-(void)CellChooseContactOrderInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;
-(void)CellDetailBtnClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;
-(void)CellSwitchBtnClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath State:(BOOL)state;
@end


@interface MyResourceViewCell : UITableViewCell


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,weak)id<ResourceViewCellClickDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@property (nonatomic,assign)BOOL isFree;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
