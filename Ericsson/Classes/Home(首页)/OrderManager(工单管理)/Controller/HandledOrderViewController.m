//
//  HandledOrderViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HandledOrderViewController.h"
#import "HandledOrderCell.h"
#import "WorkOrder.h"
#import "HandledOrderDetailController.h"

@interface HandledOrderViewController ()

@property (nonatomic,strong)NSMutableArray *HandledOrders;

@property (nonatomic, assign)int currentPage;   //记录当前页码
@end

@implementation HandledOrderViewController

-(NSMutableArray *)HandledOrders{
    if (!_HandledOrders) {
        _HandledOrders = [[NSMutableArray alloc] init];
    }
    return _HandledOrders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已处理工单";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    self.currentPage = 1;
    [self loadHandledOrder];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadResources{
    self.currentPage = 1;
    [self loadHandledOrder];
}

- (void)reloadNewResources{
    self.currentPage ++;
    [self loadHandledOrder];
}

- (void)loadHandledOrder
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"pageIdx":@(self.currentPage),@"searchInspectWo":@"false"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMProcWO";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"发送获取已处理工单"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *orders = [WorkOrder objectArrayWithKeyValuesArray:dic[@"woList"]];
            if (self.currentPage == 1) {
                [self.HandledOrders removeAllObjects];
            }
            
            [self.HandledOrders addObjectsFromArray:orders];
            [self.tableView reloadData];
            //            NSLog(@"dic:%@",dic);
            
            if (orders == nil || orders.count == 0) {
                self.currentPage --;
            }
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
        
        if (self.currentPage > 1) {
            self.currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.HandledOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrder *order = self.HandledOrders[indexPath.row];
    
    HandledOrderCell *cell = [HandledOrderCell cellWithTableView:tableView];
    cell.icon.image = [UIImage imageNamed:[self iconNameWithResourceType:order.type]];
    cell.firstLabel.text = order.title;
    cell.secondLabel.text = order.time;
    
    return cell;
}

- (NSString *)iconNameWithResourceType:(NSString *)type{
    if ([type containsString:@"发电"]) {
        return @"wo_elect";
    }else if ([type containsString:@"故障"]){
        return @"wo_tr";
    }else
        return @"wo_with";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkOrder *order = self.HandledOrders[indexPath.row];

    HandledOrderDetailController *detailOrder = [[HandledOrderDetailController alloc] initWithNibName:@"HandledOrderDetailController" bundle:nil];
    detailOrder.woId = order.woId;
    detailOrder.isGetFinishDetail = true;
    detailOrder.workOrder = order;
    [self.navigationController pushViewController:detailOrder animated:YES];
}

@end
