//
//  TechnicalManualList.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/6.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "TechnicalManualList.h"
#import "GotoWebCell.h"
#import "TechnicalManualDetailViewController.h"

@interface TechnicalManualList ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *manualListArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)int currentPage;   //记录当前页码
@end

@implementation TechnicalManualList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"技术手册";
    
    [MBProgressHUD showMessage:@"正在获取……"];
    
    manualListArr = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.currentPage = 1;//初始化页码为1
    [self loadData];
    
    //添加上拉下拉刷新
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


//数据请求
-(void)loadData{
    
    NSDictionary *params = @{@"factory":self.factoryId,@"model":self.techModelId,@"type":self.techTypeId,@"pageIdx":@(self.currentPage)};
    
    NSString *sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMMaterial" methodName:@"FSMGetTechDoc" sessonId:KSessionId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *tempArr =  [dic objectForKey:@"technicalManualList"];

            if (self.currentPage == 1) {
                [manualListArr removeAllObjects];
            }
            
            [manualListArr addObjectsFromArray:tempArr];
            
            if (tempArr == nil || tempArr.count == 0) {
                self.currentPage --;
            }
            
            [self.tableView reloadData];
        
        }
        
        else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [self.view makeToast:@"请求失败"];
            
        }
        
        //会话超时，重新登录
        else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.view makeToast:@"会话超时,请重新登录"];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } falure:^(NSError *response) {
        [MBProgressHUD hideHUD];
        [self.view makeToast:@"获取技术手册信息失败"];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [manualListArr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GotoWebCell *cell = [GotoWebCell cellWithTableView:tableView];
    
    NSDictionary *dic = manualListArr[indexPath.row];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = manualListArr[indexPath.row];
    NSString *urlStr = [dic objectForKey:@"content"];
    
    TechnicalManualDetailViewController *webView = [[TechnicalManualDetailViewController alloc] init];
    webView.urlStr = urlStr;
    
    [self presentViewController:webView animated:YES completion:nil];
    
//    [self.navigationController pushViewController:webView animated:YES];
    
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
