//
//  shareCodeViewController.m
//  Ericsson
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "shareCodeViewController.h"
#import "QRCode.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
@interface shareCodeViewController ()<UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic)UIImageView *imageview;

@end


@implementation shareCodeViewController{

    UIImage *img;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"分享应用";
    // Do any additional setup after loading the view from its nib.
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.imageview.center = CGPointMake(KIphoneWidth/2, (KIphoneHeight-200)/2);
    [self.shareView addSubview:self.imageview];
    [self json];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//分享应用
- (IBAction)sharebtn:(id)sender {

    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialQQHandler setQQWithAppId:QQAPPID appKey:QQAPPKEY url:@"http://fir.im/FSM"];
    [UMSocialWechatHandler setWXAppId:WECHATAPPID appSecret:WECHATAPPSECRET url:@"http://fir.im/FSM"];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAPPKEY
                                      shareText:@"快来一起分享FSM系统吧！"
                                     shareImage:img
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,nil]
                                       delegate:self];
    

//    [UMSocialConfig showNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];


}

-(void)json{

    img = [QRCode qrImageForString:downurl imageSize:200];
       //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    //NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
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
    
//    [MBProgressHUD showMessage:@"正在请求最新版本信息"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
//            [MBProgressHUD showSuccess:@"请求最新版本信息成功"];
//           downurl = dic[@"downLoadUrl"];
//            临时使用
          
            img = [QRCode qrImageForString:downurl imageSize:200];
            img = [QRCode addIconToQRCodeImage:img withIcon:[UIImage imageNamed:@"logo-60.png"] withScale:5];
            [self.imageview setImage:img];

            [self.imageview setImage:img];
            
            
            
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

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    
}
@end
