//
//  AnnounceViewContrller.m
//  Ericsson
//
//  Created by Min on 15/12/21.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AnnounceViewContrller.h"
#import "AnnounceNumberViewCell.h"
#import "AnnounceContentModel.h"
#import "AllAnnounceViewController.h"
#import "AnnounceSearchContentViewController.h"

@interface AnnounceViewContrller () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray * contents; // 目录
}

@property (nonatomic,strong)NSArray *orders;
/** 我的草稿数量 */
@property (nonatomic,strong)NSMutableArray *draftNums;
@end

@implementation AnnounceViewContrller

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 初始化
    contents = [NSArray arrayWithObjects:@"全部公告",@"已读公告",@"未读公告",@"我的草稿",@"我的公告",nil];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.dataSource       = self;
    self.tableView.delegate         = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces          = NO;
    self.title                      = @"公告管理";
    self.tableView.scrollEnabled    = NO;
    self.view.backgroundColor       = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 获取草稿的数量
    _draftNums = [AnnounceContentModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    
    //加载公告管理数据
    [self loadOrderData];
}


- (void)loadOrderData
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId};
    
    NSString *modelName = @"FSMAnnounce";
    NSString *methodName = @"FSMGetAnnounceNumbers";
    NSString *sessonId = sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取工单数量，请稍后"];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            NSString * numbers = dic[@"numbers"];
            
            NSRange range = [numbers rangeOfString:@"]"];
            NSRange numRange;
            numRange.location = 1;
            numRange.length = range.location -1;
            NSString * num = [numbers substringWithRange:numRange];
            self.orders = [num componentsSeparatedByString:@","];
            [self.tableView reloadData];
            
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
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnounceNumberViewCell * cell = [AnnounceNumberViewCell cellWithTable:tableView];
 
    cell.numCell_name.text = contents[indexPath.row];
    if (indexPath.row == 3) {
    [cell.numCell_numberBtn setTitle:[NSString stringWithFormat:@"%ld",_draftNums.count] forState:UIControlStateNormal];
    }else {
        NSNumber * num = self.orders[indexPath.row];
        if ([num isEqual:@""]) {
            num = @0;
        }
        [cell.numCell_numberBtn setTitle:[NSString stringWithFormat:@"%@",num?num:@""] forState:UIControlStateNormal];}

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row == 0) {
        
        AllAnnounceViewController * vc = [[AllAnnounceViewController alloc]init];
        vc.navTitle = @"全部公告";
        vc.annoucneType = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        
        AllAnnounceViewController * vc = [[AllAnnounceViewController alloc]init];
        vc.navTitle = @"已读公告";
        vc.annoucneType = 1;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        
        AllAnnounceViewController * vc = [[AllAnnounceViewController alloc]init];
        vc.navTitle = @"未读公告";
        vc.annoucneType = 2;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 3) {
        
        AnnounceSearchContentViewController * vc = [[AnnounceSearchContentViewController alloc]init];
        vc.navTitle = @"我的草稿";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 4) {
        
        AnnounceSearchContentViewController * vc = [[AnnounceSearchContentViewController alloc]init];
        vc.navTitle = @"我的公告";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
