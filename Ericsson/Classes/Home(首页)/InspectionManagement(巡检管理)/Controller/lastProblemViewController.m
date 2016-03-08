//
//  lastProblemViewController.m
//  Ericsson
//
//  Created by Slark on 16/1/11.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "lastProblemViewController.h"

@interface lastProblemViewController ()
@property (strong ,nonatomic) UIButton * submitBtn;
@end

@implementation lastProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检工单遗留问题";
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

- (void)submitContent {
    
    [self.delegate sendlastMessage:self.lastProblem.text];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
