//
//  SecurityLogViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "SecurityLogViewController.h"
#import "LogSectionHeader.h"
#import "LogSubViewController.h"

@interface SecurityLogViewController ()<LogSectionHeaderDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *arrary;
@property(nonatomic,strong)NSMutableArray *arrary2;
@property(nonatomic,strong)NSMutableArray *arrary3;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * dataArr2;
@property (nonatomic,strong)NSMutableArray * dataArray2;
@property (nonatomic,strong)NSMutableArray * dataArr3;
@property (nonatomic,strong)NSMutableArray * dataArray3;


@end
static int idx=0;
static int idx2=0;
static int idx3=0;


@implementation SecurityLogViewController
{
    int i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全日志";
    i = 1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];

    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    self.dataArr = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.dataArr2 = [NSMutableArray array];
    self.dataArray2 = [NSMutableArray array];
    self.dataArr3 = [NSMutableArray array];
    self.dataArray3 = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0) {
        if (idx%2==1) {
            
            return self.dataArr.count;
            
        }else{
            
            return 0;
        }
    }
    if (section==1) {
        if (idx2%2==1) {
            
            return self.dataArr2.count;
            
        }else{
            
            return 0;
        }
    }
    if (section==2) {
        if (idx3%2==1) {
            
            return self.dataArr3.count;
            
        }else{

            return 0;
                    }
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LogCell"];
    }
    
    if (indexPath.section == 0) {
        NSString * str = self.dataArr[indexPath.row];
        NSString * sss = self.dataArray[indexPath.row];
        
        cell.textLabel.text = str;
        cell.detailTextLabel.text = sss;
        
    }
    if (indexPath.section == 1) {
        NSString * str = self.dataArr2[indexPath.row];
        NSString * sss = self.dataArray2[indexPath.row];
        
        cell.textLabel.text = str;
        cell.detailTextLabel.text = sss;
        
    }
    if (indexPath.section == 2) {
        NSString * str = self.dataArr3[indexPath.row];
        NSString * sss = self.dataArray3[indexPath.row];
        
        cell.textLabel.text = str;
        cell.detailTextLabel.text = sss;
        
    }
    
    return cell;
}



// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //获取驾驶信息
    LogSectionHeader *sectionHeaderView = [LogSectionHeader SectionHeaderView];
    sectionHeaderView.headIcon.image = [UIImage imageNamed:@"spare_search"];
    
    if (section==0) {
        if (idx%2==1) {
            
            sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"uppoint"];
        }else{
            
           sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"downpoint"];
        }
    }
    if (section==1) {
        if (idx2%2==1) {
            
            sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"uppoint"];
            
        }else{
            
            sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"downpoint"];
        }
    }
    if (section==2) {
        if (idx3%2==1) {
            
            sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"uppoint"];
        }else{
            
            sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"downpoint"];
        }
    }

    
    //sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"uppoint"];
    if(section==0){sectionHeaderView.contentLabel.text = @"登陆成功日志";}
    if(section==1){sectionHeaderView.contentLabel.text = @"尝试成功日志";}
    if(section==2){sectionHeaderView.contentLabel.text = @"修改成功日志";}
    
    sectionHeaderView.contentLabel.textColor = [UIColor colorWithRed:252/255.0 green:120/255.0 blue:38/255.0 alpha:1.0];
    
    sectionHeaderView.delegate = self;
    sectionHeaderView.section = section;
    return  sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//static bool a=YES;

-(void)SectionHeaderBtnClick:(NSInteger) section
{
    
    //切换展开收缩
   
    if (section==0) {
        LogSubViewController *subVC = [[LogSubViewController alloc]init];
        subVC.secType = @"1";
        [self.navigationController pushViewController:subVC animated:YES];
        
    }
    if (section==1) {
        LogSubViewController *subVC = [[LogSubViewController alloc]init];
        subVC.secType = @"2";
        [self.navigationController pushViewController:subVC animated:YES];
          }
    if (section==2) {
        LogSubViewController *subVC = [[LogSubViewController alloc]init];
        subVC.secType = @"3";
        [self.navigationController pushViewController:subVC animated:YES];
           }

}

-(void)json{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    //NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"secType":@(1),
                             @"page":@(1)};
    
    NSString *modelName=@"FSMset";
    NSString *methodName=@"FSMGetLog";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在请求成功登陆日志"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"请求成功登陆日志成功"];
             NSLog(@"%@--------------------------",dic);
            self.arrary = dic[@"logs"];
            for (NSDictionary * di in self.arrary) {
                NSString * str = di[@"time"];
                NSString * sss = di[@"status"];
                [self.dataArray addObject:str];
                [self.dataArr addObject:sss];
                
                
            }
            [self.tableView reloadData];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"请求成功登陆日志失败"];

        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"请求成功登陆日志超时，请重新请求"];
            
        }
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"成功登陆日志请求发送失败,err:%@",err]];
    }];
    
}

-(void)json2{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    //NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"secType":@(2),
                             @"page":@(1)};
    
    NSString *modelName=@"FSMset";
    NSString *methodName=@"FSMGetLog";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在请求尝试登陆日志"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"请求尝试登陆日志成功"];
            //     NSLog(@"%@--------------------------",dic);
            self.arrary2 = dic[@"logs"];
            for (NSDictionary * di in self.arrary2) {
                NSString * str = di[@"time"];
                NSString * sss = di[@"status"];
                [self.dataArray2 addObject:str];
                [self.dataArr2 addObject:sss];
                

                
             
            }
               [self.tableView reloadData];
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"请求尝试登陆日志失败"];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"请求尝试登陆日志超时，请重新请求"];
            
        }
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"尝试登陆日志请求发送失败,err:%@",err]];
    }];
    
}

-(void)json3{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    //NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"secType":@(3),
                             @"page":@(1)};
    
    NSString *modelName=@"FSMset";
    NSString *methodName=@"FSMGetLog";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在请求修改密码日志"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"请求修改密码日志成功"];
                NSLog(@"%@--------------------------",dic);
            self.arrary3 = dic[@"logs"];
            for (NSDictionary * di in self.arrary3) {
                NSString * str = di[@"time"];
                NSString * sss = di[@"status"];
                [self.dataArray3 addObject:str];
                [self.dataArr3 addObject:sss];
                

                
           
            }
                 [self.tableView reloadData];
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"请求修改密码日志失败"];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"请求修改密码日志超时，请重新请求"];
            
        }
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"尝试修改密码请求发送失败,err:%@",err]];
    }];
    
}


@end
