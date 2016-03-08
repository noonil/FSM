//
//  ResourceDetailViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ResourceDetailViewController.h"
#import "HeaderView.h"
#import "ContactOrderViewCell.h"
#import "FSMResource.h"
#import "FSMResourceType.h"

@interface ResourceDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ContactOrderCellClickDelegate>
@property (nonatomic,strong)NSMutableArray *selectedItems;
@property (nonatomic,strong)NSMutableArray *resources;

@property (nonatomic,assign)int currentPage;

- (IBAction)AddResources:(id)sender;

@end

@implementation ResourceDetailViewController



-(NSMutableArray *)selectedItems{
    if (!_selectedItems) {
        _selectedItems = [[NSMutableArray alloc] init];
    }
    return _selectedItems;
}

-(NSMutableArray *)resources{
    if (!_resources) {
        _resources = [[NSMutableArray alloc] init];
    }
    return _resources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资源添加";
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    
    //需要根据具体类型改变，暂不处理
    self.headerView.title.text = @"资源类型名称";
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    self.AddBtn.backgroundColor = [UIColor colorWithRed:97/255.0 green:162/255.0 blue:210/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadNewResources)];
}

- (void)reloadResources{
    self.currentPage = 1;
    [self loadResources];
}

- (void)loadNewResources{
    self.currentPage ++;
    [self loadResources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.currentPage = 1;
    [self loadResources];
}

- (void)loadResources{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,
                             @"resourceType":self.SelectedResourceType.resourceTypeName,
                             @"resourceNumber":self.resourceCode,
                             @"pageIdx":@(self.currentPage)};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMQueryResList";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];

    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在根据查询条件获取资源列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *orders = [FSMResource objectArrayWithKeyValuesArray:dic[@"resList"]];
            if (self.currentPage == 1) {
                [self.resources removeAllObjects];
            }
            
            [self.resources addObjectsFromArray:orders];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.resources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSMResource *resource = self.resources[indexPath.row];
    
    
    ContactOrderViewCell *cell = [ContactOrderViewCell cellWithTableView:tableView];
    cell.switchFlag = false;

    
    if ([self.selectedItems containsObject:indexPath]) {
        //185-151-105
        cell.backgroundColor = [UIColor colorWithRed:185/255.0 green:151/255.0 blue:105/255.0 alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    [cell.doneBtn setImage:nil forState:UIControlStateNormal];
    cell.orderName.text =resource.resourceNumber;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedItems containsObject:indexPath]) {
        [self.selectedItems removeObject:indexPath];
    }else{
        [self.selectedItems addObject:indexPath];
    }
    [self.tableView reloadData];
}


#pragma  mark - delegate
-(void)CellChooseClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"具体类型资源界面cell点击事件响应");
}


//添加资源
- (IBAction)AddResources:(id)sender {
    if (self.selectedItems.count <= 0) {
        [MBProgressHUD showError:@"请选择需要添加的资源"];
        return;
    }
    
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSMutableArray *addedResList = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.selectedItems.count; i++) {
        NSIndexPath *item = self.selectedItems[i];
        FSMResource *resource = self.resources[item.row];
        
        NSDictionary *addResource = @{@"resCode":resource.resourceNumber,@"resName":resource.resourceName,@"resTypeCode":self.SelectedResourceType.resourceTypeId,@"resTypeName":self.SelectedResourceType.resourceTypeName};
        [addedResList addObject:addResource];
    }
    
    NSDictionary *params = @{@"userId":userId,@"formId":@"",@"addedResList":addedResList};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMAddMyRes";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送添加资源请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [self.navigationController.view makeToast:@"请求成功"];
            [self.navigationController popViewControllerAnimated:YES];
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
