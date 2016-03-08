//
//  AcceptWithView.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/10.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AcceptWithView.h"
#import "WorkOrderBaseInfo.h"
#import "WorkOrder.h"
#import "HandledOrderCell.h"

@interface AcceptWithView()

@property (nonatomic,strong)NSMutableArray *selectedOrders;//选中一同受理的工单

@property (nonatomic,assign)int currentPage;

@end

@implementation AcceptWithView

-(NSMutableArray *)selectedOrders{
    if (!_selectedOrders) {
        _selectedOrders = [[NSMutableArray alloc] init];
    }
    return _selectedOrders;
}


-(void)setSameSiteOrders:(NSMutableArray *)sameSiteOrders{
    _sameSiteOrders = sameSiteOrders;
    
    [self.tableView reloadData];
}

-(void)setOrderBaseInfo:(WorkOrderBaseInfo *)orderBaseInfo{
    _orderBaseInfo = orderBaseInfo;
    
    //根据站点id获取同站点代办工单列表
    //此处进行修改不再进入并同受理界面重新加载同站点待受理工单数据，改为从待受理工单详情界面获取并传入
//    [self getSameSiteOrders];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    self.currentPage = 1;
//    [self.tableView addHeaderWithTarget:self action:@selector(reloadSameSiteOrders)];
//    
//    [self.tableView addFooterWithTarget:self action:@selector(loadNewSameSiteOrders)];
}

- (void)reloadSameSiteOrders{
    self.currentPage = 1;
    [self getSameSiteOrders];
}

- (void)loadNewSameSiteOrders{
    self.currentPage ++;
    [self getSameSiteOrders];
}

-(void)getSameSiteOrders{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"pageIdx":@(self.currentPage),@"mObjectCode":self.orderBaseInfo.maintenanceObjectId};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetSameSiteWo";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
//    [MBProgressHUD showMessage:@"正在发送获取同站点待受理工单列表请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
//        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *orders = [WorkOrder objectArrayWithKeyValuesArray:dic[@"woList"]];
            if (self.currentPage == 1) {
                [self.sameSiteOrders removeAllObjects];
            }
            
            [self.sameSiteOrders addObjectsFromArray:orders];
            [self.tableView reloadData];
            
            if (orders == nil || orders.count == 0) {
                self.currentPage --;
            }
            [MBProgressHUD showSuccess:@"获取同站点待受理工单列表成功"];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [MBProgressHUD showError:@"获取同站点待受理工单列表失败，请重试"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"会话超时，请重新登录"];
            
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } falure:^(NSError *err) {
//        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"获取同站点待受理工单列表请求发送错误,err:%@",err]];
        
        if (self.currentPage > 1) {
            self.currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sameSiteOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrder *order = self.sameSiteOrders[indexPath.row];
    
    HandledOrderCell *cell = [HandledOrderCell cellWithTableView:tableView];
    cell.icon.image = [UIImage imageNamed:[self iconNameWithResourceType:order.type]];
    cell.firstLabel.text = order.title;
    NSRange range = NSMakeRange(5, 11);
    cell.secondLabel.text = [order.time substringWithRange:range];
    
    if ([self.selectedOrders containsObject:order]) {
        cell.backgroundColor = [UIColor colorWithRed:185/255.0 green:151/255.0 blue:105/255.0 alpha:1.0];
    }else
        cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSString *)iconNameWithResourceType:(NSString *)type{
    if ([type containsString:@"发电"]) {
        return @"wo_elect";
    }else if ([type containsString:@"故障"]){
        return @"wo_tr";
    }else
        return @"wo_with";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkOrder *order = self.sameSiteOrders[indexPath.row];
    if ([self.selectedOrders containsObject:order]) {
        [self.selectedOrders removeObject:order];
    }else
        [self.selectedOrders addObject:order];
    
    [self.tableView reloadData];
    
    if (self.selectedOrders.count > 0) {
        self.commitBtn.enabled = YES;
    }else
        self.commitBtn.enabled = NO;
}


- (IBAction)commit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(acceptWithViewDidCommitWith:)]) {
        [self.delegate acceptWithViewDidCommitWith:self.selectedOrders];
    }
}

- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(acceptWithViewDidCancel)]) {
        [self.delegate acceptWithViewDidCancel];
    }
}
@end
