//
//  HistoryListDetailViewController.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/12.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "HistoryListDetailViewController.h"
#import "TroubleHistoryListCell.h"
#import "HandledOrderDetailController.h"
#import "HandlingOrderDetailController.h"

@interface HistoryListDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *troubleHistoryArr;
}
@property (nonatomic, assign)int currentPage;   //记录当前页码

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HistoryListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"排障历史";
    
    [MBProgressHUD showMessage:@"正在加载数据……" toView:self.tableView];
    
    troubleHistoryArr = [NSMutableArray array];
    
    self.titleLabel.text = self.maintenanceName;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    self.currentPage = 1;
    [self loadData];
    
    //上拉刷新  下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [leftItem setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setLeftBarButtonItem:leftItem];
}

-(NSString *)maintenanceName{
    if (!_maintenanceName) {
        _maintenanceName = @"";
    }
    return _maintenanceName;
}

-(void)back{
    NSArray * navVCsArray=self.navigationController.viewControllers;
    for (long i=navVCsArray.count-1; i>0; i--) {
        UIViewController *vc=navVCsArray[i];
        if ( [vc isMemberOfClass:[HandlingOrderDetailController class]])
        {
            ((HandlingOrderDetailController *)vc).popButtonView.hidden=NO;
            break;
        }
        else if ( [vc isMemberOfClass:[HandledOrderDetailController class]])
        {
            ((HandledOrderDetailController *)vc).popButtonView.hidden=NO;
            break;
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

//数据请求
-(void)loadData{
    
    NSDictionary *params = @{@"maintenanceName":self.maintenanceName,@"pageIdx":@(self.currentPage)};
    
    NSString *str = [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMGetMObjectFaultHis" sessonId:KSessionId requestData:params];
    
    [[SoapService shareInstance] PostAsync:str Success:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.tableView];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            
            NSArray *tempArr = [dic objectForKey:@"troubleHistoryList"];
            
            if (self.currentPage == 1) {
                [troubleHistoryArr removeAllObjects];
            }
            [troubleHistoryArr addObjectsFromArray:tempArr];
            
            if (troubleHistoryArr.count == 0){
                [self.view makeToast:@"未查询到排障历史记录"];
            }
            
            if (tempArr == nil || tempArr.count == 0) {
                self.currentPage --;
            }
            
            [self.tableView reloadData];
        }
        
        else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [self.view makeToast:@"请求失败"];
            
        }
        
        
        else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.view makeToast:@"会话超时,请重新登录"];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } falure:^(NSError *response) {
        [MBProgressHUD hideHUDForView:self.tableView];
        [self.view makeToast:@"请求失败"];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [troubleHistoryArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TroubleHistoryListCell *cell = [TroubleHistoryListCell cellWithTableView:tableView];
    
    NSDictionary *listDic = troubleHistoryArr[indexPath.row];
    
    cell.dealTime.text = [listDic objectForKey:@"dealTime"];
    cell.dealManName.text = [listDic objectForKey:@"dealManName"];
    cell.troubleSummary.text = [listDic objectForKey:@"troubleSummary"];
    cell.troubleDes.text = [listDic objectForKey:@"troubleDes"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
