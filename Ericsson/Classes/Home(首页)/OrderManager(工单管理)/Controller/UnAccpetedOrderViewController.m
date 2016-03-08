//
//  UnAccpetedOrderViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "UnAccpetedOrderViewController.h"
#import "HeaderView.h"
#import "WorkOrder.h"
#import "HandledOrderCell.h"
#import "UnAcceptedOrderDetailViewController.h"

@interface UnAccpetedOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)int currentPage;

@property (nonatomic,strong)NSMutableArray *UnAcceptedOrders;

@end

@implementation UnAccpetedOrderViewController

-(NSMutableArray *)UnAcceptedOrders{
    if (!_UnAcceptedOrders) {
        _UnAcceptedOrders = [[NSMutableArray alloc] init];
    }
    return _UnAcceptedOrders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title=@"待受理工单";
    
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    self.headerView.title.text = @"工单列表";
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    self.currentPage = 1;
    [self.tableView addHeaderWithTarget:self action:@selector(reloadUnAcceptedOrders)];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadNewUnAcceptedOrders)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //加载待受理工单数据
    [self loadUnAcceptedOrders];
}

- (void)reloadUnAcceptedOrders{
    self.currentPage = 1;
    [self loadUnAcceptedOrders];
}

- (void)loadNewUnAcceptedOrders{
    self.currentPage ++;
    [self loadUnAcceptedOrders];
}

- (void)loadUnAcceptedOrders
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"pageIdx":@(self.currentPage)};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"getDaiBanWorkOrderList";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
   // NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取待受理工单"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *orders = [WorkOrder objectArrayWithKeyValuesArray:dic[@"daiBanList"]];
            NSLog(@"获取到的待受理工单数量orders.count=%d",orders.count);
            if (self.currentPage == 1) {
                [self.UnAcceptedOrders removeAllObjects];

            }
            
            [self.UnAcceptedOrders addObjectsFromArray:orders];
            NSLog(@"UnAcceptedOrders待受理工单数量orders.count=%d",self.UnAcceptedOrders.count);

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.UnAcceptedOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrder *order = self.UnAcceptedOrders[indexPath.row];
    
    HandledOrderCell *cell = [HandledOrderCell cellWithTableView:tableView];
    cell.icon.image = [UIImage imageNamed:[self iconNameWithResourceType:order.type]];
    cell.firstLabel.text = order.title;
    NSRange range = NSMakeRange(5, 11);
    cell.secondLabel.text = [order.time substringWithRange:range];
    
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
    UnAcceptedOrderDetailViewController *unAcceptedOrderDetail = [[UnAcceptedOrderDetailViewController alloc] initWithNibName:@"UnAcceptedOrderDetailViewController" bundle:nil];
    unAcceptedOrderDetail.rootController = self;
    
    WorkOrder *order = self.UnAcceptedOrders[indexPath.row];
    unAcceptedOrderDetail.unAcceptedOrder = order;
    
    [self.navigationController pushViewController:unAcceptedOrderDetail animated:YES];
}


@end
