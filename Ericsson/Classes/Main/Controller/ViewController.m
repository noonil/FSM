//
//  ViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/9/28.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "UpdateVersionViewController.h"
#import "BkView.h"
#import "TimerService.h"
#import "BPush.h"

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)BkView *bkView;



@property (weak, nonatomic) IBOutlet UITextField *UserField;
@property (weak, nonatomic) IBOutlet UITextField *PwdField;
@property (weak, nonatomic) IBOutlet UIButton *checkedBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;


- (IBAction)ChoosePwd:(UIButton *)sender;
- (IBAction)EndUserEditing:(id)sender;
- (IBAction)EndPwdEditing:(id)sender;
- (IBAction)Login:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (result) {
            
        }
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bkviewRemove:) name:@"removeBkView" object:nil];
    if (!self.isFromSetting) {
        [self json];
        self.isFromSetting = NO;
    }
    self.loginBtn.layer.cornerRadius = 4.f; //登录按钮的转角
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"document-- %@",[paths lastObject]);
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    [self setOthers];
    
    [self addTapGesture];
    
    [self addNotafication];
}




#pragma mark -初始化方法

-(void)setOthers{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.UserField.text = [userDefaults objectForKey:@"username"];
    self.UserField.delegate = self;
    self.PwdField.delegate = self;
    self.checkedBtn.selected = [userDefaults boolForKey:@"pwdRemembered"];
    if (self.checkedBtn.selected) {
        self.UserField.text = [userDefaults objectForKey:@"username"];
        self.PwdField.text = [userDefaults objectForKey:@"password"];
    }else{
        self.UserField.text = @"";
        self.PwdField.text = @"";
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homebackground"]];
    
    //设置用户名输入框左边视图
    UIImageView *UserleftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    UserleftImage.contentMode = UIViewContentModeCenter;
    UserleftImage.frame = CGRectMake(0, 0, 35, 0);
    self.UserField.leftView = UserleftImage;
    self.UserField.placeholder = @"用户名";
    self.UserField.leftViewMode = UITextFieldViewModeAlways;
    
    //设置密码输入框右边视图
    UIImageView *PwdleftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    PwdleftImage.contentMode = UIViewContentModeCenter;
    PwdleftImage.frame = CGRectMake(0, 0, 35, 0);
    self.PwdField.leftView = PwdleftImage;
    self.PwdField.placeholder = @"密码";
    self.PwdField.leftViewMode = UITextFieldViewModeAlways;
    
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text =[NSString stringWithFormat:@"版本号:%@",myVersion];
    self.copyrightLabel.text = @"Copyright ©爱立信(中国)通信有限公司";

}

-(void)addTapGesture{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}

-(void) addNotafication{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -键盘隐藏

//注册键盘出现消失通知
- (void)keyboardWillShow:(NSNotification *)notification
{
//    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];



}

//键盘将要消失的通知回调方法
- (void)keyboardWillHide:(NSNotification *)notification
{


}



//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect rect=self.view.frame;
//    NSLog(@"rect before=%@",NSStringFromCGRect(rect));
//
//    rect.origin.y-=200;
//    
//    self.view.frame=rect;
//    NSLog(@"rect after=%@",NSStringFromCGRect(self.view.frame));


    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    CGRect rect=self.view.frame;
//
//    rect.origin.y+=200;
//    
//    self.view.frame=rect;
    
}

#pragma mark -

-(void)bkviewRemove:(NSNotification *)notify{
    [self.bkView removeFromSuperview];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)handleSingleTap{
    [_UserField resignFirstResponder];
    [_PwdField resignFirstResponder];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ChoosePwd:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)EndUserEditing:(id)sender {
    [self.PwdField becomeFirstResponder];
}

- (IBAction)EndPwdEditing:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)Login:(id)sender {
    


    //判断是否需要保存密码，如果需要则存入偏好设置
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId=[self.UserField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password=self.PwdField.text;
    [userDefaults setObject:userId forKey:@"username"];//冗余数据
    [userDefaults setObject:userId forKey:@"userId"];
    [userDefaults setBool:self.checkedBtn.selected forKey:@"pwdRemembered"];
    
    if (self.checkedBtn.selected) {
        [userDefaults setObject:password forKey:@"password"
         ];
    }
    [userDefaults synchronize];
    
    [MBProgressHUD showMessage:@"正在登陆……"];
    
    
    //请求数据示例
    NSDictionary *dictionary= [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"2012-08-08 22:47:11",@"syncLast_ts",
                                   @"000000000000000-HTC One X - 4.2.2 - API 17 - 720x1280",@"mUid",
                                   password,@"pwd",
                                   @"zh_CN",@"locale",
                                   userId,@"userId",
                                   nil];
    

    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMBase" methodName:@"FSMLogin" sessonId:@"" requestData:dictionary];
    
    
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([[dic objectForKey:@"loginResult"] longValue] == 0) {
            //登陆成功保存sessionID
            [defaults setObject:dic[@"sessionId"] forKey:@"sessionId"];
            [defaults setObject:dic[@"property"] forKey:KKProperty];
            
            [defaults synchronize];
//            登陆成功后绑定推送
            [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
                //        [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
                // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
                if (result) {
                    [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                        if (result) {
                            NSLog(@"设置tag成功");
                            [self pushUserIDAndChannelID];
                        }
                    }];
                }
            }];
            

            //登陆成功后，定时上传经纬度
            [[TimerService shareInstance]fireTimer];
            
            MainViewController *main = [[MainViewController alloc] init];
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:main animated:YES completion:nil];
        }
        else{
            [self.view makeToast:KHudResponse1];

        }
        

        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];

        [self.view makeToast:KHudErrorMessage];
    }];
}


