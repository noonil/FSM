//
//  OperatingGuideList.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/6.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "OperatingGuideList.h"
#import "GotoWebCell.h"
#import "TechnicalManualDetailViewController.h"

@interface OperatingGuideList ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *oprProInfoArr; //用于存放操作规程列表信息
    NSString *operateTitle; //操作规程的标题
    NSMutableArray *operateTitleArr; //存放操作规程的标题的数组
    NSMutableArray *operateContentArr; //存放操作规程内容地址
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)int currentPage;   //记录当前页码

@end

@implementation OperatingGuideList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"操作规程";
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    oprProInfoArr = [NSMutableArray array];
    operateTitleArr = [NSMutableArray array];
    operateContentArr = [NSMutableArray array];
    
    self.currentPage = 1;
    [self loadData];
    
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

#pragma mark —— 重写 set/get 方法
-(NSString *)workTypesId{
    if (_workTypesId == nil) {
        _workTypesId = @"";
    }
    return _workTypesId;
}

-(NSString *)workChildTypesId{
    if (_workChildTypesId == nil) {
        _workChildTypesId = @"";
    }
    return _workChildTypesId;
}

#pragma mark  -- loadData
-(void)loadData{
    
    NSDictionary *params = @{@"pageIdx":@(self.currentPage),@"workOrderChildType":self.workChildTypesId,@"workOrderType":self.workTypesId};
    NSString *sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMMaterial" methodName:@"FSMGetOprGuide" sessonId:KSessionId requestData:params];
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        
        if ([dic[@"retCode"] isEqual:@0]){
            NSArray *tempArr = dic[@"oprProInfo"];
            
            if (self.currentPage == 1) {
                [oprProInfoArr removeAllObjects];
            }
            [oprProInfoArr addObjectsFromArray:tempArr];
            
            if (tempArr == nil || tempArr.count == 0) {
                self.currentPage --;
            }
            
            if (oprProInfoArr.count != 0) {
                [operateTitleArr removeAllObjects];
                [operateContentArr removeAllObjects];
                for (NSDictionary *oprProInfoDic in oprProInfoArr) {
                    operateTitle = oprProInfoDic[@"operateTitle"];
                    [operateTitleArr addObject:operateTitle];
                    //操作规程的内容地址
                    NSString *operateContentStr = oprProInfoDic[@"operateContent"];
                    [operateContentArr addObject:operateContentStr];
                }
            }
            else{
                [self.view makeToast:@"未查询到相关信息"];
            }
            
            [_tableView reloadData];
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
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [oprProInfoArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GotoWebCell *cell = [GotoWebCell cellWithTableView:tableView];
    
    cell.titleLabel.text = operateTitleArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TechnicalManualDetailViewController *webView = [[TechnicalManualDetailViewController alloc] init];
    webView.urlStr = operateContentArr[indexPath.row];
    
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
