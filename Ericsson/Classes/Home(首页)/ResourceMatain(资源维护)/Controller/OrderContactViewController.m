//
//  OrderContactViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "OrderContactViewController.h"
#import "HeaderView.h"
#import "ContactOrderViewCell.h"
#import "FSMOrder.h"
#import "FSMResource.h"

@interface OrderContactViewController ()<UITableViewDataSource,UITableViewDelegate,ContactOrderCellClickDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commit:(UIButton *)sender;

@property (nonatomic, assign)int  currentPage;
@property (nonatomic,strong)NSMutableArray *orders;
@property (nonatomic,strong)NSMutableArray *selectedOrders;

@end

@implementation OrderContactViewController

-(NSMutableArray *)selectedOrders
{
    if (!_selectedOrders) {
        _selectedOrders = [[NSMutableArray alloc] init];
    }
    return _selectedOrders;
}

-(NSMutableArray *)orders{
    if (!_orders) {
        _orders = [[NSMutableArray alloc] init];
    }
    return _orders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的资源";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    self.headerView.title.text = @"请选择要关联的工单";
    
    self.commitBtn.backgroundColor = [UIColor colorWithRed:97/255.0 green:162/255.0 blue:210/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewOrders)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreOrders)];
    
    //加载资源可关联工单
    self.currentPage = 1;
    [self loadNewOrders];
}

- (void)loadMoreOrders{
    self.currentPage ++;
    [self loadOrders];
}

- (void)loadNewOrders{
    self.currentPage = 1;
    [self loadOrders];
}

- (void)loadOrders
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"pageIdx":@(self.currentPage)};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMGetUnlinkResWOs";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showSuccess:@"正在获取未关联工单列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *orders = [FSMOrder objectArrayWithKeyValuesArray:dic[@"woList"]];
            if (self.currentPage == 1) {
                [self.orders removeAllObjects];
            }
            
            [self.orders addObjectsFromArray:orders];
            [self.tableView reloadData];
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.headerView.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,50);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.orders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSMOrder *order = self.orders[indexPath.row];
    
    ContactOrderViewCell *cell = [ContactOrderViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.switchFlag = true;
    
    [cell.doneBtn setImage:[UIImage imageNamed:@"check_not_choosed"] forState:UIControlStateNormal];
    [cell.doneBtn setImage:[UIImage imageNamed:@"check_choosed"] forState:UIControlStateSelected];
    
    cell.orderName.text = order.woName;
    return cell;
}

-(void)CellChooseClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    FSMOrder *order = self.orders[indexPath.row];
    [self.selectedOrders addObject:order];
}

-(void)CellCancelClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    FSMOrder *order = self.orders[indexPath.row];
    [self.selectedOrders removeObject:order];
}

- (IBAction)commit:(UIButton *)sender {
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    
    NSMutableArray *woInfos = [[NSMutableArray alloc] init];
    for (FSMOrder *order in self.selectedOrders) {
        NSMutableDictionary *woInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"woId":order.woId,@"preStartTime":order.preStartTime}];
  
        if (order.preEndTime != nil) {
            [woInfo setObject:order.preEndTime forKey:@"preEndTime"];
        }
        
        [woInfos addObject:woInfo];
    }
    
    NSDictionary *params = @{@"resTypeCode":self.resource.resourceTypeNumber,@"resTypeName":self.resource.resourceTypeName,@"resCode":self.resource.resourceNumber,@"resName":self.resource.resourceName,@"woInfos":woInfos};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMWoLinkRes";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在发生资源关联工单请求"];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            [self.navigationController.view makeToast:@"请求成功"];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } falure:^(NSError *err) {
//        NSLog(@"关联工单请求操作异常");
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}
@end
