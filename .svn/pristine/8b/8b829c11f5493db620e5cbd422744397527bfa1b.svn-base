//
//  InspectionFeedbackOrderViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/13.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "InspectionFeedbackOrderViewController.h"
#import "OrderViewCell.h"
#import "feedBackModel.h"
#import "handingWokerTableViewCell.h"
#import "DetailViewController.h"

@interface InspectionFeedbackOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)int num;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSString * woId;


@end

@implementation InspectionFeedbackOrderViewController
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    [self requestMoreData];
//    [self.tableView reloadData];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检阶段性反馈工单";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
     [self requestMoreData];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"handingWokerTableViewCell" bundle:nil] forCellReuseIdentifier:@"IDD"];
    
}

- (void)requestMoreData{
  
    self.num = 1;
    self.dataArr = [NSMutableArray array];
   
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMSectionFeedBackWOList";
    NSDictionary * params = @{@"pageIdx":@(self.num)};
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];

    [MBProgressHUD showMessage:@"正在请求巡检反馈工单列表"];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
       
        
        if([dic[@"retCode"] isEqual:@0]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            
            NSArray * array = dic[@"woSectionFeedBackList"];
            
            for (NSDictionary * dict in array) {
                feedBackModel * model = [[feedBackModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArr addObject:model];
                
               
            }
            
            [self.tableView reloadData];
            
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
   // return 10;
    
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    feedBackModel * model = self.dataArr[indexPath.row];
    
    handingWokerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IDD" forIndexPath:indexPath];
    
    
    [cell loadDataFromModelone:model];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    feedBackModel * model = self.dataArr[indexPath.row];
    self.woId = model.woId;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController * detail = [[DetailViewController alloc]init];
    detail.woId = self.woId;
   
    [self.navigationController pushViewController:detail animated:YES];
}

@end
