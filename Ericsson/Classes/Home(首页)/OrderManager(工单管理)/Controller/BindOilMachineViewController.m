//
//  BindOilMachineViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "BindOilMachineViewController.h"
#import "OilMachineInfoCell.h"
#import "WorkOrderOilMachine.h"
#import "WorkOrder.h"

@interface BindOilMachineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *SearchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)loadOilMachines:(id)sender;
@property (nonatomic,strong)NSMutableArray *oilMachines;
@property (nonatomic,assign)int currentPage;


@end

@implementation BindOilMachineViewController

- (IBAction)loadOilMachines:(id)sender {
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"Serial":(self.SearchTextField.text == nil) ? @"" : self.SearchTextField.text,@"pageIdx":@(self.currentPage)};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMGetResOILsBySerial";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取油机列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *oilMachines = [WorkOrderOilMachine objectArrayWithKeyValuesArray:dic[@"resOilList"]];
            if (self.currentPage == 1) {
                [self.oilMachines removeAllObjects];
            }
            
            [self.oilMachines addObjectsFromArray:oilMachines];
            [self.tableView reloadData];
            //            NSLog(@"dic:%@",dic);
            
            if (oilMachines == nil || oilMachines.count == 0) {
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

-(NSMutableArray *)oilMachines{
    if (!_oilMachines) {
        _oilMachines = [[NSMutableArray alloc] init];
    }
    return _oilMachines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    
    self.currentPage = 1;
    [self.tableView addHeaderWithTarget:self action:@selector(reloadOilMachines)];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadNewOilMachines)];
    [self loadOilMachines:nil];

    
}

- (void)reloadOilMachines{
    self.currentPage = 1;
    [self loadOilMachines:nil];
}

- (void)loadNewOilMachines{
    self.currentPage ++;
    [self loadOilMachines:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.oilMachines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OilMachineInfoCell *cell = [OilMachineInfoCell cellWithTableView:tableView];
    
    WorkOrderOilMachine *oilMachine = self.oilMachines[indexPath.row];
    cell.oilMachineInfo = oilMachine;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中项做油机绑定
    WorkOrderOilMachine *oilMachine = self.oilMachines[indexPath.row];

    
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"woId":self.order.woId,@"resource_id":oilMachine.resourceId};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMSaveConnOilMachine";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在绑定油机"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            [self.navigationController.view makeToast:@"请求成功"];
            [self.navigationController popViewControllerAnimated:YES];
            //发出通知提示油机绑定成功，正在处理工单开始发电步骤继续操作
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessBindOilMachine" object:nil];
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
            
        }
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}

@end
