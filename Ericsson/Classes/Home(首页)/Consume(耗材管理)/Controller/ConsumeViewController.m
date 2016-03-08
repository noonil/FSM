//
//  ConsumeViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ConsumeViewController.h"
#import "SettingViewCell.h"
#import "SearchViewController.h"
#import "MyApplyListViewController.h"
#import "ConsumeSubmitListController.h"

@interface ConsumeViewController ()
{

}
@property(nonatomic ,strong)NSArray * items;

@end

@implementation ConsumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"耗材管理";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell=[SettingViewCell cellWithTableView:tableView];
    
    NSDictionary *items=self.items[indexPath.row];
    cell.icon.image=[UIImage imageNamed:items[@"icon"]];
    cell.item.text=items[@"name"];
    
    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        SearchViewController *vc=[[SearchViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==1) {
        MyApplyListViewController *vc=[[MyApplyListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2) {
        ConsumeSubmitListController  *vc=[[ConsumeSubmitListController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma  mark -get/set
-(NSArray*)items{
    
    if (_items==nil) {
        NSString * itemsFile=[[NSBundle mainBundle] pathForResource:@"ConsumeItems.plist" ofType:nil];
        _items=[NSArray arrayWithContentsOfFile:itemsFile];
        
    }
    return _items;

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
