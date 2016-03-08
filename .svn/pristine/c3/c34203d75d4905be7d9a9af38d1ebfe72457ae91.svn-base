//
//  MyspareViewController.m
//  Ericsson
//
//  Created by 陶山强 on 15/10/14.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "MyspareViewController.h"
#import "TableViewCell.h"
#import "ClosedSpareViewController.h"
#import "UnclosedSpareViewController.h"
@interface MyspareViewController ()

@end

@implementation MyspareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = @"我的申请单";
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [TableViewCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.content.text = @"未关闭申请单";
        
    }else{
        cell.content.text = @"已关闭申请单";
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UnclosedSpareViewController *unclosedspare = [[UnclosedSpareViewController alloc] initWithNibName:@"UnclosedSpareViewController" bundle:nil];
        unclosedspare.navTitle = @"未关闭申请单";
        unclosedspare.isColosed = @"1";
        
        [self.navigationController pushViewController:unclosedspare animated:YES];
    }else{
        UnclosedSpareViewController *closedspare = [[UnclosedSpareViewController alloc] initWithNibName:@"UnclosedSpareViewController" bundle:nil];
        closedspare.navTitle = @"已关闭申请单";
        closedspare.isColosed = @"0";
        [self.navigationController pushViewController:closedspare animated:YES];
    }
    
}
@end
