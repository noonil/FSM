//
//  Search_2ViewController.m
//  Ericsson
//
//  Created by slark on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "Search_2ViewController.h"
#import "Search_3ViewController.h"
#import "ThreeLabelCell.h"
#import "SparePartStoresModel.h"
#import "Search_2TableViewCell.h"
#import "SparePartList.h"
#import <CoreLocation/CoreLocation.h>

@interface Search_2ViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 根据id请求数据的 模型数组 */
@property (nonatomic,strong) NSMutableArray * spareStoreListArray;
/** 经度 */
@property (nonatomic,strong) NSString * longitude;
/** 纬度 */
@property (nonatomic,strong) NSString * latitude;

@end

@implementation Search_2ViewController
#pragma mark - Lazy
- (NSMutableArray*)spareStoreListArray
{
    if (_spareStoreListArray) {
        _spareStoreListArray = [[NSMutableArray alloc]init];
    }
    return _spareStoreListArray;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
   
    self.navigationItem.title = @"仓库库存列表";
    
    [self requsetData];
    
}

- (void)requsetData
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
#warning 如果 _spareList.sparePartId 没有值的话，设置字典会报错。 可以在_spareList.sparePartId的set方法中 来请求数据
    
    NSDictionary *params = @{@"sparePartId":_spareList.sparePartId,
                             @"longitude":[NSString stringWithFormat:@"%f",_longitude_2],
                             @"latitude":[NSString stringWithFormat:@"%f",_latitude_2],
                             @"pageIdx":@(1)
                             };
    
    NSString *modelName=@"FSMSparePart";
    NSString *methodName=@"FSMQuerySparePartStores";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在获取已处理工单详情"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            // 字典模型 转换成数组模型
            _spareStoreListArray = [SparePartStoresModel objectArrayWithKeyValuesArray:dic[@"sparePartStoreList"]];
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
- (void)createUI
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.employmentNameLabel.text = _spareList.sparePartName;
    
}
#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_spareStoreListArray.count > 0) {
//        return _spareStoreListArray.count;
//    }
//    return 1;
    return _spareStoreListArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SparePartStoresModel * storeModel  = _spareStoreListArray[indexPath.row];
    
    Search_2TableViewCell *cell = [Search_2TableViewCell cellWithTableView:tableView];
    
    cell.storeroomName.text = storeModel.storeroomName;
    cell.storeNumber.text   = storeModel.storeNumber;
    cell.distance.text      = storeModel.distance;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SparePartStoresModel * storeList = _spareStoreListArray[indexPath.row];
    
    Search_3ViewController * search = [[Search_3ViewController alloc]init];
    search.storeModel_3 = storeList;
    search.spareList_3 = _spareList;
    
    [self.navigationController pushViewController:search animated:YES];
        
}

- (IBAction)RefreshClick:(id)sender {
    // 从新请求
    [self requsetData];
}
@end
