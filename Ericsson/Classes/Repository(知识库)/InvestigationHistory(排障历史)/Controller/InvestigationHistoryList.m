//
//  InvestigationHistoryList.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/9.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "InvestigationHistoryList.h"
#import "maintenanceObjectCell.h"
#import "MBProgressHUD+MJ.h"
#import "HistoryListDetailViewController.h"

@interface InvestigationHistoryList ()<UITableViewDelegate
,UITableViewDataSource>{
    NSMutableArray *mainatenanceListArr; //存放排障历史列表数据
    NSMutableArray *maintenanceObjectTitleArr; //存放标题
    
    NSString *moTitleStr;
}

@property (nonatomic, assign)int currentPage;   //记录当前页码

@end

@implementation InvestigationHistoryList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排障历史";
    [MBProgressHUD showMessage:@"正在获取维护对象列表"];
    
    mainatenanceListArr = [NSMutableArray new];
    maintenanceObjectTitleArr = [NSMutableArray new];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.bounces = NO;
    [self.view addSubview: self.tableView];
    
    self.currentPage = 1;
    [self loadData];
    
    //上拉刷新  下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
}

#pragma mark -- 上拉、下拉刷新
- (void)reloadResources{
    self.currentPage = 1;
    [self loadData];
}

- (void)reloadNewResources{
    self.currentPage ++;
    [self loadData];
}

#pragma mark -- 重写 set/get 方法
-(NSString *)orgId{
    if (_orgId == nil) {
        _orgId = @"";
    }
    return _orgId;
}

-(NSString *)maintenanceObjectName{
    if (_maintenanceObjectName == nil) {
        _maintenanceObjectName = @"";
    }
    return _maintenanceObjectName;
}


#pragma mark  -- loadData
-(void)loadData{
    
    NSDictionary *params = @{@"userId":KUserId,@"maintenanceObjectType":self.maintenanceObjectTypeId,@"maintenanceObjectName":self.maintenanceObjectName,@"orgId":self.orgId,@"pageIdx":@(self.currentPage)};
    
    NSString *sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMQueryMObject" sessonId:KSessionId requestData:params];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]){
            NSArray *tempArr = [dic objectForKey:@"mainatenanceList"];
            
            if (self.currentPage == 1) {
                [mainatenanceListArr removeAllObjects];
            }
            
            [mainatenanceListArr addObjectsFromArray:tempArr];
            
            
            if (tempArr == nil || tempArr.count == 0) {
                self.currentPage --;
            }
            
            
            if (mainatenanceListArr.count != 0) {
                [maintenanceObjectTitleArr removeAllObjects];
                for (NSDictionary *listDic in mainatenanceListArr) {
                    NSString *title = [listDic objectForKey:@"maintenanceObjectTitle"];
                    [maintenanceObjectTitleArr addObject:title];
                }
                
            }
            else{
                [self.view makeToast:@"未查询到相关信息"];
            }
            
        }
        
        
        /** 服务器返回非0 的情况    */
        else if ([dic[@"retCode"] isEqual:@(-1)]){
        
            [self.view makeToast:@"请求失败"];
        
        }
        else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.view makeToast:@"会话超时,请重新登录"];
        }
        
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
     
        
    } falure:^(NSError *response) {
        [MBProgressHUD hideHUD];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.view makeToast:@"获取维护对象列表失败"];
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
    return [mainatenanceListArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    maintenanceObjectCell *cell = [maintenanceObjectCell cellWithTableView:tableView];
    
    NSString *TreatedStr = maintenanceObjectTitleArr [indexPath.row];
    TreatedStr = [TreatedStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除首尾的空白字符串和换行字符
    
    cell.title.text = TreatedStr;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *TreatedStr = maintenanceObjectTitleArr [indexPath.row];
    TreatedStr = [TreatedStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除首尾的空白字符串和换行字符
    
    
    /** 取得范围里值 传递 */
    moTitleStr = TreatedStr;
    NSRange range = [moTitleStr rangeOfString:@"("];
    
    if (range.length) {
        NSString *maintenanceName = [moTitleStr substringToIndex:range.location];
        
        HistoryListDetailViewController *detailViewController = [[HistoryListDetailViewController alloc] init];
        detailViewController.maintenanceName = maintenanceName;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        [self.view makeToast:@"查询出错"];
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
