//
//  completeListViewController.m
//  Ericsson
//
//  Created by Slark on 16/1/18.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "completeListViewController.h"
#import "completeListModel.h"
#import "completeListTableViewCell.h"
#import "completeDetailViewController.h"
@interface completeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)int current;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * woId;
@end

@implementation completeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     self.dataArr = [NSMutableArray array];
    self.current = 1;
    [self createUI];
    self.title  = @"已处理巡检工单";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"completeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"NARUTO"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)createUI{
    
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMFinshedPolling";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [defaults objectForKey:@"username"];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary * params = @{@"userId":userId,
                              @"pageIdx":@(self.current),
                              @"ruleId":self.str};
    
    NSString * sopStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
    [[SoapService shareInstance] PostAsync:sopStr Success:^(NSDictionary *dic) {
        [MBProgressHUD showMessage:@"正在请求"];
        
        if([dic[@"retCode"] isEqual:@0]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            
            NSArray * array = dic[@"woList"];
            
            for (NSDictionary * dict in array) {
                completeListModel * model = [[completeListModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArr addObject:model];
                
                
            }
            
            [self.tableView reloadData];
            
        }
        
    } falure:^(NSError *response) {
        
    }];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataArr.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    completeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NARUTO" forIndexPath:indexPath];
    
    completeListModel * model = self.dataArr[indexPath.row];
    
    [cell loadDataFromModel:model];
    
    cell.accessoryType = UITableViewCellStyleValue1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    completeDetailViewController * detail = [[completeDetailViewController alloc]init];
    
    completeListModel * model = self.dataArr[indexPath.row];
    detail.sss = model.title;
    self.woId = model.woId;
    detail.woId = self.woId;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
    
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
