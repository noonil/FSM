//
//  AddAnnoucneTitleVC.m
//  Ericsson
//
//  Created by Min on 15/12/25.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AddAnnoucneTitleVC.h"

#define NavigationBarHeight 64
#define KBaseGray   [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]


@interface AddAnnoucneTitleVC ()
@property (weak, nonatomic)  UITextView *contentTextView;
@property (weak, nonatomic)  UIButton *submitBtn;

@end

@implementation AddAnnoucneTitleVC

#pragma mark set/get
- (void)setTitleVC:(NSString *)titleVC
{
    _titleVC = titleVC;
    self.title = titleVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // setup
    [self setUpUI];
    [self.contentTextView becomeFirstResponder];
//
}
- (void)setUpUI
{
    

    UITextView * contentV = [[UITextView alloc]init];
    CGFloat contentVX = 20;
    CGFloat contentVY = 30;
    CGFloat contentVW = KIphoneWidth - 2 * contentVX;
    CGFloat contentVH = 300;

    [contentV setBackgroundColor:KBaseGray];
    [contentV becomeFirstResponder];
    [contentV setFont:[UIFont systemFontOfSize:22]];
    
    contentV.frame = CGRectMake(contentVX, contentVY, contentVW, contentVH);
    [self.view addSubview:contentV];
    self.contentTextView = contentV;
    
    UIButton * submitBtn = [[UIButton alloc]init];
    submitBtn.backgroundColor = KBaseBlue;
    CGFloat submitBtnW = KIphoneWidth;
    CGFloat submitBtnH = 60;
    CGFloat submitBtnX = 0;
    CGFloat submitBtnY = KIphoneHeight - submitBtnH;
    
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:29];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(submitBtnX, submitBtnY, submitBtnW, submitBtnH);
    [submitBtn addTarget:self action:@selector(submitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
     self.contentTextView.text = self.titleContent;
    
    
    
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
            self.submitBtn.y = keyboardF.origin.y - self.submitBtn.height - NavigationBarHeight;
        }
    }];
}

// 确认按钮
- (void)submitContent
    {
    [self.delegate submitBtnSelected:self.contentTextView.text];

    [self.navigationController popViewControllerAnimated:YES];
}


@end
