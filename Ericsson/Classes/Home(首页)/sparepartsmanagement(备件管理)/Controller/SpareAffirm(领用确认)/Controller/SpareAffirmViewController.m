//
//  SpareAffirmViewController.m
//  Ericsson
//
//  Created by Min on 16/1/4.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "SpareAffirmViewController.h"
#import "ImgLabelHeadView.h"
#import "SpareSubmitListFourLabelCell.h"
#import "BorrowSpare.h"
#define mmCellHeight 52

@interface SpareAffirmViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet ImgLabelHeadView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property (nonatomic,strong) NSString * recordId;
@end

@implementation SpareAffirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];

    [self loadData];
}



-(void)setOthers{
    self.title = @"领用确认";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    _headView.oneLabel.text=@"请选择确认的备件";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
}

#pragma mark -request Data
- (void)loadData
{
    //请求数据示例
    NSDictionary *params = @{
                             @"pageIdx":@(currentPage)};

    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMSparePart" methodName:@"FSMGetSpareConfirm" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *dataArray = [BorrowSpare objectArrayWithKeyValuesArray:dic[@"orderLists"]];
            
            
            if (currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            
            if (dataArray == nil || dataArray.count == 0) {
                currentPage --;
            }
        }
        else{
            
            [self.view makeToast:KHudResponse1];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.view makeToast:KHudErrorMessage];
        
        if (currentPage > 1) {
            currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    }];
    
}


- (void)reloadResources{
    currentPage = 1;
    [self loadData];
}

- (void)reloadNewResources{
    currentPage ++;
    [self loadData];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return mmCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BorrowSpare *model = self.dataArray[indexPath.row];
    SpareSubmitListFourLabelCell *cell = [SpareSubmitListFourLabelCell cellWithTableView:tableView];
    cell.borrowSpare = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BorrowSpare *model = self.dataArray[indexPath.row];
    
    self.recordId = model.recordId;
    if ([model.flag isEqualToString:@"0"]) {
        // 弹出确认接口
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"领用确认" message:@"请确认此备件已领取!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
        // 发送一个请求，再次请求数据并刷新界面
    //请求数据示例
    NSDictionary *params = @{
                             @"recordId":self.recordId};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMSparePart" methodName:@"MygetSpareConfirm" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            // 重新请求数据
            [self loadData];
            
        }
        else{
            [self.view makeToast:KHudResponse1];
        }
        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.view makeToast:KHudErrorMessage];
    }];


}

#pragma mark -get/set
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
