//
//  DispatchUserViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "DispatchUserViewController.h"
#import "ContactOrderViewCell.h"
#import "WorkOrderUser.h"
#import "UnAccpetedOrderViewController.h"



@interface DispatchUserViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *selectedUsers;
@property (nonatomic,strong)NSArray *dispatchUsers;

@end

@implementation DispatchUserViewController

-(NSMutableArray *)selectedUsers{
    if (!_selectedUsers) {
        _selectedUsers = [[NSMutableArray alloc] init];
    }
    return _selectedUsers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadDispatchUsers];
    
}

- (void)loadDispatchUsers{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMRDispatchUser";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取二派受理人列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.dispatchUsers = [WorkOrderUser objectArrayWithKeyValuesArray:dic[@"persons"]];
            [self.tableView reloadData];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dispatchUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrderUser *dispatchUser = self.dispatchUsers[indexPath.row];
    
    ContactOrderViewCell *cell = [ContactOrderViewCell cellWithTableView:tableView];
    cell.orderName.font = [UIFont systemFontOfSize:18];
    cell.orderName.textColor = [UIColor blueColor];

    cell.switchFlag = false;
    cell.doneBtn.hidden = YES;
    
    
    if ([self.selectedUsers containsObject:dispatchUser]) {
        //185-151-105
        cell.backgroundColor = [UIColor colorWithRed:185/255.0 green:151/255.0 blue:105/255.0 alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *state;
    if ([dispatchUser.state isEqualToString:@"0"]) {
        state=@"空闲";
        
    }
    else if ([dispatchUser.state isEqualToString:@"1"]) {
        state=@"正在处理故障类工单";
        
    }
    else if ([dispatchUser.state isEqualToString:@"2"]) {
        state=@"正在处理非故障类工单";
        
    }
    
    UIFont *baseFont = [UIFont systemFontOfSize:13];
    NSString *str=[NSString stringWithFormat:@"%@(%@)",dispatchUser.name,state];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(dispatchUser.name.length, state.length+2)];//设置所有的字体


    cell.orderName.attributedText = attrString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkOrderUser *dispatchUser = self.dispatchUsers[indexPath.row];
    
    if ([self.selectedUsers containsObject:dispatchUser]) {
        [self.selectedUsers removeObject:dispatchUser];
    }else{
        [self.selectedUsers addObject:dispatchUser];
    }
    [self.tableView reloadData];
}


- (IBAction)CancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ChooseCommit:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(DispatchUserSelectedCommit:)]) {
        [self.delegate DispatchUserSelectedCommit:self.selectedUsers];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
