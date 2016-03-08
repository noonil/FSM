//
//  ContactOrderViewCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactOrderCellClickDelegate <NSObject>
-(void)CellChooseClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;
//-(void)CellCancelClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;
@end

@interface ContactOrderViewCell : UITableViewCell

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *indexPath;


@property (nonatomic,weak)id<ContactOrderCellClickDelegate> delegate;


@property (nonatomic,assign)BOOL switchFlag; //用来表示尾部按钮为切换按钮还是普通按钮
@property (nonatomic,assign)BOOL chooseFlag; //在switchFlag标志为true时有效，表示切换按钮标志on/off

@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
