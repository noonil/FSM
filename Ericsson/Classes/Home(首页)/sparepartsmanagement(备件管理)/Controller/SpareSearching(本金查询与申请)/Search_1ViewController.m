//
//  Search_1ViewController.m
//  Ericsson
//
//  Created by slark on 15/12/21.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "Search_1ViewController.h"
#import "Search_2ViewController.h"
#import "SparePartList.h"
#import "TwoLabelOneImgCell.h"
#import "SparePartStoresModel.h"
#import "SparePartList.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface Search_1ViewController ()<BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate>
{
      BMKLocationService * _locService;
}
@property (nonatomic,strong)IBOutlet UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
/** 数组模型 */
@property (nonatomic,strong) NSMutableArray * sparePartListArray;

@property (nonatomic,assign) int currentPage; // 记录当前页
@property (nonatomic,assign) double latitude_1;
@property (nonatomic,assign) double longitude_1;

@end

@implementation Search_1ViewController

#pragma mark - Lazy
- (NSMutableArray*)sparePartListArray
{
    if (!_sparePartListArray) {
        _sparePartListArray = [[NSMutableArray alloc]init];
    }
    return _sparePartListArray;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"备件列表";
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self creatUI];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
    // 百度地图API
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
  
    self.currentPage = 1;
    // 数据请求 成功后进行跳转
    [self requestSpareData];
}
- (void)reloadResources{
    self.currentPage = 1;
    [self requestSpareData];
}

- (void)reloadNewResources{
    self.currentPage ++;
    [self requestSpareData];
}

- (void)requestSpareData
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"factory":self.factory?self.factory:@"",
                             @"boardName":self.boardName?self.boardName:@"",
                             @"boardType":self.boardType?self.boardType:@"",
                             @"pageIdx":@(_currentPage)
                             };
    
    NSString *modelName=@"FSMSparePart";
    NSString *methodName=@"FSMQuerySpareParts";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在获取备件列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            // 字典模型 转换成数组模型
            NSArray * spareArr = [SparePartList objectArrayWithKeyValuesArray:dic[@"sparePartList"]];
           
            if (self.currentPage == 1) {
                [self.sparePartListArray removeAllObjects];
            }
            
            [self.sparePartListArray addObjectsFromArray:spareArr];
            [self.tableView reloadData];
            
            // ？？？？？？？
            if (spareArr == nil || spareArr == 0) {
                self.currentPage --;
            }
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
        
        if (self.currentPage > 1) {
            self.currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

- (void)creatUI{
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];  
}

#pragma mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_sparePartListArray.count > 0) {
    return _sparePartListArray.count;//_dataArr.count;
    }else {
        return 0;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SparePartList * list = _sparePartListArray[indexPath.row];
    
    TwoLabelOneImgCell * cell = [TwoLabelOneImgCell cellWithTableView:tableView];
    cell.oneLabel.text = list.sparePartName;
    cell.twoLabel.text = list.sparePartType;
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 请求数据  ---> 成功后在进行跳转
    SparePartList * list = _sparePartListArray[indexPath.row];

//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
    Search_2ViewController * search_2 = [[Search_2ViewController alloc]init];
    search_2.latitude_2 = _latitude_1;
    search_2.longitude_2 = _longitude_1;
    search_2.spareList = list;
    [self.navigationController pushViewController:search_2 animated:YES];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _latitude_1 = userLocation.location.coordinate.latitude;
    _longitude_1 = userLocation.location.coordinate.longitude;
}


@end
