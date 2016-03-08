//
//  RejectReasonsView.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "RejectReasonsView.h"
#import "ContactOrderViewCell.h"
#import "RejectReason.h"


@interface RejectReasonsView()<UITableViewDataSource,UITableViewDelegate,ContactOrderCellClickDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *selectedIndexpath;
- (IBAction)Cancel:(id)sender;

@end

@implementation RejectReasonsView

-(void)setRejectReasons:(NSArray *)rejectReasons{
    _rejectReasons = rejectReasons;
    [self.tableView reloadData];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.rejectReasons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RejectReason *reason = self.rejectReasons[indexPath.row];
    
    ContactOrderViewCell *cell = [ContactOrderViewCell cellWithTableView:tableView];
    
    cell.switchFlag = false;
    
    if (self.selectedReason && reason.reasonId == self.selectedReason.reasonId) {
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_choosed"] forState:UIControlStateNormal];
    }else{
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_not_choose"] forState:UIControlStateNormal];
    }

    if (indexPath == self.selectedIndexpath) {
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_choosed"] forState:UIControlStateNormal];
    }else{
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_not_choose"] forState:UIControlStateNormal];
    }
    
        cell.orderName.text = reason.reasonName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexpath = indexPath;
    RejectReason *reason = self.rejectReasons[indexPath.row];
    
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(RejectReasonDidSelected:)]) {
        [self.delegate RejectReasonDidSelected:reason];
    }
    
    [self Cancel:nil];
}

- (IBAction)Cancel:(id)sender {
    FDAlertView *alertView = (FDAlertView *)self.superview;
    [alertView hide];
}
@end