#pragma -mark- 百度云推送：本机和服务器端进行交互
-(void)pushUserIDAndChannelID{
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    //如果 sessionId 为nil，把user01的 sessionId 值赋给它
    if (!sessionId) {
       return;
    }
    
    
    NSDictionary *params = @{
                             @"baiDuUserId":[BPush getUserId],
                             @"channelId":[BPush getChannelId],
                             @"deviceType":@"4"};
    NSString *modelName=@"FSMBaiDuMessage";
    NSString *methodName=@"FSMBindBaiDuUserAccout";
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"] isEqual:@0]) {
            
            
            
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"推送连接失败"];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            [MBProgressHUD showError:@"推送连接失败"];
            
        }
    } falure:^(NSError *err) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"推送连接失败:%@",err]];
    }];
}



-(void)json{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    //NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    //如果 sessionId 为nil，把user01的 sessionId 值赋给它
    if (!sessionId) {
        sessionId = @"5CCFA85958881ECD0BA20EF018BDC0C4";
    }
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSArray *arr = [myVersion componentsSeparatedByString:@"."];
    long myversionNum = [arr[0] intValue]*10000+[arr[1] intValue]*100+[arr[2] intValue];
    NSString *myVersionStr = [NSString stringWithFormat:@"%ld",myversionNum];
    NSDictionary *params = @{@"sessionId":sessionId,
                             @"appVersion":myVersionStr,
                             @"appType":@"1"};
    NSString *modelName=@"FSMBase";
    NSString *methodName=@"FSMVersionCheck";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在请求最新版本信息"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"请求最新版本信息成功"];
            
            NSString *current_version=[dic objectForKey:@"hasNewVersion"];
            int i=[current_version intValue];
            if (i<1) {
//                [self updatealert];
            }else{
                
                UpdateVersionViewController *updateversion=[[UpdateVersionViewController alloc]initWithNibName:@"UpdateVersionViewController" bundle:nil];
                updateversion.updatedic=[dic mutableCopy];
                updateversion.view.center = self.view.center;
                BkView *bkview = [[BkView alloc]init];
                bkview.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                [bkview addSubview:updateversion.view];
                self.bkView = bkview;
                [self addChildViewController:updateversion];
                [self.view addSubview:self.bkView];
            }
            
            
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"请求最新版本信息失败"];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"请求最新版本信息超时，请重新请求"];
            
        }
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"尝试最新版本信息发送失败,err:%@",err]];
    }];
    
}



@end
