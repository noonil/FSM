//
//  SparepartsViewController.m
//  Ericsson
//
//  Created by 陶山强 on 15/10/14.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "SparepartsViewController.h"
#import "SettingViewCell.h"
#import "SpareAffirmViewController.h"
#import "MyspareViewController.h"
#import "SpareReturningViewController.h"
#import "SparesearchViewController.h"

@interface SparepartsViewController ()

@end

@implementation SparepartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = @"备件管理";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.icon.image = [UIImage imageNamed:@"search_icon"];
        cell.item.text = @"备件查询与申请";
    }else if(indexPath.row == 1){
        cell.icon.image = [UIImage imageNamed:@"my_resource"];
        cell.item.text = @"我的申请单";
    }else if(indexPath.row == 2){
        cell.icon.image = [UIImage imageNamed:@"check_choosed"];
        cell.item.text = @"领用确认";
    }else {
        cell.icon.image = [UIImage imageNamed:@"spare_return"];
        cell.item.text = @"待返还备件";
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
        SparesearchViewController *search = [[SparesearchViewController alloc] initWithNibName:@"SparesearchViewController" bundle:nil];
        
        [self.navigationController pushViewController:search animated:YES];
    }else if (indexPath.row == 1){
        MyspareViewController *myspare = [[MyspareViewController alloc] initWithNibName:@"MyspareViewController" bundle:nil];
        [self.navigationController pushViewController:myspare animated:YES];
    }else if (indexPath.row == 2){
        SpareAffirmViewController *confirm = [[SpareAffirmViewController alloc] initWithNibName:@"SpareAffirmViewController" bundle:nil];
        [self.navigationController pushViewController:confirm animated:YES];
    }else{
        SpareReturningViewController *spareReturn = [[SpareReturningViewController alloc] initWithNibName:@"SpareReturningViewController" bundle:nil];
        [self.navigationController pushViewController:spareReturn animated:YES];
    }
}


@end
