//
//  ResourceMaintenanceViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ResourceMaintenanceViewController.h"
#import "SettingViewCell.h"
#import "ResourceViewController.h"
#import "ResourceAddViewController.h"


@interface ResourceMaintenanceViewController ()

@end

@implementation ResourceMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = @"维护资源";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
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
    SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.icon.image = [UIImage imageNamed:@"my_resource"];
        cell.item.text = @"我的资源";
    }else{
        cell.icon.image = [UIImage imageNamed:@"add_resource"];
        cell.item.text = @"添加资源";
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
        ResourceViewController *MyResource = [[ResourceViewController alloc] initWithNibName:@"ResourceViewController" bundle:nil];
        
        [self.navigationController pushViewController:MyResource animated:YES];
    }else{
        ResourceAddViewController *AddResource = [[ResourceAddViewController alloc] initWithNibName:@"ResourceAddViewController" bundle:nil];
        [self.navigationController pushViewController:AddResource animated:YES];
    }

}


@end
