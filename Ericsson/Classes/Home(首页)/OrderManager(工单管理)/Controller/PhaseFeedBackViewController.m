//
//  PhaseFeedBackViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/2.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#define InputContentFont [UIFont systemFontOfSize:15]

#import "PhaseFeedBackViewController.h"
#import "PhaseFeedBackDescInputViewController.h"
#import "WorkOrderStep.h"
#import "WorkOrder.h"

@interface PhaseFeedBackViewController ()<PhaseFeedBackDescInputDelegate>

@end

@implementation PhaseFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.InputContentLabel.font = InputContentFont;
    self.InputContentLabel.numberOfLines = 0;
    self.title=@"阶段反馈";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)InputFeedBack:(UIButton *)sender {
    PhaseFeedBackDescInputViewController *input = [[PhaseFeedBackDescInputViewController alloc] init];
    input.delegate = self;
    input.content = self.InputContentLabel.text;
    [self.navigationController pushViewController:input animated:YES];
}

#pragma mark - PhaseFeedBackDescInputDelegate
-(void)PhaseFeedBackDescInputWithContent:(NSString *)content{
    CGSize size = [self sizeWithText:content font:InputContentFont maxW:self.InputContentLabel.frame.size.width];
    self.InputContentLabelHeight.constant = size.height + 5;
    self.InputContentLabel.text = content;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/**
 *  附件上传
 *
 *  @param sender Tag 为 31 32 33 34;
 */
- (IBAction)accessoryUploading:(UIButton *)sender {
    
    switch (sender.tag) {
        case 31: // 图片上传
            
            break;
        case 32: // 文件上传
            
            break;
        case 33: // 音乐上传
            
            break;
        case 34: // 视频上传
            
            break;
    }
    
    
}
- (void)photoUploading
{

}
- (void)fileUploading
{
    
}
- (void)soundUploading
{
    
}
- (void)videoUploading
{
    
}

- (IBAction)PhaseFeedBackCommit:(UIButton *)sender {
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *params = @{@"userId":userId,@"woId":self.workOrder.woId,@"stepId":@"阶段性反馈",@"feedBackRemark":self.InputContentLabel.text,@"time":currentDateStr,@"operMBPS":@"阶段性反馈"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMPostAttachInfo";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送阶段反馈请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
//        NSLog(@"dic:%@",dic);
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController.view makeToast:@"请求成功"];

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

@end
