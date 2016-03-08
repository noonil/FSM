//
//  AvtiveTableViewController.m
//  Ericsson
//
//  Created by admin on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AvtiveTableViewController.h"
#import "ListTableViewCell.h"
#import "MBProgressHUD.h"
#import "SoapService.h"
#import "SVPullToRefresh.h"
#import "ActiveDetailViewController.h"

@interface AvtiveTableViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    int currentPage; //分页请求 每次请求一页数据
    
}

@end

@implementation AvtiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOthers];

    
}

-(void)setOthers{
    
    currentPage = 1;
    self.title=@"活动告警列表";
    dataArray = [NSMutableArray array];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    [self loadData];
    
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [[self navigationItem] setLeftBarButtonItem:leftItem];

}



-(void)back{
    if (self.handlingOrderDetail!=nil) {
        _handlingOrderDetail.popButtonView.hidden=NO;
    }
    else if (self.handledOrderDetail!=nil) {
        _handledOrderDetail.popButtonView.hidden=NO;
    }else if (self.handlingDetail!=nil){
        _handlingDetail.popButtonView.hidden = NO;
    }else if (self.completeDetail != nil){
        _completeDetail.popButtonView.hidden = NO;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}


- (void)reloadResources{
    currentPage = 1;
    [self loadData];
}

- (void)reloadNewResources{
    currentPage ++;
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - loadData
/*
 //请求参数
 
 requestModel  :  FSMInformation模块名
 requestMethod  : queryAlertInfoList方法名
 
 sessionId     :   会话id
 requestData   :{
 "searchHistRecord":false,  是否查找历史告警false不是,true是
 "pageIdx":1,         页号
 "searchTitle":"",  告警标题        (历史告警传””)
 "searchName":""   网元名称
 }
 
 
 */
- (void)loadData{

    
    //准备请求参数
    NSString *modelName=@"FSMInformation";
    NSString *methodName=@"queryAlertInfoList";
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    

    //requestData是一个字典类型的参数  把参数与值一一对应存入数组中
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    
    if (self.name == nil) {
        //准备请求参数
        modelName =@"FSMInformation";
        methodName =@"FSMGetMObjectAlarm";
        
        
        //传false 和 true要看是否是查询历史警告
        parmeters.dictionary = @{
                                 @"maintenanceTypeId":_maintenanceType_Id,
                                 @"maintenanceId":_maintenance_Id,
                                 @"tableName":@""};
    }else {
        //准备请求参数
        modelName   =   @"FSMInformation";
        methodName  =   @"queryAlertInfoList";
    
        //传false 和 true要看是否是查询历史警告
        parmeters.dictionary = @{
                                 @"searchHistRecord":@"false",
                                 @"pageIdx":@(currentPage++),
                                 @"searchTitle":_alertTitle,
                                 @"searchName":_name};
    
    }
    
//    [parmeters setValue:@"false" forKey:@"searchHistRecord"];
//    //page是页数，每页可能返回固定条数 比如1的时候 返回10条，然后上拉刷新数据page+1，page==2，又返回10条新数据
//    [parmeters setValue:@(currentPage++) forKey:@"pageIdx"];
//    //标题和名字由上一个界面传过来
//    [parmeters setValue:_alertTitle forKey:@"searchTitle"];
//    [parmeters setValue:_name forKey:@"searchName"];
    
    
    
    //参数准备好了，就固定定要下面这个方法，把参数传进去就行了
    NSString *sopeStr= [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:parmeters];
    
    //最后，异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {//返回正确
            if (currentPage == 1) {
                [dataArray removeAllObjects];
            }

            [dataArray addObjectsFromArray:dic[@"alertInfoList"]];
            [self.tableView reloadData];
            
            if (dataArray == nil || dataArray.count == 0) {
                currentPage --;
            }
        }
        else{
        
            [self.view makeToast:KHudResponse1];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } falure:^(NSError *response) {
        [MBProgressHUD hideHUD];

        [self.view makeToast:KHudErrorMessage];
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [ListTableViewCell listcellWithTableView:tableView];
    cell.address.text = dataArray[indexPath.row][@"name"];
    cell.genre.text = dataArray[indexPath.row][@"level"];
    cell.timecontent.text = dataArray[indexPath.row][@"time"];
    
    if ([cell.genre.text isEqualToString:@"重大"]) {
        cell.address.textColor = [UIColor redColor];
        cell.genre.textColor = [UIColor redColor];
        cell.timecontent.textColor = [UIColor redColor];
    }
    else if([cell.genre.text isEqualToString:@"严重"]){
        cell.address.textColor = [UIColor orangeColor];
        cell.genre.textColor = [UIColor orangeColor];
        cell.timecontent.textColor = [UIColor orangeColor];
    }
    else if([cell.genre.text isEqualToString:@"轻微"]){
        cell.address.textColor = [UIColor yellowColor];
        cell.genre.textColor = [UIColor yellowColor];
        cell.timecontent.textColor = [UIColor yellowColor];
    }
    else if([cell.genre.text isEqualToString:@"警告"]){
        cell.address.textColor = [UIColor whiteColor];
        cell.genre.textColor = [UIColor whiteColor];
        cell.timecontent.textColor = [UIColor whiteColor];
    }
    
    return cell;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActiveDetailViewController *dVC=[[ActiveDetailViewController alloc]initWithNibName:@"ActiveDetailViewController" bundle:nil];
    dVC.ID =  dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:dVC animated:YES];

}


@end
