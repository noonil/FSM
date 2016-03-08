//
//  RepositoryViewController.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/4.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "RepositoryViewController.h"
#import "SettingViewCell.h"
#import "TechnicalManualViewController.h"
#import "OperatingGuideViewController.h"
#import "InvestigationHistoryViewController.h"

@interface RepositoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *items; //用于存放首页的item

@end

@implementation RepositoryViewController

-(NSArray *)items{
    if (!_items) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"RepositoryItems.plist" ofType:nil];
        _items = [NSArray arrayWithContentsOfFile:file];
    }
    
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.backgroundColor = KBaseGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self.view addSubview: self.tableView];

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
    return [self.items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView];

    NSDictionary *item = self.items[indexPath.row];
    cell.icon.image = [UIImage imageNamed:item[@"Icon"]];
    cell.item.text = item[@"Name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        TechnicalManualViewController *manualViewController = [[TechnicalManualViewController alloc]initWithNibName:@"TechnicalManualViewController" bundle:nil];
        [self.navigationController pushViewController:manualViewController animated:YES];
    }
    else if (indexPath.row == 1) {
        OperatingGuideViewController *guideViewController = [[OperatingGuideViewController alloc]initWithNibName:@"OperatingGuideViewController" bundle:nil];
        [self.navigationController pushViewController:guideViewController animated:YES];
    }
    else if (indexPath.row == 2){
        InvestigationHistoryViewController *historyViewController = [[InvestigationHistoryViewController alloc] initWithNibName:@"InvestigationHistoryViewController" bundle:nil];
        [self.navigationController pushViewController:historyViewController animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
