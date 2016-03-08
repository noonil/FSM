//
//  ApplyStateDetail.m
//  Ericsson
//
//  Created by xuming on 15/12/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ApplyStateDetail.h"
#import "MJExtension.h"
#import "NetResourceApplyChange.h"
#import "ThreeLabelCell.h"
#import "TwoLabelWithButton.h"
#import "AttributeModifyInfo.h"

@interface ApplyStateDetail ()<TwoLabelViewButtonDelegate>
{
    NSString *sessonId;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)int currentPage;   //记录当前页码
@property (nonatomic, strong)NSMutableDictionary *showFlagDic;

@end

@implementation ApplyStateDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setOthers];
    
    [self loadData:_recordId];
    
}

-(void)setOthers{
    self.title = @"资源属性变更明细";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.currentPage = 1;
    
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData) ];
    
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    sessonId = [defaulsts objectForKey:@"sessionId"];

}

-(void)refreshData{
    self.currentPage = 1;

    [self loadData:_recordId];

}



#pragma mark -request Data
- (void)loadData:(NSString *)recordId
{
    //请求数据示例
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    
    NSDictionary *params = @{@"recordId":recordId, @"pageIdx":@(self.currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMQueryAttrApplyState" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        [self.tableView headerEndRefreshing];

        
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSMutableArray *dataArray = [AttributeModifyInfo objectArrayWithKeyValuesArray:dic[@"attrApplyStateList"]];
            
            [_dataArray removeAllObjects];
            self.dataArray=dataArray;
            [_tableView reloadData];
        }
        else if ([dic[@"retCode"]  isEqual: @(-1)]) {
            [self.view makeToast:KHudResponse1];
            
        }
        else if ([dic[@"retCode"]  isEqual: @(-2)]) {
            
            [self.view makeToast:KHudResponse2];
            
        }
        

        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.tableView headerEndRefreshing];

        
        [self.view makeToast:KHudErrorMessage];
        
    }];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray == nil) {
        return 0;
    }
    
    if ([[self.showFlagDic objectForKey:[NSString stringWithFormat:@"%ld",section]] isEqual:@0]) {
        return 0;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TwoLabelWithButton *headView = [TwoLabelWithButton twoLabelWithButton];
    headView.delegate=self;
    
    AttributeModifyInfo *model=_dataArray[section];
    headView.attributeName.text=model.attrName;
    headView.state.text=model.applyState;
    headView.section=section;
    

    if ([[self.showFlagDic objectForKey:[NSString stringWithFormat:@"%ld",section]] isEqual:@0]) {
        headView.imgView.image = [UIImage imageNamed:@"downpoint"];
    }else
        headView.imgView.image = [UIImage imageNamed:@"uppoint"];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttributeModifyInfo *model = self.dataArray[indexPath.section];
    
//    ThreeLabelCell *cell = [ThreeLabelCell cellWithTableView:tableView];
//    cell.resourchNameLabel.text = model.remark;
    
    static NSString *idd=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.textLabel.font= [UIFont systemFontOfSize:15.0];;
    cell.textLabel.text=[NSString stringWithFormat:@"老数据：%@, 新数据：%@, 备注：%@", model.oldData, [model theNewData], model.remark];
 
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    WorkOrder *order = self.dataArray[indexPath.row];
    //
    //    HandlingOrderDetailController *detailOrder = [[HandlingOrderDetailController alloc] initWithNibName:@"HandlingOrderDetailController" bundle:nil];
    //    detailOrder.woId = order.woId;
    //    detailOrder.isGetFinishDetail = false;
    //    detailOrder.workOrder = order;
    //    [self.navigationController pushViewController:detailOrder animated:YES];
}



#pragma mark - TwoLabelViewButtonView Delegate

-(void)twoLabelViewButtonViewClick:(NSInteger)section{
    //做收缩切换
    NSNumber *flag = [self.showFlagDic objectForKey:[NSString stringWithFormat:@"%ld",section]];
    if ([flag isEqual:@0]) {
        flag = @1;
    }else{
        flag = @0;
    }
    
    [self.showFlagDic setObject:flag forKey:[NSString stringWithFormat:@"%ld",section]];
    [self.tableView reloadData];
}



#pragma mark -other
-(NSMutableDictionary *)showFlagDic{
    if (!_showFlagDic) {
        _showFlagDic = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < _dataArray.count; i++) {
            [_showFlagDic setObject:@0 forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _showFlagDic;
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
