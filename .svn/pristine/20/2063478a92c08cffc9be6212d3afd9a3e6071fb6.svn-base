//
//  ResourceViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ResourceViewController.h"
#import "HeaderView.h"
#import "MyResourceSectionHeaderView.h"
#import "MyResourceViewCell.h"
#import "OrderContactViewController.h"

#import "ResourceInfo.h"
#import "FDAlertView.h"

#import "FSMResource.h"
#import "CompressAndEncrypt.h"


@interface ResourceViewController ()<UITableViewDelegate,UITableViewDataSource,ResourceViewCellClickDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)FDAlertView *msgView;

/** 记录当前页码 */
@property (nonatomic, assign)int  currentPage;
@property (nonatomic,strong)NSMutableArray *resources;
@end

@implementation ResourceViewController


-(NSMutableArray *)resources
{
    if (!_resources) {
        _resources = [[NSMutableArray alloc] init];
    }
    return _resources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的资源";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    self.headerView.title.text = @"资源列表";
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadNewResources)];
    
    //加载资源请求数据
    self.currentPage = 1;
    [self loadResources];
}

- (void)reloadResources{
    self.currentPage = 1;
    [self loadResources];
}

- (void)loadNewResources{
    self.currentPage ++;
    [self loadResources];
}

- (void)loadResources
{
    //请求数据示例（修改资源状态）
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    //请求数据示例
    NSDictionary *params = @{@"userId":userId,
                             @"pageIdx":@(self.currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMres" methodName:@"FSMMyResList" sessonId:sessionId requestData:params];
    
    [MBProgressHUD showMessage:@"正在发送获取我的资源列表请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *resources = [FSMResource objectArrayWithKeyValuesArray:dic[@"myResources"]];
            if (self.currentPage == 1) {
                [self.resources removeAllObjects];
            }
            
            [self.resources addObjectsFromArray:resources];
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
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
    return self.resources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSMResource *resource = self.resources[indexPath.row];
    
    MyResourceViewCell *cell = [MyResourceViewCell cellWithTableView:tableView];
    cell.name.text = resource.resourceName;
    cell.code.text = resource.resourceNumber;
    cell.isFree = !resource.resourceState;
    
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyResourceSectionHeaderView *sectionHeaderView = [MyResourceSectionHeaderView myResourceSectionHeaderView];
    
    sectionHeaderView.firstLabel.text = @"资源名称";
    sectionHeaderView.secondLabel.text = @"资源编号";
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - ResourceViewCellClickDelegate
-(void)CellChooseContactOrderInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    FSMResource *resource = self.resources[indexPath.row];
    if (resource.resourceState) return;
    
    OrderContactViewController *contactOrder = [[OrderContactViewController alloc] initWithNibName:@"OrderContactViewController" bundle:nil];
    contactOrder.resource = resource;
    [self.navigationController pushViewController:contactOrder animated:YES];
}

-(void)CellDetailBtnClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    FSMResource *resource = self.resources[indexPath.row];
    
//    NSLog(@"点击显示详情");
    self.msgView = [[FDAlertView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    [self.msgView addGestureRecognizer:tap];
    
    ResourceInfo *contentView = [[NSBundle mainBundle] loadNibNamed:@"ResourceInfo" owner:nil options:nil].lastObject;
    contentView.resource = resource;
    contentView.layer.cornerRadius = 5;
    contentView.frame = CGRectMake(0, 0, 250, 350);
    self.msgView.contentView = contentView;
    [self.msgView show];
}

-(void)CellSwitchBtnClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath State:(BOOL)state
{
    FSMResource *resource = self.resources[indexPath.row];
    
    //请求数据示例（修改资源状态）
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"resourceCode":resource.resourceId,@"userId":userId,@"state":(!resource.resourceState) ? @"true" : @"false",@"formId":@""};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMLockRes";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送修改资源状态请求"];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
//        NSLog(@"retcode:%@",dic[@"retCode"]);
        if ([dic[@"retCode"] isEqual:@0]) {
            [self.navigationController.view makeToast:@"请求成功"];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
            
        }
    } falure:^(NSError *err) {
//        NSLog(@"资源状态修改接口调用失败");
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (void)hide:(UIGestureRecognizer *)gesture
{
    [self.msgView hide];
}

@end
