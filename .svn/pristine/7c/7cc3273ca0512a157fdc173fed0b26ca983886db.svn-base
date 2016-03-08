//
//  ConsumeList.m
//  Ericsson
//
//  Created by xuming on 15/12/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ConsumeList.h"
#import "TwoLabelOneImgCell.h"
#import "Consume.h"
#import "TwoLabelView.h"
#import "ConsumeDistanceList.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface ConsumeList () <BMKLocationServiceDelegate>
{
    BMKLocationService * _locService;
}
@property (weak, nonatomic) IBOutlet TwoLabelView *twoLabelView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)ConsumeDistanceList *consumeDistanceList;

/** 经度 */
@property (nonatomic ,assign) double latitudeList;

@property (nonatomic ,assign) double longitudeList;

@end

@implementation ConsumeList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    // 百度地图API
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    
    [self loadData];
}

-(void)setOthers{
    self.title = @"耗材列表";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    
    self.twoLabelView.oneLabel.text=@"耗材名称";
    self.twoLabelView.twoLabel.text=@"耗材型号";

    

}

#pragma mark -request Data
- (void)loadData
{
    //请求数据示例
    
    NSDictionary *params = @{@"vendor":self.vendor,//厂商
                             @"consumableName":self.consumableName,//耗材名称
                             @"consuableType":self.consuableType,//耗材类型
                             @"pageIdx":@(currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMConsumable" methodName:@"FSMQuerySpareParts" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];

        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *dataArray = [Consume objectArrayWithKeyValuesArray:dic[@"consumableArrayList"]];

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
    
    TwoLabelOneImgCell *cell = [TwoLabelOneImgCell cellWithTableView:tableView];
    cell.oneLabel.text = data.consumableName;
    cell.twoLabel.text = data.consumableModel;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{



    self.consumeDistanceList.consume=_dataArray[indexPath.row];
    self.consumeDistanceList.latitude = _latitudeList;
    self.consumeDistanceList.longitude = _longitudeList;
    [self.navigationController pushViewController:_consumeDistanceList animated:YES];


    
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

-(ConsumeDistanceList *) consumeDistanceList{
    if (_consumeDistanceList==nil) {
        _consumeDistanceList=[[ConsumeDistanceList alloc]init];

    }
    return _consumeDistanceList;

}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _latitudeList = userLocation.location.coordinate.latitude;
    _longitudeList = userLocation.location.coordinate.longitude;
}

@end
