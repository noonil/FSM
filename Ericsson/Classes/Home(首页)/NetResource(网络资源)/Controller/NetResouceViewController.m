//
//  NetResouceViewController.m
//  Ericsson
//
//  Created by xuming on 15/10/7.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "NetResouceViewController.h"
#import "SettingViewCell.h"
#import "NetResourceSearchViewController.h"
#import "ApplyStateList.h"
#import "GatherSearchViewController.h"

@interface NetResouceViewController ()
@property(nonatomic,strong) NSArray *items;


@end

@implementation NetResouceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"网络资源管理";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get method
-(NSArray *)items{

    if (_items==nil) {
        NSString * itemsFile=[[NSBundle mainBundle] pathForResource:@"NetResouceItems.plist" ofType:nil];
        _items=[NSArray arrayWithContentsOfFile:itemsFile];
    
    }
    return _items;
}

#pragma mark - table view data scorce
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(SettingViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingViewCell *cell=[SettingViewCell cellWithTableView:tableView];
    
    NSDictionary *items=self.items[indexPath.row];
    cell.icon.image=[UIImage imageNamed:items[@"icon"]];
    cell.item.text=items[@"name"];
    
    return cell;

}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row===%ld",indexPath.row);

    if (indexPath.row==0) {
        NetResourceSearchViewController *vc=[[NetResourceSearchViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row==1) {
        GatherSearchViewController *vc=[[GatherSearchViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row==2) {
        ApplyStateList *vc=[[ApplyStateList alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
