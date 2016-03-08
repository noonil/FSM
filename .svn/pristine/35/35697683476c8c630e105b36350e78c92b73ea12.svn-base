//
//  OrderCompletedViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/13.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "OrderCompletedViewController.h"
#import "OrderViewCell.h"
#import "completeModel.h"
#import "completedTableViewCell.h"
#import "completeListViewController.h"
@interface OrderCompletedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)    int current;
@property (nonatomic,strong)    NSMutableArray * dataArr;
@property (nonatomic,copy)      NSString * sss;
@end

@implementation OrderCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.current = 1;
    self.title = @"已处理巡检工单";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"completedTableViewCell" bundle:nil] forCellReuseIdentifier:@"LUFY"];
    self.dataArr = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self requestData];
    [self.view addSubview:self.tableView];
    
}


- (void)requestData{
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [defaults objectForKey:@"userId"];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMGetCheckPlanRule";
    
    NSDictionary * dict = @{@"userId":userId,@"pageIdx":@(self.current),@"finshed":@1};
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:dict];
    
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD showMessage:@"正在请求"];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            NSArray * array = dic[@"planRules"];
            for (NSDictionary * dict in array) {
                completeModel * model = [[completeModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArr addObject:model];
                
            }
            
            [self.tableView reloadData];
            
        }
        
        
        
        
    } falure:^(NSError *response) {
        
    }];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    completeListViewController * list = [[completeListViewController alloc]init];
    
    completeModel * model = self.dataArr[indexPath.row];
    
    
    self.sss = model.ruleId;
    list.str = self.sss;
    
    [self.navigationController pushViewController:list animated:YES];
    
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    completedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LUFY" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellStyleValue1;
    
    
    completeModel * model = self.dataArr[indexPath.row];
    [cell loadDataFromModel:model];
    
    return cell;
}

@end
