//
//  TechnicalManualViewController.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/4.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "TechnicalManualViewController.h"
#import "PopupObjectList.h"
#import "TechnicalManualList.h"
#import "TechTypes.h"
#import "TechFactories.h"
#import "TechModels.h"

@interface TechnicalManualViewController ()<PopupObjectListDelegate>{
    PopupObjectList *pop;
    
    NSMutableArray *techTypeNameArr; //存放所有的类型名
    NSMutableArray *typeIdArr; //存放所有的类型ID
    NSString *typeIdStr; //类型的ID 传到下个页面 —— 查询所需的参数
    
    NSMutableArray *factoryNameArr; //厂商名
    NSMutableArray *factoryIdArr;   //厂商Id
    NSString *factoryIdStr;
    
    NSMutableArray *techModelNameArr; //型号名
    NSMutableArray *techModelIdArr;   //型号Id
    NSString *techModelIdStr;
}
@property (weak, nonatomic) IBOutlet UITextField *techType;//技术类型（选择后用于显示结果）
@property (weak, nonatomic) IBOutlet UITextField *techFactory;//厂商
@property (weak, nonatomic) IBOutlet UITextField *techModel;//型号

@property (nonatomic, strong) TechnicalManualList *tmList;

@end

@implementation TechnicalManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"技术手册";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self loadFromDb];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [leftItem setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setLeftBarButtonItem:leftItem];
}


//其他模块的快捷入口，返回时做判断
-(void)back{
    
    if (self.handlingOrderDetail!=nil) {
        _handlingOrderDetail.popButtonView.hidden=NO;
    }
    else if (self.handledOrderDetail!=nil) {
        _handledOrderDetail.popButtonView.hidden=NO;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//从本地数据库加载数据
-(void)loadFromDb{
    techTypeNameArr = [NSMutableArray new];
    typeIdArr = [NSMutableArray new];
    
    NSMutableArray *techTypeArr = [[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:@"select *from @t" toClass:[TechTypes class]];
    
    for (int i = 0; i < techTypeArr.count; i++) {
        TechTypes *model = (TechTypes*)techTypeArr[i];
        [techTypeNameArr addObject:model.typeName];
        [typeIdArr addObject:model.typeId];
    }
}

//类型选择
- (IBAction)chooseType_TouchUpInside:(UIButton *)sender {
    pop = [[PopupObjectList alloc] initWithData:techTypeNameArr selectedData:_techType.text fromWhichObject:_techType];
    pop.delegate = self;
    [pop presentPopupControllerAnimated];
}

//厂商选择
- (IBAction)chooseFactory_TouchUpInside:(UIButton *)sender {
    factoryNameArr = [NSMutableArray new];
    factoryIdArr = [NSMutableArray new];
    
    if (typeIdStr) {
        
        NSMutableArray *factoryArr = [[MyLKDBHelper getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select factory,record_id from @t where typeId ='%@'",typeIdStr] toClass:[TechFactories class]];
        
        [factoryNameArr removeAllObjects];
        [factoryIdArr removeAllObjects];
        
        for (int i = 0; i < factoryArr.count; i++) {
            TechFactories *model = (TechFactories *)factoryArr[i];
            if (model.factory) {
                [factoryNameArr addObject:model.factory];
                [factoryIdArr addObject:model.record_id];
            }
        }
        
        if (factoryNameArr.count != 0) {
            pop = [[PopupObjectList alloc] initWithData:factoryNameArr selectedData:_techFactory.text fromWhichObject:_techFactory];
            pop.delegate = self;
            [pop presentPopupControllerAnimated];
        }
        else{
            [self.view makeToast:@"厂商数据为空"];
        }
    }
    
    else{
        [self.view makeToast:@"请先选择类型"];
    }
    
}
//型号选择
- (IBAction)chooseModel_TouchUpInside:(UIButton *)sender {
    techModelNameArr = [NSMutableArray new];
    techModelIdArr = [NSMutableArray new];
    
    if (factoryIdStr) {
        NSMutableArray *techModelArr = [[MyLKDBHelper getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select model,record_id from @t where typeId ='%@' and factoryId = '%@'",typeIdStr,factoryIdStr] toClass:[TechModels class]];
        
        [techModelNameArr removeAllObjects];
        [techModelIdArr removeAllObjects];
        
        for (int i = 0; i < techModelArr.count; i++) {
            TechModels *model = (TechModels *)techModelArr[i];
            [techModelNameArr addObject:model.model];
            [techModelIdArr addObject:model.record_id];
        }
        
        if (techModelNameArr) {
            pop = [[PopupObjectList alloc] initWithData:techModelNameArr selectedData:_techModel.text fromWhichObject:_techModel];
            pop.delegate = self;
            [pop presentPopupControllerAnimated];
        }
        else{
            [self.view makeToast:@"型号数据数据为空"];
        }
    }
    
    else{
        [self.view makeToast:@"请先选择厂商"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --弹出框代理方法
-(void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if (fromWhichObject == _techType) {
        _techType.text = techTypeNameArr[row];
        typeIdStr = typeIdArr[row];
        
        _techFactory.text = @"";
        factoryIdStr = nil;
        _techModel.text = @"";
        techModelIdStr = nil;
    }
    else if (fromWhichObject == _techFactory){
        _techFactory.text = factoryNameArr[row];
        factoryIdStr = factoryIdArr[row];
        
        _techModel.text = @"";
        techModelIdStr = nil;
    }
    else{
        _techModel.text = techModelNameArr[row];
        techModelIdStr = techModelIdArr[row];
    }
}

//查询
- (IBAction)selectBtn_TouchUpInside:(UIButton *)sender {
    if ([_techType.text isEqualToString:@""]||[_techFactory.text isEqualToString:@""]||[_techModel.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入所有查询条件"];
    }
    else{
        _tmList = [[TechnicalManualList alloc] init];
        _tmList.techTypeId = typeIdStr;
        _tmList.factoryId = factoryIdStr;
        _tmList.techModelId = techModelIdStr;
        
        [self.navigationController pushViewController:_tmList animated:YES];
    }
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
