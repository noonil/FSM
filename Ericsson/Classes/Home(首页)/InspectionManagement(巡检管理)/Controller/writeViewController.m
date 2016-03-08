//
//  writeViewController.m
//  Ericsson
//
//  Created by Slark on 16/1/9.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "writeViewController.h"
#import "ShareManager.h"
@interface writeViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UIButton * submitBtn;

@end


@implementation writeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检阶段反馈内容";
    // Do any additional setup after loading the view from its nib.
    
    UIButton * submitBtn = [[UIButton alloc]init];
    submitBtn.backgroundColor = KBaseBlue;
    CGFloat submitBtnW = KIphoneWidth;
    CGFloat submitBtnH = 60;
    CGFloat submitBtnX = 0;
    CGFloat submitBtnY = KIphoneHeight - submitBtnH - 64;
    
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:29];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(submitBtnX, submitBtnY, submitBtnW, submitBtnH);
    [submitBtn addTarget:self action:@selector(submitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
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

- (void)submitContent {
    
//    [self.delegate sendBackstring:self.writeText.text];
    ShareManager *shareManager = [ShareManager sharedManager];
    shareManager.titleText = self.writeText.text;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
