//
//  UnAcceptedOrderAtSameTeamViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "UnAcceptedOrderAtSameTeamViewController.h"
#import "HeaderView.h"
#import "WorkOrder.h"
#import "HandledOrderCell.h"
#import "UnAcceptedOrderAtSameTeamDetailViewController.h"

@interface UnAcceptedOrderAtSameTeamViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)int currentPage;

@property (nonatomic,strong)NSMutableArray *UnAcceptedOrdersAtSameTeam;
@end

@implementation UnAcceptedOrderAtSameTeamViewController

-(NSMutableArray *)UnAcceptedOrdersAtSameTeam{
    if (!_UnAcceptedOrdersAtSameTeam) {
        _UnAcceptedOrdersAtSameTeam = [[NSMutableArray alloc] init];
    }
    return _UnAcceptedOrdersAtSameTeam;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.title = @"同组待受理工单";
    
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    self.headerView.title.text = @"工单列表";
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    self.currentPage = 1;
    [self.tableView addHeaderWithTarget:self action:@selector(reloadUnAcceptedOrdersAtSameTeam)];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadNewUnAcceptedOrdersAtSameTeam)];
}

- (void)reloadUnAcceptedOrdersAtSameTeam{
    self.currentPage = 1;
    [self loadUnAcceptedOrdersAtSameTeam];
}

- (void)loadNewUnAcceptedOrdersAtSameTeam{
    self.currentPage ++;
    [self loadUnAcceptedOrdersAtSameTeam];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //加载待受理工单数据
    [self loadUnAcceptedOrdersAtSameTeam];
}


- (void)loadUnAcceptedOrdersAtSameTeam
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"pageIdx":@(self.currentPage)};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"getAutoSendWorkOrderList";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送获取同组待受理工单请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *orders = [WorkOrder objectArrayWithKeyValuesArray:dic[@"daiBanList"]];
            if (self.currentPage == 1) {
                [self.UnAcceptedOrdersAtSameTeam removeAllObjects];
            }
            
            [self.UnAcceptedOrdersAtSameTeam addObjectsFromArray:orders];
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
    return self.UnAcceptedOrdersAtSameTeam.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrder *order = self.UnAcceptedOrdersAtSameTeam[indexPath.row];
    
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
    UnAcceptedOrderAtSameTeamDetailViewController *unAcceptedOrderAtSameTeamDetail = [[UnAcceptedOrderAtSameTeamDetailViewController alloc] initWithNibName:@"UnAcceptedOrderAtSameTeamDetailViewController" bundle:nil];
    unAcceptedOrderAtSameTeamDetail.rootController = self;
    
    WorkOrder *order = self.UnAcceptedOrdersAtSameTeam[indexPath.row];
    unAcceptedOrderAtSameTeamDetail.unAcceptedOrder = order;
    
    [self.navigationController pushViewController:unAcceptedOrderAtSameTeamDetail animated:YES];
}

@end
