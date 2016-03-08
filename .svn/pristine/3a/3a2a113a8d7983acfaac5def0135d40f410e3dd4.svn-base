//
//  OrderProcessingViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/12.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "OrderProcessingViewController.h"
#import "OrderViewCell.h"
#import "HandingDetailViewController.h"
#import "HandingWokerListModel.h"
#import "handingWokerTableViewCell.h"
#import "MJExtension.h"

@interface OrderProcessingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)int current;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * str;
@property (nonatomic,copy)NSString * WokerId;

@end

@implementation OrderProcessingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self loadMoreData];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    self.title = @"正在处理巡检工单";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.dataArr = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"handingWokerTableViewCell" bundle:nil] forCellReuseIdentifier:@"IDD"];
  
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    self.current = 1;
    [self loadMoreData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}



- (void)reloadResources{
    
    [self loadMoreData];
    
    
}

- (void)reloadNewResources{
    
    self.current  ++;    
    [self loadMoreData];
    
    
}


- (void)loadMoreData{
    
  
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * userId = [defaults objectForKey:@"username"];
    
    NSString * methodName = @"FSMGetAcceptWO";
    NSString * modelName = @"FSMworkOrder";
    NSDictionary * params = @{@"userId":userId,@"pageIdx":@(self.current),@"searchWoType":@1};
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
   // [MBProgressHUD showMessage:@"正在请求"];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        
        if ([dic[@"retCode"] isEqual:@0]) {
           // [MBProgressHUD hideHUD];
            
            [MBProgressHUD showSuccess:@"请求成功"];
            NSArray * array = dic[@"woList"];
            for (NSDictionary * dict in array) {
               
                HandingWokerListModel * model = [[HandingWokerListModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArr addObject:model];

            }
            
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [self.navigationController.view makeToast:@"请求失败"];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时,请重新登录"];
            
            
            
        }
        
        
    } falure:^(NSError *response) {
        
        
        
        
    }];
    
    
    
    
    
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
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    handingWokerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IDD" forIndexPath:indexPath];
    HandingWokerListModel * model = _dataArr[indexPath.row];
    [cell loadDataFromModel:model];
    cell.accessoryType = UITableViewCellStyleValue1;
    
    
           return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HandingWokerListModel * model = _dataArr[indexPath.row];
    self.str = model.title;
    self.WokerId = model.woId;
    
    HandingDetailViewController * detail = [[HandingDetailViewController alloc]init];
    detail.Maintitle = self.str;
    detail.woId = self.WokerId;
    detail.ruleId = self.ruleId;
    [self.navigationController pushViewController:detail animated:YES];
    
    
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
