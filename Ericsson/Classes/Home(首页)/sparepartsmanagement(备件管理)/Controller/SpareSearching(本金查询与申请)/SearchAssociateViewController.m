
//
//  SearchAssociateViewController.m
//  Ericsson
//
//  Created by Min on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "SearchAssociateViewController.h"
#import "SparePartsAssociateOrderModel.h"
#import "SearchAssociateOrderCell.h"

@interface SearchAssociateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 申请页面 */
@property (nonatomic,assign) int currentPage;

/** 可关联工单 */
@property (nonatomic,strong) NSMutableArray * associateArray;
/** 可关联字符串 */
@property (nonatomic,strong) NSString * associateOrderWoName;

/** 可关联工单 */
@property (nonatomic,strong) SparePartsAssociateOrderModel * associateOrderModel;
@end

@implementation SearchAssociateViewController
#pragma mark - set
- (NSMutableArray *)associateArray
{
    if (!_associateArray) {
        _associateArray = [[NSMutableArray alloc]init];
    }
    return _associateArray;
}
//- (void)setAssociateArray:(NSMutableArray *)associateArray
//{
//    _associateArray = associateArray;
//    [self.tableView reloadData];
//}
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"可关联工单";
    _currentPage = 1;
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
    // 请求数据
    [self requsetData];
}

- (void)reloadResources{
    self.currentPage = 1;
    [self requsetData];
}

- (void)reloadNewResources{
    self.currentPage ++;
    [self requsetData];
}

- (void)requsetData
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,
                             @"pageIdx":@(_currentPage)
                             };
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMSpareLinkWoList";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在获取管理工单"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            // 请求成功 执行跳转
            NSArray * associate  = [SparePartsAssociateOrderModel objectArrayWithKeyValuesArray:dic[@"woList"]];
            
            if (self.currentPage == 1) {
                [self.associateArray removeAllObjects];
            }
            
            [self.associateArray addObjectsFromArray:associate];
            [self.tableView reloadData];
            
            // ？？？？？？？
            if (associate == nil || associate == 0) {
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

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.associateArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SparePartsAssociateOrderModel * model = _associateArray[indexPath.row];
    
    SearchAssociateOrderCell * cell = [SearchAssociateOrderCell cellWithTableView:tableView];
    cell.woNameLabel.text = model.woName;
    cell.preEndTimeLabel.text = model.preStartTime;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击选中 获取到点击的是哪一个 并给我们的 -- 需要回调的NSString  赋值
    self.associateOrderModel = _associateArray[indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0;
}
#pragma mark - Button Event
- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnAssociate:(id)sender {
    if (!self.associateOrderModel) { // 为空
        
        [self.view makeToast:@"请选择关联工单"];
        return;
    }
    
    self.settingBlock(self.associateOrderModel);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
