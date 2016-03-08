//
//  InspectionViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/12.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "InspectionViewController.h"
#import "NumberViewCell.h"
#import "InspectionRuleViewController.h"
#import "OrderProcessingViewController.h"
#import "InspectionFeedbackOrderViewController.h"
#import "OrderCompletedViewController.h"

@interface InspectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSNumber * finishNumber;
@property (nonatomic,copy)NSNumber * feedBackNumber;
@property (nonatomic,copy)NSNumber * doingWorkNumber;
@property (nonatomic,copy)NSNumber * unAcceptNumber;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * ruleId;
@property (nonatomic,assign)int current;
@end

@implementation InspectionViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
        [self loadMoreData];
   
    
}

- (void)requestData{
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * modelName = @"FSMworkOrder";
    NSString * userId = [defaults objectForKey:@"username"];
    NSString * metthodName = @"FSMGetCheckPlanRule";
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSDictionary * dict = @{@"userId":userId,@"pageIdx":@(self.current),@"finshed":@1};
    NSString * postStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:metthodName sessonId:sessionId requestData:dict];
        [[SoapService shareInstance] PostAsync:postStr Success:^(NSDictionary *dic) {
    
            if ([dic[@"retCode"]isEqual:@0]) {
             
                NSLog(@"请求成功");
                
                NSArray * array = dic[@"planRules"];
                for (NSDictionary * dict in array) {
    
                    self.ruleId = dict[@"ruleId"];
    
    
                }
    
    
    
            }
    
        } falure:^(NSError *response) {
            
            
            
            
        }];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"巡检管理";
     self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
}

- (void)loadMoreData{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"getCheckWorkTypeNumbers";
    NSString * sessonId = sessionId;
    NSDictionary * params = @{};
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    [MBProgressHUD showMessage:@"正在请求数据"];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            self.finishNumber = dic[@"finishedInsectWoNumber"];
            self.feedBackNumber = dic[@"feedBackWoNumbers"];
            self.doingWorkNumber = dic[@"doingInspectWoNumbers"];
            self.unAcceptNumber = dic[@"needInspectNumbers"];
            [self.tableView reloadData];
        }else if ([dic[@"recCode"] isEqual:@(-1)]){
            
            [self.navigationController.view makeToast:@"请求失败"];
            
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时,请重新登录"];
        
        }
        
       
    } falure:^(NSError *response) {
        [MBProgressHUD hideHUD];
        
        [self.navigationController.view makeToast:@"请求失败"];
        
        
    }];
    
    
     [self requestData];
    
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NumberViewCell *cell = [NumberViewCell cellWithTableView:tableView];
   
    
    if (indexPath.row == 0) {
        cell.content.text = @"待领取巡检单";
        [cell.number setTitle:[NSString stringWithFormat:@"%d",self.unAcceptNumber.intValue] forState:UIControlStateNormal];
    }else if (indexPath.row == 1){
        cell.content.text = @"正在处理巡检工单";
        [cell.number setTitle:[NSString stringWithFormat:@"%d",self.doingWorkNumber.intValue]forState:UIControlStateNormal];
    }else if (indexPath.row == 2){
        cell.content.text = @"巡检阶段性反馈工单";
        [cell.number setTitle:[NSString stringWithFormat:@"%d",self.feedBackNumber.intValue] forState:UIControlStateNormal];
    }else{
        cell.content.text = @"已完成工单";
        [cell.number setTitle:[NSString stringWithFormat:@"%d",self.finishNumber.intValue] forState:UIControlStateNormal];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        InspectionRuleViewController *inspectionRule = [[InspectionRuleViewController alloc] init];
        [self.navigationController pushViewController:inspectionRule animated:YES];
    
    }else if (indexPath.row == 1){
        OrderProcessingViewController *orderProcessing = [[OrderProcessingViewController alloc] init];
        [self.navigationController pushViewController:orderProcessing animated:YES];
    }else if (indexPath.row == 2){
        InspectionFeedbackOrderViewController *feedBack = [[InspectionFeedbackOrderViewController alloc] init];
        [self.navigationController pushViewController:feedBack animated:YES];
    }else{
        
        OrderCompletedViewController *completedOrder = [[OrderCompletedViewController alloc] init];
        completedOrder.ruldId = self.ruleId;
        
        [self.navigationController pushViewController:completedOrder animated:YES];
    }
}

@end
