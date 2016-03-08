//
//  ConsumeDistanceList.m
//  Ericsson
//
//  Created by xuming on 15/12/17.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ConsumeDistanceList.h"
#import "ImgLabelHeadView.h"
#import "OneLabelView.h"
#import "ThreeLabelView.h"
#import "ThreeLabelOneImgCell.h"
#import "ConsumeApplyCountViewController.h"

@interface ConsumeDistanceList ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ImgLabelHeadView *headView;
@property (weak, nonatomic) IBOutlet OneLabelView *oneLabelView;
@property (weak, nonatomic) IBOutlet ThreeLabelView *threeLabelView;
@property (nonatomic, strong) ConsumeApplyCountViewController *consumeApplyCountViewController;

@end

@implementation ConsumeDistanceList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    [self loadData];
}

-(void)setOthers{
    self.title = @"仓库库存列表";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.headView.oneLabel.text=@"库存列表";
    self.oneLabelView.oneLabel.text=[NSString stringWithFormat:@"申请耗材为:%@",self.consume.consumableName];
    self.threeLabelView.oneLabel.text=@"所属仓库";
    self.threeLabelView.twoLabel.text=@"库存量";
    self.threeLabelView.threeLabel.text=@"仓库距离km";
    
    
    
}

#pragma mark -request Data
- (void)loadData
{
    //请求数据示例
    
    NSDictionary *params = @{@"consumableId":self.consume.consumableId,
                             @"longitude":@(118.8028910000),
                             @"latitude":@(32.0647350000),
                             @"pageIdx":@(currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMConsumable" methodName:@"FSMConsumableDepotList" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *dataArray = [Consume objectArrayWithKeyValuesArray:dic[@"consumableDepotList"]];
            
            if (currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            //            NSLog(@"dic:%@",dic);
            
            if (dataArray == nil || dataArray.count == 0) {
                currentPage --;
            }
        }
        else{
            [self.view makeToast:KHudResponse1];

            
        
        }
        [self.tableView headerEndRefreshing];
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.view makeToast:KHudErrorMessage];


        if (currentPage > 1) {
            currentPage --;
        }
        [self.tableView headerEndRefreshing];
    }];
    
}


- (void)reloadResources{
    currentPage = 1;
    [self loadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Consume *data = self.dataArray[indexPath.row];
    
    ThreeLabelOneImgCell *cell = [ThreeLabelOneImgCell cellWithTableView:tableView];
    cell.oneLabel.text = data.depotName;
    cell.twoLabel.text = data.depotNumber;
    cell.threeLabel.text=data.distinction;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    self.consumeApplyCountViewController.consume=_dataArray[indexPath.row];
    _consumeApplyCountViewController.consume.consumableId=self.consume.consumableId;
    _consumeApplyCountViewController.consume.consumableName=self.consume.consumableName;
    _consumeApplyCountViewController.consume.consumableModel=self.consume.consumableModel;
    [self.navigationController pushViewController:_consumeApplyCountViewController animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -get/set
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(ConsumeApplyCountViewController *)consumeApplyCountViewController{
    if (_consumeApplyCountViewController==nil) {
        _consumeApplyCountViewController=[[ConsumeApplyCountViewController alloc]init];

    }
    return _consumeApplyCountViewController;

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
