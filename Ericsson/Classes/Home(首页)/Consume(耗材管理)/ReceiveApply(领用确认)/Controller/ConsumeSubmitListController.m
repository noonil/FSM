//
//  ConsumeSubmitListController.m
//  Ericsson
//
//  Created by xuming on 15/12/31.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ConsumeSubmitListController.h"
#import "ImgLabelHeadView.h"
#import "BorrowConsume.h"
#import "ConsumeSubmitListFourLabelCell.h"

#define mmCellHeight 50

@interface ConsumeSubmitListController ()<UIAlertViewDelegate>
{

}
@property (weak, nonatomic) IBOutlet ImgLabelHeadView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArray;

@end

@implementation ConsumeSubmitListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setOthers];
    
    
    [self loadData];
}

-(void)setOthers{
    self.title = @"领用确认";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    _headView.oneLabel.text=@"请选择确认的耗材";
    
    
    
    

    
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];


}

#pragma mark -request Data
- (void)loadData
{

    [MBProgressHUD showMessage:KHudIsRequestMessage];

    NSDictionary *params = @{
                             @"pageIdx":@(currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMConsumable" methodName:@"FSMMyConsumableConfirmList" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *dataArray = [BorrowConsume objectArrayWithKeyValuesArray:dic[@"orderLists"]];
            
            if (currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
//            for (int i=0; i<2; i++) {
//                BorrowConsume *model=dataArray[i];
//                model.flag=0;
//            }
            
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


//领用申请确认请求。
-(void)submitRequest:(BorrowConsume *)model{

    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    NSDictionary *params = @{
                             @"borrowId":model.borrowId};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMConsumable" methodName:@"FSMInsertConfirmTable" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {

            [self.view makeToast:@"申领成功"];
            
            [self loadData];

        }
        else if ([dic[@"retCode"]  isEqual: @(-1)]) {
            
            [self.view makeToast:KHudResponse1];
        }
        else if ([dic[@"retCode"]  isEqual: @(-2)]) {
            
            [self.view makeToast:KHudResponse2];
        }
        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.view makeToast:KHudErrorMessage];
        

        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return mmCellHeight;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BorrowConsume *model = self.dataArray[indexPath.row];
    

    ConsumeSubmitListFourLabelCell *cell = [ConsumeSubmitListFourLabelCell cellWithTableView:tableView];
    cell.borrowConsume=model;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BorrowConsume *model=_dataArray[indexPath.row];
    
    if (![model.flag isEqualToString:@"1"]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否确认领用" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.delegate=self;
        alert.tag=indexPath.row;
        [alert show];
    }
    

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex//点击弹窗按钮后
{
    
    if (buttonIndex == 0) {//取消
    
    }else if (buttonIndex == 1){//确定
        [self submitRequest:_dataArray[alertView.tag]];

    }
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






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
