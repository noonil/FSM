//
//  OrderManagerController.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "OrderManagerController.h"
#import "NumberViewCell.h"
#import "HandlingOrderViewController.h"
#import "UnAccpetedOrderViewController.h"
#import "HandledOrderViewController.h"
#import "ViewController.h"
#import "UnAcceptedOrderAtSameTeamViewController.h"

@interface OrderManagerController ()

//@property (nonatomic,assign)NSNumber *AcceptingOrder;    //待受理工单
//@property (nonatomic,assign)NSNumber *HandlingOrder;     //正在处理工单
//@property (nonatomic,assign)NSNumber *HandledOrder;      //已处理工单
//@property (nonatomic,assign)NSNumber *AcceptingOrderInST; //同组待受理工单

@property (nonatomic,strong)NSArray *orders;

@end

@implementation OrderManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"工单管理";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //加载工单管理数据
    [self loadOrderData];
}

- (void)loadOrderData
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"getWorkTypeNumbers";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取工单数量，请稍后"];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.orders = dic[@"numbers"];
            [self.tableView reloadData];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];

        }
        
    } falure:^(NSError *err) {
        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
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
    NumberViewCell *cell = [NumberViewCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.content.text = @"待受理工单";
        [cell.number setTitle:[NSString stringWithFormat:@"%@",self.orders[0]==NULL?@"":self.orders[0]] forState:UIControlStateNormal];
    }else if (indexPath.row == 1){
        cell.content.text = @"正在处理工单";
        [cell.number setTitle:[NSString stringWithFormat:@"%@",self.orders[2]==NULL?@"":self.orders[2]] forState:UIControlStateNormal];
    }else if (indexPath.row == 2){
        cell.content.text = @"已处理工单";
        [cell.number setTitle:[NSString stringWithFormat:@"%@",self.orders[3]==NULL?@"":self.orders[3]] forState:UIControlStateNormal];
    }else{
        cell.content.text = @"同组待受理工单";
        [cell.number setTitle:[NSString stringWithFormat:@"%@",self.orders[4]==NULL?@"":self.orders[4]] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //待受理工单
        UnAccpetedOrderViewController *unAccepted = [[UnAccpetedOrderViewController alloc] initWithNibName:@"UnAccpetedOrderViewController" bundle:nil];
        [self.navigationController pushViewController:unAccepted animated:YES];
    }else if (indexPath.row == 1){
        //正在处理工单
        HandlingOrderViewController *handlingOrders = [[HandlingOrderViewController alloc] init];
        handlingOrders.searchWoType = 2;
        [self.navigationController pushViewController:handlingOrders animated:YES];
    }else if (indexPath.row == 2){
        //已处理工单
        HandledOrderViewController *handledOrders = [[HandledOrderViewController alloc] init];
        handledOrders.searchWoType = 2;
        [self.navigationController pushViewController:handledOrders animated:YES];
    }else{
        //同组待受理工单
        UnAcceptedOrderAtSameTeamViewController *unAcceptedAtSameTeam = [[UnAcceptedOrderAtSameTeamViewController alloc] initWithNibName:@"UnAcceptedOrderAtSameTeamViewController" bundle:nil];
        [self.navigationController pushViewController:unAcceptedAtSameTeam animated:YES];
    }
}

@end
