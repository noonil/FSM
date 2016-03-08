//
//  ActiveStatisticTableViewController.m
//  Ericsson
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "ActiveStatisticListController.h"
#import "ActiveMangerViewController.h"
#import "TableViewCell.h"
#import "VillageChartViewController.h"
#import "BaseStationViewController.h"
#import "OMLViewController.h"
#import "LogicViewController.h"
#import "MOViewController.h"
#import "ActiveChartViewController.h"

@interface ActiveStatisticListController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
}
@property(nonatomic, copy)UITableView *tableView;
@end

@implementation ActiveStatisticListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    [self loadData];
}

-(void)setOthers{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"活动告警统计";
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    dataArray = [NSMutableArray array];

}

- (void)loadData{
    //准备请求参数

    //requestData是一个字典类型的参数  把参数与值一一对应存入数组中
    NSDictionary *parmeters =@{};
    
    //参数准备好了，就固定定要下面这个方法，把参数传进去就行了
    NSString *sopeStr= [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMGetAlarmTypeList" sessonId:sessonId requestData:parmeters];
    
    
    //最后，异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {//返回正确
            //将请求到的数据加入数组中
            [dataArray addObjectsFromArray:dic[@"alarmTypeList"]];
            [self.tableView reloadData];
            
        }
        else{
            [self.view makeToast:KHudResponse1];
        
        }
    } falure:^(NSError *response) {
        
        [MBProgressHUD hideHUD];
        [self.view makeToast:KHudErrorMessage];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [TableViewCell cellWithTableView:tableView];
    NSDictionary *dic=dataArray[indexPath.row];
    cell.content.text =[dic objectForKey:@"alarmType"];



    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ActiveChartViewController *vc=[[ActiveChartViewController alloc]init];

    NSDictionary *dic   = dataArray[indexPath.row];
    vc.alarmType        = [dic objectForKey:@"alarmType"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0)
//    {
//        VillageChartViewController *aVC = [[VillageChartViewController alloc] initWithNibName:@"VillageChartViewController" bundle:nil];
//        [self.navigationController pushViewController:aVC animated:YES];
//    }
//    if (indexPath.row == 1)
//    {
//        BaseStationViewController *bVC = [[BaseStationViewController alloc] initWithNibName:@"BaseStationViewController" bundle:nil];
//        [self.navigationController pushViewController:bVC animated:YES];
//    }
//    if (indexPath.row == 2)
//    {
//        OMLViewController *oVC = [[OMLViewController alloc] initWithNibName:@"OMLViewController" bundle:nil];
//        [self.navigationController pushViewController:oVC animated:YES];
//    }
//    if (indexPath.row == 3)
//    {
//        LogicViewController *lVC = [[LogicViewController alloc] initWithNibName:@"LogicViewController" bundle:nil];
//        [self.navigationController pushViewController:lVC animated:YES];
//    }
//
//    if (indexPath.row == 4)
//    {
//        MOViewController *mVC = [[MOViewController alloc] initWithNibName:@"MOViewController" bundle:nil];
//        [self.navigationController pushViewController:mVC animated:YES];
//    }

}

#pragma mark - get/set
-(UITableView *)tableView{

    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth , KIphoneHeight)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];


    }
    return _tableView;
}

@end
