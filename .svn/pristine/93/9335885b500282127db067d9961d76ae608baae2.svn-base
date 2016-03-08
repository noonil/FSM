//
//  HistoryTableViewController.m
//  Ericsson
//
//  Created by admin on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "ListTableViewCell.h"
#import "MBProgressHUD.h"
#import "SoapService.h"
#import "ActiveDetailViewController.h"
@interface HistoryTableViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    int currentPage; //分页请求 每次请求一页数据
    
}
@end
@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"历史告警列表";
    currentPage = 1;
    [self loadHistoryAlertData];
    dataArray = [NSMutableArray array];
    //提示正在获取
    [MBProgressHUD showMessage:@"正在获取告警信息列表"];
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
}

#pragma mark -- 上拉、下拉刷新
- (void)reloadResources{
    currentPage = 1;
    [self loadHistoryAlertData];
}

- (void)reloadNewResources{
    currentPage ++;
    [self loadHistoryAlertData];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActiveDetailViewController *dVC=[[ActiveDetailViewController alloc]initWithNibName:@"ActiveDetailViewController" bundle:nil];
    dVC.ID =  dataArray[indexPath.row][@"id"];
    dVC.historyView = self;
    [self.navigationController pushViewController:dVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  50;
}

#pragma mark - private method
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
- (void)loadHistoryAlertData{
    
    
    //准备请求参数
    NSString *modelName=@"FSMInformation";
    NSString *methodName=@"queryAlertInfoList";
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    //requestData是一个字典类型的参数  把参数与值一一对应存入数组中
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    //传false 和 true要看是否是查询历史警告
    [parmeters setValue:@"true" forKey:@"searchHistRecord"];
    //page是页数，每页可能返回固定条数 比如1的时候 返回10条，然后上拉刷新数据page+1，page==2，又返回10条新数据
    [parmeters setValue:@(currentPage) forKey:@"pageIdx"];
    //标题和名字由上一个界面传过来
    [parmeters setValue:_name2 forKey:@"searchName"];
    //参数准备好了，就固定定要下面这个方法，把参数传进去就行了
    NSString *sopeStr= [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:parmeters];
    
    NSLog(@"sopeStr:%@",sopeStr);
    
    //最后，异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        
        if ([dic[@"retCode"] isEqual:@0]) {//返回正确
            
            [MBProgressHUD hideHUD];
            //将上拉刷新和下拉刷新的动画停止
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            //将请求到的数据加入数组中
            [dataArray addObjectsFromArray:dic[@"alertInfoList"]];
            //刷新tableView
            [self.tableView reloadData];
        }
        
    } falure:^(NSError *response) {
        NSLog(@"活动警告查询错误：%@",response);
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

@end
