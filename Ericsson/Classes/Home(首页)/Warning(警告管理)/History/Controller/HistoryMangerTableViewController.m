//
//  HistoryMangerTableViewController.m
//  Ericsson
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HistoryMangerTableViewController.h"
#import "WarningTableViewController.h"
#import "HistorywarningViewController.h"
#import "HistroyChartViewController.h"
#import "TableViewCell.h"
#import "HistoryDetailViewController.h"

@interface HistoryMangerTableViewController ()
@property(nonatomic, assign)BOOL showChar;

@end

@implementation HistoryMangerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title=@"历史告警管理";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *property=[defaults objectForKey:KKProperty];
    
    if ([[property substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]) {
        _showChar=true;
    }
    else
        _showChar=false;
    
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
    if (_showChar==YES) {
        return 2;
        
    }
    else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [TableViewCell cellWithTableView:tableView];
    

    
    
    if (_showChar==YES) {
        if (indexPath.row == 0) {
            cell.content.text = @"历史告警统计";
            
        }else{
            cell.content.text = @"历史告警详情";
        }
    }
    else{
        cell.content.text = @"历史告警详情";
        
        
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (_showChar==YES) {
        if (indexPath.row == 0) {
            HistroyChartViewController *vc=[[HistroyChartViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            HistorywarningViewController *historywarning = [[HistorywarningViewController alloc] initWithNibName:@"HistorywarningViewController" bundle:nil];
            [self.navigationController pushViewController:historywarning animated:YES];
        }
    }
    else{
        HistorywarningViewController *historywarning = [[HistorywarningViewController alloc] initWithNibName:@"HistorywarningViewController" bundle:nil];
        [self.navigationController pushViewController:historywarning animated:YES];
        
    }
    
}

@end
