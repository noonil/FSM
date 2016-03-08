//
//  NetResourceInfoViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/3.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "NetResourceInfoViewController.h"
#import "TwoLabelHorizontalCell.h"
#import "NetResourceEditViewController.h"
#import "MatainObjectBaseInfo.h"
#import "HeadView.h"

@interface NetResourceInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    NSString *tableName;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HeadView *headView;
@property (strong, nonatomic) NSMutableArray *baseInfoArray;

- (IBAction)backBtn_TouchUpInside:(id)sender;
- (IBAction)continueBtn_TouchUpInside:(id)sender;

@end

@implementation NetResourceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];

    [self loadData];
}
-(void)setOthers{
    [self tableView];
    self.title=@"查询";
    self.headView.oneLabel.text=_matainObject.maintenanceObjectName;
    
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [[self navigationItem] setLeftBarButtonItem:leftItem];

}
-(void)back{
    if (self.handlingOrderDetail!=nil) {
        _handlingOrderDetail.popButtonView.hidden=NO;
    }
    else if (self.handledOrderDetail!=nil) {
        _handledOrderDetail.popButtonView.hidden=NO;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - loadData

- (void) loadData
{
    //请求数据示例
    
    NSDictionary *params = @{@"userId":userId,
                             @"maintenanceId":_matainObject.maintenanceId,
                             @"maintenanceTypeId":self.matainObject.maintenanceObjectType,
                             @"tableName":_matainObject.tablename?_matainObject.tablename:@""
                             };
    
    NSLog(@"params=%@", params);
    
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMGetMObjectDetail" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];

        if ([dic[@"retCode"]  isEqual: @0]) {
            tableName=dic[@"tablename"];
            NSMutableArray *baseInfoArr= [MatainObjectBaseInfo objectArrayWithKeyValuesArray:dic[@"maintenanceDetail"][@"baseInfos"]];
            
            //遍历数组，基站id不可以修改，所以删除基站id这项数据
            for (MatainObjectBaseInfo *model in baseInfoArr) {
                if ([model.fieldChName isEqualToString:@"基站ID"]) {
                    [baseInfoArr removeObject:model];
                    break;
                }
            }
            
            if (baseInfoArr!=nil) {
                [self.baseInfoArray removeAllObjects];
                [_baseInfoArray addObjectsFromArray:baseInfoArr];
                [_tableView reloadData];
            }
        }
        else if ([dic[@"retCode"]  isEqual: @(-1)]) {
            [self.view makeToast:KHudResponse1];
        }
        else if ([dic[@"retCode"]  isEqual: @(-2)]) {
            [self.view makeToast:KHudResponse2];
        }
        else  {
            [self.view makeToast:@"返回其他错误"];
        }
        

        
        
        
        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];

        [self.view makeToast:KHudErrorMessage];

        
    }
     ];
    
}


#pragma mark - table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _baseInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MatainObjectBaseInfo *baseInfo=_baseInfoArray[indexPath.row];


    TwoLabelHorizontalCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TwoLabelHorizontalCell"];
    cell.oneLabel.text=baseInfo.fieldChName;
    cell.twoLabel.text=baseInfo.showOldData;
    
    if (baseInfo.chooseFlag==true) {
        [cell chooseCell];
    }
    else
        [cell notChooseCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MatainObjectBaseInfo *baseInfo=_baseInfoArray[indexPath.row];
    
    if (baseInfo.chooseFlag==false) {
        baseInfo.chooseFlag=true;
    }
    else{
        
        baseInfo.chooseFlag=false;
    }
    [tableView reloadData];
}


#pragma mark -get/set



-(UITableView *)tableView{


    _tableView.delegate=self;
    _tableView.dataSource=self;
//    [_tableView registerClass:[Cell1 class] forCellReuseIdentifier:@"cell"];
    UINib *nib = [UINib nibWithNibName:@"TwoLabelHorizontalCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"TwoLabelHorizontalCell"];

    return _tableView
    ;
    
}


-(NSMutableArray *)baseInfoArray{
    if (_baseInfoArray==nil) {
        _baseInfoArray=[[NSMutableArray alloc]init];
        
    }
    return _baseInfoArray;


}


#pragma mark -touch up inside

- (IBAction)backBtn_TouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueBtn_TouchUpInside:(id)sender {
    //把这次请求到的tablename，赋值给model
    _matainObject.tablename=tableName;
    
    NetResourceEditViewController *vc=[NetResourceEditViewController new];
    
    vc.matainObject=_matainObject;
    vc.dataArray=[self.baseInfoArray mutableCopy];

    for (int i=0; i<self.baseInfoArray.count; i++) {
        MatainObjectBaseInfo *baseInfo=self.baseInfoArray[i];
        if (baseInfo.chooseFlag==false) {
            [vc.dataArray removeObject:baseInfo];
        }
        else{
            baseInfo.showChgData=@"";
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
