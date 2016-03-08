//
//  Search_3ViewController.m
//  Ericsson
//
//  Created by slark on 15/12/24.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "Search_3ViewController.h"
#import "Search_4ViewController.h"
#import "SparePartList.h"
#import "SparePartStoresModel.h"
#import "SparePartsAddedModel.h"

@interface Search_3ViewController ()
{
    NSString * _phoneNumber;
    __block BOOL isKeyboard;
    
}

@property (nonatomic,strong) NSMutableArray * dataArray;
@end
/**
 “distance”:””,  距离
 “storeNumber”:””,    库存量
 “storeroomName”:””,    仓库名称
 “storeroomId”:”“    仓库id
 */

@implementation Search_3ViewController
#pragma mark - set

#pragma mark - 系统
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"备件库存详情";
    isKeyboard = NO;
    // 数据初始化
    _phoneNumber = nil;
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self requsetData];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
// 通知键盘
- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    NSDictionary * userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // 取出控件的底边的值
    UIView *view = self.applicationNumber.superview;
    CGRect absoluteRect = [view convertRect:self.applicationNumber.frame toView:self.view];
    CGFloat bottom = CGRectGetMaxY(absoluteRect) + 64.0;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y >=  screenHeight) { // 键盘的Y值已经远远超过了控制器view的高度
            //            self.distinationText.y = self.view.height - self.distinationText.height;
            self.view.y = 64.0;
            isKeyboard = NO;
            
        }else if (keyboardF.origin.y < bottom){ // 如果键盘 遮盖住我的控件，就将控件上滑 ； 滑动的距离为
            
            if (isKeyboard) return ;
            CGFloat swipeHeight = bottom - keyboardF.origin.y + 15.0;
            self.view.y = self.view.y - swipeHeight;// - 64;
            isKeyboard = YES;
        }
    }];
}
- (void)requsetData
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"sparePartId":_spareList_3.sparePartId,
                             @"storeRoomId":_storeModel_3.storeroomId
                             };
    
    NSString *modelName=@"FSMSparePart";
    NSString *methodName=@"FSMQuerySparePartStoreDetail";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在获取已处理工单详情"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            // 请求成功 执行跳转
            _phoneNumber = dic[@"storeInfo"][@"phoneNumber"];
            [self setupUIData];
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        [MBProgressHUD hideHUD];
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
    
    
}

- (void)setupUIData{
    self.
    self.beijianNameLabel.text = _spareList_3.sparePartName;
    self.wareHouseLabel.text = _storeModel_3.storeroomName;
    self.warehouseNumberLabel.text = _storeModel_3.storeNumber;
    self.phoneNumberLabel.text = _phoneNumber;
}


- (IBAction)confirmClick:(id)sender {
    NSInteger applicationNum = [self.applicationNumber.text intValue];
    NSInteger warehouseNum = [self.warehouseNumberLabel.text intValue];
    
    if (applicationNum <= 0 || applicationNum > warehouseNum) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"填写正确的申请数量..." message:nil delegate:nil
                                              cancelButtonTitle:@"重新填写" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /**
        如果判断成果，就将数据写到沙盒中
        1.先判断 数据库中有没有此条 信息
        if 没有 {
        直接添加
     } else {
        删除  再 添加
     }
     
     */
    
    SparePartsAddedModel * model = [[SparePartsAddedModel alloc]init];
    model.sparePartName = self.spareList_3.sparePartName;
    model.sparePartType = self.spareList_3.sparePartType;
    model.spareApplyNum = self.applicationNumber.text;
    model.sparePartId   = self.spareList_3.sparePartId;
    
    
//    [LKDBHelper clearTableData:[SparePartsAddedModel class]];
 
    // 根据条件,查询数据库
    NSMutableArray * spareTypeArray=[[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:@"select *from @t" toClass:[SparePartsAddedModel class]];
    
    for (SparePartsAddedModel * addedModel in spareTypeArray) {
        if ([model.sparePartId isEqualToString:[NSString stringWithFormat:@"%@",addedModel.sparePartId]]) { // 如果没有就更新
            [SparePartsAddedModel deleteToDB:addedModel]; // 删除已有的
        }
    }
    // 保存同一个数据的最新请求
    [model saveToDB];
    
    Search_4ViewController * search4 = [[Search_4ViewController alloc]init];
    search4.applyNum        = self.applicationNumber.text;
    search4.spareList_4     = _spareList_3;
    search4.storeModel_4    = _storeModel_3;
    [self.navigationController pushViewController:search4 animated:YES];
    
}

#pragma mark - 系统
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_applicationNumber resignFirstResponder];
}

@end
