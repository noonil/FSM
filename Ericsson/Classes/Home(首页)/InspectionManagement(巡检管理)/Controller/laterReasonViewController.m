//
//  laterReasonViewController.m
//  Ericsson
//
//  Created by Slark on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "laterReasonViewController.h"
#import "PopupObjectList.h"
#import "OrderProcessingViewController.h"
#import "HandingDetailViewController.h"
#import "OrderProcessingViewController.h"
@interface laterReasonViewController ()<PopupObjectListDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)PopupObjectList * pop;
@property (nonatomic,copy)NSString * formId;
@property (nonatomic,strong) UIButton * submitBtn;
@end

@implementation laterReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"巡检稍后出发";
   
    _resonTypeTextField.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.button.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    _wordTextField.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [self requestData];
    
    _wordTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
    
    UIButton * submitBtn = [[UIButton alloc]init];
    submitBtn.backgroundColor = KBaseBlue;
    CGFloat submitBtnW = KIphoneWidth;
    CGFloat submitBtnH = 45;
    CGFloat submitBtnX = 0;
    CGFloat submitBtnY = KIphoneHeight - submitBtnH - 64;
    
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(submitBtnX, submitBtnY, submitBtnW, submitBtnH);
    [submitBtn addTarget:self action:@selector(submitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.submitBtn = submitBtn;
    [self.ffbutton addTarget:self action:@selector(ffClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)ffClick:(UIButton*)button{
    
    _pop = [[PopupObjectList alloc]initWithData:_dataArr selectedData:self.resonTypeTextField.text fromWhichObject:self.resonTypeTextField];
    
    _pop.delegate = self;
    
    [_pop presentPopupControllerAnimated];
    
    
}

// 通知键盘
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y >= self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.submitBtn.y = self.view.height - self.submitBtn.height;
        } else {
            self.submitBtn.y = keyboardF.origin.y - self.submitBtn.height - 64;
        }
    }];
}
-(void)tapGesture{
    [self.wordTextField resignFirstResponder];
    
}

//textView的委托方法   用于控制placeholder的显示
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        _placeholderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeholderLabel.hidden = NO;
    }
    
    return YES;
}


- (void)requestData{
    
 
    
    _dataArr = [[NSMutableArray alloc]initWithObjects:@"暂无时间处理",@"其他",@"自然灾害", nil];
    
    
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

- (IBAction)chooseClick:(id)sender {
  //  self.dataArr = [NSMutableArray array];
    _pop = [[PopupObjectList alloc]initWithData:_dataArr selectedData:self.resonTypeTextField.text fromWhichObject:self.resonTypeTextField];
    
    _pop.delegate = self;
    
    [_pop presentPopupControllerAnimated];
    
}

- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if (fromWhichObject == _resonTypeTextField) {
      
        _resonTypeTextField.text = _dataArr[row];
        
        
    }else{
        

        
    }
    
    self.reasonTypeId = _resonTypeTextField.text;
 
    
}



- (void)submitContent {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * userId = [defaults objectForKey:@"username"];
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMDepartLater";

    NSMutableArray * woIds = [[NSMutableArray alloc]init];
    NSString * reason = _wordTextField.text;
  
//    NSDictionary * dic = @{@"woId":self.woId};
//    [woIds addObject:dic];
//    NSLog(@"工单ID为::%@",woIds);
    
    if ([reason isEqualToString:@""] ) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请补充内容" message:@"请填写原因和类型" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
      
        [alert show];
        
    }else if ([self.resonTypeTextField.text isEqualToString:@""]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请补充内容" message:@"请填写原因和类型" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        
        [alert show];
        
        
    }
    
    
    else{
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        //[woIds addObject:@{@"woId":sameSiteOrder.woId}];
        
        NSDictionary * params = @{@"userId":userId,
                                  @"reason":reason,
                                  @"localTs":currentDateStr,
                                  @"processId":@0,
                                  @"operMBPS":@"稍后出发",
                                  @"taskName":@"出发",
                                  @"woIds":woIds,
                                  @"reasonId":self.reasonTypeId};
        
        
        NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
        
        [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
            [MBProgressHUD showMessage:@"正在请求数据"];
            if ([dic[@"retCode"] isEqual:@0]) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"请求成功"];
                self.formId = dic[@"formId"];
                
                OrderProcessingViewController * or = [[OrderProcessingViewController alloc]init];
                [self.navigationController pushViewController:or animated:YES];
                
                    NSMutableArray * navArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                    NSRange range = NSMakeRange(0, 2);
                    NSArray * subArr = [navArray subarrayWithRange:range];
                    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:subArr];
                    [array addObject:or];
                    [self.navigationController setViewControllers:array];
                
                
                
            }else if ([dic[@"retCode"] isEqual:@(-1)]){
                [self.navigationController.view makeToast:@"请求失败"];
            }else if([dic[@"retCode"] isEqual:@(-2)]){
                
                UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
                [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
                [self.navigationController.view makeToast:@"会话超时,请重新登录"];
                
                
            }
            
            
            
            
        } falure:^(NSError *response) {
            
            
            
            
        }];

        
        
        
    }
    

    
    
    
    
    
    
}
@end
