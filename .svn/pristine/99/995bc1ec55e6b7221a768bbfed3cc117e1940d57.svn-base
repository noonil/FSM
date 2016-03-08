//
//  HandlingOrderViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HandlingOrderViewController.h"
#import "HandledOrderCell.h"
#import "HandlingOrderDetailController.h"
#import "WorkOrder.h"
#import "MJExtension.h"
#import "UnAccpetedOrderViewController.h"
#import "OrderManagerController.h"
#import "HomeViewController.h"
#import "UnAcceptedOrderAtSameTeamViewController.h"

@interface HandlingOrderViewController ()
@property (nonatomic,strong)NSMutableArray *HandlingOrders;

@property (nonatomic, assign)int currentPage;   //记录当前页码
@end

@implementation HandlingOrderViewController

-(NSMutableArray *)HandlingOrders{
    if (!_HandlingOrders) {
        _HandlingOrders = [[NSMutableArray alloc] init];
    }
    return _HandlingOrders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"正在处理工单";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
    
    [self.view addSubview:self.tableView];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [[self navigationItem] setLeftBarButtonItem:leftItem];
    
}
-(void)back{
    
    

   // 如果是从正在处理工单跳转过来的。
    NSMutableArray *mutableArray=[[NSMutableArray alloc ]initWithArray:self.navigationController.viewControllers];
    id idd=mutableArray[mutableArray.count-2];
    if ([idd isMemberOfClass:[OrderManagerController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    if ([idd isMemberOfClass:[HomeViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    
    //如果是从待受理工单页面跳转过来的。
    
    for (unsigned long i=(mutableArray.count-1); i>0; i--) {
        id vc=mutableArray[i];
        if (![vc isMemberOfClass:[UnAccpetedOrderViewController class]]) {
            [mutableArray removeObject:vc];
        }
        else{
            
            [self.navigationController setViewControllers:mutableArray];
            return;
            
        }
    }
    
    //如果是从同组待受理工单跳转过来的，
    mutableArray=[[NSMutableArray alloc ]initWithArray:self.navigationController.viewControllers];
    for (unsigned long i=(mutableArray.count-1); i>0; i--) {
        id vc=mutableArray[i];
        if (![vc isMemberOfClass:[UnAcceptedOrderAtSameTeamViewController class]]) {
            [mutableArray removeObject:vc];
        }
        else{
            
            [self.navigationController setViewControllers:mutableArray];
            return;
            
        }
    }
    
    

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //加载正在处理工单列表数据
    self.currentPage = 1;
    [self loadHandlingOrder];
}

- (void)reloadResources{
    self.currentPage = 1;
    [self loadHandlingOrder];
}

- (void)reloadNewResources{
    self.currentPage ++;
    [self loadHandlingOrder];
}

- (void)loadHandlingOrder
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"pageIdx":@(self.currentPage),@"searchWoType":@(self.searchWoType)};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetAcceptWO";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取正在处理工单列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *orders = [WorkOrder objectArrayWithKeyValuesArray:dic[@"woList"]];
            if (self.currentPage == 1) {
                [self.HandlingOrders removeAllObjects];
            }
            
            [self.HandlingOrders addObjectsFromArray:orders];
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
    return self.HandlingOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrder *order = self.HandlingOrders[indexPath.row];
    
    HandledOrderCell *cell = [HandledOrderCell cellWithTableView:tableView];
    cell.icon.image = [UIImage imageNamed:[self iconNameWithResourceType:order.type]];
    cell.firstLabel.text = order.title;
    cell.secondLabel.text = order.state;
    
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
    WorkOrder *order = self.HandlingOrders[indexPath.row];
    
    HandlingOrderDetailController *detailOrder = [[HandlingOrderDetailController alloc] initWithNibName:@"HandlingOrderDetailController" bundle:nil];
    detailOrder.rootController = self;
    detailOrder.woId = order.woId;
    detailOrder.isGetFinishDetail = false;
    detailOrder.workOrder = order;
    [self.navigationController pushViewController:detailOrder animated:YES];
}

@end
