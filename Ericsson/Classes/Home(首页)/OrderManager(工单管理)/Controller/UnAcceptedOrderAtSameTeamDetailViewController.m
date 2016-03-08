//
//  UnAcceptedOrderAtSameTeamDetailViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "UnAcceptedOrderAtSameTeamDetailViewController.h"
#import "HeaderView.h"
#import "UnAcceptedOrderDetailView.h"
#import "WorkOrder.h"
#import "WorkOrderBaseInfo.h"
#import "FDAlertView.h"
#import "MaintanceObjInfoView.h"
#import "DispatchUserViewController.h"
#import "WorkOrderUser.h"
#import "RejectOrderController.h"
#import "AcceptWithView.h"
#import "StartTypeView.h"
#import "DelayStartViewController.h"

@interface UnAcceptedOrderAtSameTeamDetailViewController ()<UnAcceptedOrderDetailViewDelegate,AcceptWithViewDelegate,StartTypeViewDelegate>

@property (nonatomic,strong)UnAcceptedOrderDetailView *contentView;
@property (nonatomic,strong)WorkOrderBaseInfo *unAcceptedOrderBaseInfo;

@property (nonatomic,strong)NSMutableArray *sameSiteOrders;
//弹出框管理器
@property (nonatomic,strong)FDAlertView *alert;
//详情弹出框
@property (nonatomic,strong)FDAlertView *Detailalert;

@end

@implementation UnAcceptedOrderAtSameTeamDetailViewController

-(NSMutableArray *)sameSiteOrders{
    if (!_sameSiteOrders) {
        _sameSiteOrders = [[NSMutableArray alloc] init];
    }
    return _sameSiteOrders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"待受理工单";
    
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    self.headerView.title.text = @"工单详情";
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    
    self.contentView = (UnAcceptedOrderDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"UnAcceptedOrderDetailView" owner:nil options:nil] firstObject];
    self.contentView.delegate = self;
    
    self.contentView.frame = CGRectMake(0, 0, self.ContentScrollView.frame.size.width, 550);
    self.ContentScrollView.contentSize = CGSizeMake(self.ContentScrollView.frame.size.width, 650);
    self.ContentScrollView.bounces = NO;
    [self.ContentScrollView addSubview:self.contentView];
    
    //初始化弹出框管理器，管理显示同站点待受理工单以及受理成功后选择稍后出发还是立即出发
    self.alert = [[FDAlertView alloc] init];
    
    //详情弹出框管理
    self.Detailalert = [[FDAlertView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadUnAcceptedOrderDetail];
}

-(void)loadUnAcceptedOrderDetail{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"woId":self.unAcceptedOrder.woId};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetWoDetail";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取同组待受理工单详情"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.unAcceptedOrderBaseInfo = [WorkOrderBaseInfo objectWithKeyValues:dic[@"daiBanWoDetail"]];
            self.contentView.unAcceptedOrderDetail = self.unAcceptedOrderBaseInfo;

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (IBAction)AcceptOrderAtSameTeam:(UIButton *)sender {
    //先获取是否有同站点待受理工单
    [self getSameSiteOrders];
}

//获取同站点待受理工单
-(void)getSameSiteOrders{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"pageIdx":@1,@"mObjectCode":self.unAcceptedOrderBaseInfo.maintenanceObjectId};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetSameSiteWo";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取同站点待受理工单" toView:self.view];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *orders = [WorkOrder objectArrayWithKeyValuesArray:dic[@"woList"]];
            
