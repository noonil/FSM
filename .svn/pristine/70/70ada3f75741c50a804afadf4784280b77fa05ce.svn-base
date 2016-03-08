//
//  InspectionOrderViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/12.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "InspectionOrderViewController.h"
#import "xunjian_2.h"
#import "pollingTableViewCell.h"
#import "laterReasonViewController.h"
#import "OrderProcessingViewController.h"
@interface InspectionOrderViewController ()<UISearchResultsUpdating,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *orders;
@property (nonatomic,strong)NSMutableArray *dataSourceArray;
@property (nonatomic,strong)UISearchController *MySearchController;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)int current;
@property (nonatomic,copy)NSString * aaa;
@property (nonatomic,copy)NSString * formID;
@property (nonatomic,copy)NSString * woIds;
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation InspectionOrderViewController


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    self.MySearchController.active = NO;
    
}




-(NSMutableArray *)dataSourceArray
{

    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)dataArr{
    
    if(!_dataArr){
        
        
        _dataArr = [[NSMutableArray alloc]init];
    }
    
    return _dataArr;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待领取巡检单";
    
    //初始化MySearchDisplayController并和MySearchBar绑定
    self.MySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.MySearchController.searchResultsUpdater = self;
    self.MySearchController.dimsBackgroundDuringPresentation = NO;
    self.MySearchController.hidesNavigationBarDuringPresentation = NO;
    [self.MySearchController.searchBar sizeToFit];
    self.MySearchController.searchBar.placeholder = @"请输入查询信息";
    self.MySearchController.searchBar.hidden = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.MySearchController.searchBar;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadMoreData];

    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"pollingTableViewCell" bundle:nil] forCellReuseIdentifier:@"IDD"];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
}
#pragma mark 请求数据
- (void)loadMoreData{
    
    NSString * methodName = @"FSMGetCheckPlan";
    NSString * modelName = @"FSMworkOrder";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [defaults objectForKey:@"username"];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * sessonId = sessionId;
    
    NSDictionary * params = @{@"userId":userId,@"ruleId":self.ruleId,@"pageIdx":@(self.current)};
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在请求数据请稍后"];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
        
            NSMutableArray * array = dic[@"checkItmes"];
           
            for (NSDictionary * dict in array) {
                xunjian_2 * xun = [[xunjian_2 alloc]init];
                [xun setValuesForKeysWithDictionary:dict];
                
                [self.dataSourceArray addObject:xun];
                
            }

            [self.tableView reloadData];
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            
            [self.navigationController.view makeToast:@"请求失败"];
            
            
        }else if([dic[@"retCode"] isEqual:@(-2)]){
            
            
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时,请重新登录"];
        }
 
    } falure:^(NSError *response) {
     
    }];
   
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
   
    if (!self.orders || self.orders.count == 0) {
        self.orders = self.dataSourceArray;
  
    }
    
    if (self.MySearchController.active) {
        
        return self.orders.count;
    }else{
        return self.dataSourceArray.count;
    
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    pollingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDD"];
    
    if (cell == nil) {
        cell = [[pollingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDD"];
    }
    
    cell.accessoryType = UITableViewCellStyleValue1;
    
    if (self.MySearchController.active) {
        
        xunjian_2 * test = self.orders[indexPath.row];
        
        [cell loadDataFromModel:test];
        
        
    }else{
        
        xunjian_2 *test = self.dataSourceArray[indexPath.row];
       
        [cell loadDataFromModel:test];
        
    }

    return cell;
}

#pragma mark 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    xunjian_2 * xun = self.dataSourceArray[indexPath.row];
   
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.aaa = xun.idd;
   
    NSString * methodName = @"FSMRecvCheckPlan";
    NSString * modelName = @"FSMworkOrder";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * useId = [defaults objectForKey:@"username"];
    NSDictionary * dict = @{@"userId":useId,
                           @"checkObjectId":self.aaa};
    
    NSString * sopStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:dict];
    
    [[SoapService shareInstance] PostAsync:sopStr Success:^(NSDictionary *dic) {
        if([dic[@"retCode"] isEqual:@0]){
         
            self.woIds =dic[@"formId"];
            
        }
        
        
        
    } falure:^(NSError *response) {
        
    }];
    
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"您已领取此巡检工单,请到正在处理巡检工单中查看.请您选择现在是否立即出发" delegate:self cancelButtonTitle:nil otherButtonTitles:@"稍后出发",@"出发", nil];
    
    [alert show];
}

#pragma AlertView 代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 0) {
        
        laterReasonViewController * reason = [[laterReasonViewController alloc]init];
      reason.woId = self.woIds;
        NSLog(@"~~~~%@",reason.woId);
        
        [self.navigationController pushViewController:reason animated:YES];
    
    }else if (buttonIndex == 1){

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * sessionId = [defaults objectForKey:@"sessionId"];
        NSString * userId = [defaults objectForKey:@"username"];
        NSDictionary * params = @{@"userId":userId,@"checkObjectId":self.aaa};
        NSString * modelName = @"FSMworkOrder";
        NSString * methodName = @"FSMRecvCheckPlan";
        
        NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
        
        [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
            
            if ([dic[@"retCode"] isEqual: @0]) {
                
                [MBProgressHUD showSuccess:@"请求成功"];
                
                self.formID = dic[@"formId"];
                self.woIds = dic[@"formId"];
                
                
            }
            
            OrderProcessingViewController * order = [[OrderProcessingViewController alloc]init];
            order.ruleId = self.ruleId;
            [self.navigationController pushViewController: order animated:YES];
            
            
            NSMutableArray * navArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            NSRange range = NSMakeRange(0, 2);
           
            NSArray * subArr = [navArray subarrayWithRange:range];
            NSMutableArray * array = [[NSMutableArray alloc]initWithArray:subArr];
            [array addObject:order];
            [self.navigationController setViewControllers:array];
            
            
        } falure:^(NSError *response) {
            
            
            
            
        }];
        
    }
    
    
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.orders = [NSMutableArray array];
    
    NSString *filterString = searchController.searchBar.text;
    
    for (xunjian_2 *test in self.dataSourceArray) {
       
        if([test.targetName containsString:filterString]){
            
        [self.orders addObject:test];
        }
  }
    
        [self.tableView reloadData];
}




@end
