//
//  TechnicalManualDetailViewController.m
//  Ericsson
//
//  Created by 张永鹏 on 16/1/11.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "TechnicalManualDetailViewController.h"

@interface TechnicalManualDetailViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TechnicalManualDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [UIApplication sharedApplication].statusBarHidden = YES;
    [MBProgressHUD showMessage:@"正在跳转…"];
    self.title = @"详情";
    
    self.webView.scrollView.bounces = NO;//禁止回弹
    
    [self loadData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
//不让转屏
-(BOOL)shouldAutorotate{
    return NO;
}
//当前viewcontroller默认的屏幕方向 - 横屏显示
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

//加载数据
-(void)loadData{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@.android",self.urlStr]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    [MBProgressHUD hideHUD];
    
}
//返回按钮事件
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
