//
//  LogSubViewController.m
//  Ericsson
//
//  Created by 陶山强 on 16/3/2.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "LogSubViewController.h"

@interface LogSubViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger currentPage;
@end

@implementation LogSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -50, KIphoneWidth, KIphoneHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self reloadNewData];
    [self.tableView addFooterWithTarget:self action:@selector(reloadMoreData)];
    self.array = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    if ([self.secType isEqualToString:@"1"]) {
        self.title = @"登陆成功日志";
    }else if ([self.secType isEqualToString:@"2"]) {
        self.title = @"尝试成功日志";
    }else  if ([self.secType isEqualToString:@"3"]) {
        self.title = @"修改成功日志";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reloadNewData{
    self.currentPage = 1;
    [self json];
}
-(void)reloadMoreData{
    self.currentPage ++;
    [self json];
}
-(void)json{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    //NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"secType":self.secType,
                             @"page":@(self.currentPage)};
    
    NSString *modelName=@"FSMset";
    NSString *methodName=@"FSMGetLog";
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在请求成功登陆日志"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"请求成功登陆日志成功"];
            NSLog(@"%@--------------------------",dic);
            self.array = dic[@"logs"];
            for (NSDictionary * di in self.array) {
                NSString * str = di[@"time"];
                NSString * sss = di[@"status"];
                [self.dataArray addObject:str];
                [self.dataArr addObject:sss];
                
                
            }
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"请求成功登陆日志失败"];
             [self.tableView footerEndRefreshing];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"请求成功登陆日志超时，请重新请求"];
             [self.tableView footerEndRefreshing];
            
        }
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"成功登陆日志请求发送失败,err:%@",err]];
         [self.tableView footerEndRefreshing];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    NSLog(@"%ld",self.dataArr.count);
            return self.dataArr.count;
   }



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LogCell"];
    }
        NSString * str = self.dataArr[indexPath.row];
        NSString * sss = self.dataArray[indexPath.row];
        
        cell.textLabel.text = str;
        cell.detailTextLabel.text = sss;
    
    return cell;
}



// 定义头标题的视图，添加点击事件
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