//            [self.sameSiteOrders addObjectsFromArray:orders];
            //返回同站点待受理工单包含自身工单，在此予以过滤
            for (WorkOrder *order in orders) {
                if (![order.woId isEqualToString:self.unAcceptedOrder.woId]) {
                    [self.sameSiteOrders addObject:order];
                }
            }
            
            if (self.sameSiteOrders.count > 0) {
                //弹出同站点待受理工单选择框
                
                AcceptWithView *contentView = [[NSBundle mainBundle] loadNibNamed:@"AcceptWithView" owner:nil options:nil].lastObject;
                contentView.delegate = self;
                contentView.sameSiteOrders = self.sameSiteOrders;
                contentView.orderBaseInfo = self.unAcceptedOrderBaseInfo;
                contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 300);
                self.alert.contentView = contentView;
                [self.alert show];
                [MBProgressHUD showSuccess:@"获取同站点待受理工单成功" toView:self.view];

            }else
                [self AcceptOrderPostWithSameSiteOrders:nil];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }

    } falure:^(NSError *err) {
//        NSLog(@"err:%@",err);
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (void)AcceptOrderPostWithSameSiteOrders:(NSMutableArray *)sameSiteOrders{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSMutableArray *woIds = [[NSMutableArray alloc] init];
    [woIds addObject:@{@"woId":self.unAcceptedOrder.woId}];
    if (sameSiteOrders && sameSiteOrders.count > 0) {
        for (WorkOrder *sameSiteOrder in sameSiteOrders) {
            [woIds addObject:@{@"woId":sameSiteOrder.woId}];
        }
    }
    
    NSDictionary *params = @{@"userId":userId,@"woIds":woIds,@"isAuto":@"1"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMAcceptWO";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在受理同组待受理工单" toView:self.view];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([dic[@"retCode"] isEqual:@0]) {
//            NSLog(@"受理成功");
            //成功之后处理稍后出发还是立即出发
            StartTypeView *contentView = [[NSBundle mainBundle] loadNibNamed:@"StartTypeView" owner:nil options:nil].lastObject;
            contentView.planArriveTime.text = self.unAcceptedOrderBaseInfo.planArriveTime;
            
            contentView.delegate = self;
            contentView.frame = CGRectMake(0, 0, 250, 300);
            
            self.alert.contentView = contentView;
            [self.alert show];
            [self.navigationController.view makeToast:@"请求成功"];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
    
}

#pragma mark - UnAcceptedOrderDetailViewDelegate
-(void)ShowmaintenanceObjectInfo{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"woId":self.unAcceptedOrder.woId};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetWOMObjectDetail";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取维护站点对象详情" toView:self.view];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([dic[@"retCode"] isEqual:@0]) {
//            NSLog(@"dic:%@",dic);

            //弹出维护对象详情
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailAlert)];
            [self.Detailalert addGestureRecognizer:tap];
            
            MaintanceObjInfoView *contentView = [[MaintanceObjInfoView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
            contentView.MaintanceOjbInfoArray = dic[@"objectDetail"];
            contentView.backgroundColor = [UIColor lightGrayColor];
            
            self.Detailalert.contentView = contentView;
            [self.Detailalert show];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (void)hideDetailAlert
{
    [self.Detailalert hide];
}

#pragma mark - AcceptWithViewDelegate
-(void)acceptWithViewDidCancel{
    [self.alert hide];
    [self AcceptOrderPostWithSameSiteOrders:nil];
}
-(void)acceptWithViewDidCommitWith:(NSMutableArray *)sameSiteOrders{
    [self.alert hide];
    [self AcceptOrderPostWithSameSiteOrders:sameSiteOrders];
}

#pragma mark - StartTypeViewDelegate
- (void)StartOrderWithType:(NSInteger)type{
    [self.alert hide];
    
    if (type == 1) {
        //立即出发
        [self StartOrder];
    }else if (type == 0){
        //稍后出发--弹出稍后出发原因处理界面
        //汇总待受理工单包括自身以及通过接口查询出的同站点待受理工单选中项
        NSMutableArray *totalOrders = [[NSMutableArray alloc] init];
        [totalOrders addObject:self.unAcceptedOrder];
        if (self.sameSiteOrders && self.sameSiteOrders.count > 0) {
            for (WorkOrder *sameSiteOrder in self.sameSiteOrders) {
                if (![sameSiteOrder.woId isEqualToString:self.unAcceptedOrder.woId]) {
                    [totalOrders addObject:sameSiteOrder];
                }
            }
        }
        DelayStartViewController *delayStart = [[DelayStartViewController alloc] initWithNibName:@"DelayStartViewController" bundle:nil];
        delayStart.workOrders = totalOrders;
        delayStart.rootController = self.rootController;
        [self.navigationController pushViewController:delayStart animated:YES];
    }
}

- (void)StartOrder{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    
    NSMutableArray *woIds = [[NSMutableArray alloc] init];
    [woIds addObject:self.unAcceptedOrder.woId];
    if (self.sameSiteOrders && self.sameSiteOrders.count > 0) {
        for (WorkOrder *sameSiteOrder in self.sameSiteOrders) {
            if (![sameSiteOrder.woId isEqualToString:self.unAcceptedOrder.woId]) {
                [woIds addObject:sameSiteOrder.woId];
            }
        }
    }
    
    NSDictionary *params = @{@"userId":userId,@"woIds":woIds,@"processId":@"0",@"operMBPS":@"出发",@"taskName":@"出发"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMStartOff";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在立即出发"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
//            NSLog(@"受理并已选择立即出发");
            [self.navigationController.view makeToast:@"请求成功"];

            [self.navigationController popToViewController:self.rootController animated:YES];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
    
}


@end
