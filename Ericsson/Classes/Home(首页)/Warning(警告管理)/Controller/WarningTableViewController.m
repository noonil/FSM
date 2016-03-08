//
//  WarningTableViewController.m
//  Ericsson
//
//  Created by 陶山强 on 15/10/14.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "WarningTableViewController.h"
#import "TableViewCell.h"
#import "ActiveMangerViewController.h"
#import "HistoryMangerTableViewController.h"
@interface WarningTableViewController ()

@end

@implementation WarningTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title=@"告警管理";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [TableViewCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.content.text = @"活动告警";
        
    }else{
        cell.content.text = @"历史告警";
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ActiveMangerViewController *amVC = [[ActiveMangerViewController alloc] initWithNibName:@"ActiveMangerViewController" bundle:nil];
        
        [self.navigationController pushViewController:amVC animated:YES];
    }
        else{
        HistoryMangerTableViewController *hmVC = [[HistoryMangerTableViewController alloc] initWithNibName:@"HistoryMangerTableViewController" bundle:nil];
        [self.navigationController pushViewController:hmVC animated:YES];
    }
    
}
@end
