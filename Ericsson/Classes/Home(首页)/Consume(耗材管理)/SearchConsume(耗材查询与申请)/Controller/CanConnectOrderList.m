//
//  CanConnectOrderList.m
//  Ericsson
//
//  Created by xuming on 15/12/20.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "CanConnectOrderList.h"
#import "SparePartsAssociateOrderModel.h"
#import "HandledOrderCell.h"
#import "ConsumeApplyOhtersViewController.h"

@interface CanConnectOrderList ()
{
    SparePartsAssociateOrderModel *selectedModel;
}
@property (strong, nonatomic) NSMutableArray *dataArray;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn_TouchDown:(id)sender;
- (IBAction)connectBtn_TouchDown:(id)sender;


@end

@implementation CanConnectOrderList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    [self loadData];
}

-(void)setOthers{
    self.title = @"可关联工单";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    
    
    
    
}

#pragma mark -request Data
- (void)loadData
{
    //请求数据示例
    
    NSDictionary *params = @{@"userId":userId,
                             @"pageIdx":@(1)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMworkOrder" methodName:@"FSMSpareLinkWoList" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *dataArray = [SparePartsAssociateOrderModel objectArrayWithKeyValuesArray:dic[@"woList"]];
            

            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            

        }
        else{
            
            [self.view makeToast:KHudResponse1];
        
        }
        [self.tableView headerEndRefreshing];
    } falure:^(NSError *err) {

        [MBProgressHUD hideHUD];
        [self.view makeToast:KHudErrorMessage];
        
        [self.tableView headerEndRefreshing];
    }];
    
}


- (void)reloadResources{
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
    SparePartsAssociateOrderModel *model = self.dataArray[indexPath.row];
    
    HandledOrderCell *cell = [HandledOrderCell cellWithTableView:tableView];
    cell.icon.image = [UIImage imageNamed:@"wo_tr"];
    cell.firstLabel.text = model.woName;
    cell.secondLabel.text = model.preStartTime;

    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    selectedModel = self.dataArray[indexPath.row];
    
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


#pragma mark - action

- (IBAction)backBtn_TouchDown:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)connectBtn_TouchDown:(id)sender {
    
    
    NSInteger count= self.navigationController.viewControllers.count;
    ConsumeApplyOhtersViewController *vc=self.navigationController.viewControllers[count-2];
    vc.canConnectWork=selectedModel;
    [self.navigationController popViewControllerAnimated:self];
}
@end





