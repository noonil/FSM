//
//  InspectionRuleViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/12.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "InspectionRuleViewController.h"
#import "NumberViewCell.h"
#import "InspectionOrderViewController.h"
#import "Xunjian_1.h"

@interface InspectionRuleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)Xunjian_1 * xun;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation InspectionRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"巡检管理列表";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self loadMoreData];
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

- (void)loadMoreData{
    
    NSString * methodName = @"FSMGetCheckPlanRule";
    NSString * modelName = @"FSMworkOrder";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
   
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * userId = [defaults objectForKey:@"username"];
  
    NSDictionary * params = @{@"userId":userId};//@"pageIdx":_xun.pageID};
   
    NSString * sessonId = sessionId;
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    [MBProgressHUD showMessage:@"正在请求数据"];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            NSMutableArray * array = dic[@"planRules"];
            
            for (NSDictionary * dict in array) {
                
                Xunjian_1 * xun = [[Xunjian_1 alloc]init];
                
                [xun setValuesForKeysWithDictionary:dict];
                
                [self.dataArr addObject:xun];
                
                [self.tableView reloadData];
            }
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [self.navigationController.view makeToast:@"请求失败"];
            
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
         
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            
            [self.navigationController.view makeToast:@"请求超时,请重新登录"];
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
    NumberViewCell *cell = [NumberViewCell cellWithTableView:tableView];

    Xunjian_1 * model = self.dataArr[indexPath.row];
    
    [cell loadDataFromModel:model];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xunjian_1 * xun  = _dataArr[indexPath.row];
    
    InspectionOrderViewController *inspectionOrder = [[InspectionOrderViewController alloc] init];
    inspectionOrder.ruleId = xun.ruleId;
    
    
    [self.navigationController pushViewController:inspectionOrder animated:YES];
}

@end
